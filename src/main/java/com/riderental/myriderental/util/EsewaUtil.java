package com.riderental.myriderental.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * Utility class for integrating with the eSewa payment gateway.
 */
public final class EsewaUtil {

    private static final DateTimeFormatter TRANSACTION_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    /**
     * Private constructor to prevent instantiation of utility class.
     */
    private EsewaUtil() {
    }

    /**
     * Formats a double amount to a valid eSewa string format.
     *
     * @param amount the amount to format
     * @return formatted amount string
     */
    public static String formatAmount(double amount) {
        return formatAmount(BigDecimal.valueOf(amount));
    }

    /**
     * Formats a BigDecimal amount to a valid eSewa string format.
     *
     * @param amount the amount to format
     * @return formatted amount string
     */
    public static String formatAmount(BigDecimal amount) {
        if (amount == null) {
            throw new IllegalArgumentException("Amount cannot be null");
        }

        if (amount.signum() < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }

        BigDecimal normalized = amount.setScale(2, RoundingMode.HALF_UP).stripTrailingZeros();
        String text = normalized.toPlainString();
        return text.contains(".") ? text : text + ".0";
    }

    /**
     * Generates a unique transaction UUID based on the booking ID and timestamp.
     *
     * @param bookingId the booking ID
     * @return generated transaction UUID
     */
    public static String generateTransactionUuid(String bookingId) {
        String safeBookingId = sanitizeIdentifier(bookingId);
        String timestamp = LocalDateTime.now().format(TRANSACTION_TIME_FORMAT);
        String randomSuffix = UUID.randomUUID().toString().replace("-", "").substring(0, 10);
        return safeBookingId + "-" + timestamp + "-" + randomSuffix;
    }

    /**
     * Creates an HMAC SHA256 signature for eSewa API payload.
     *
     * @param secretKey the secret key
     * @param fields the map of fields
     * @param signedFieldNames a comma-separated list of field names to sign
     * @return Base64 encoded signature
     */
    public static String createSignature(String secretKey, Map<String, String> fields, String signedFieldNames) {
        Objects.requireNonNull(secretKey, "secretKey");
        String signingString = buildSigningString(fields, signedFieldNames);

        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKeySpec);
            byte[] rawSignature = mac.doFinal(signingString.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(rawSignature);
        } catch (GeneralSecurityException e) {
            throw new IllegalStateException("Unable to generate eSewa signature", e);
        }
    }

    /**
     * Builds a string of signed fields formatted for signature generation.
     *
     * @param fields the map of fields
     * @param signedFieldNames a comma-separated list of field names
     * @return the formatted signing string
     */
    public static String buildSigningString(Map<String, String> fields, String signedFieldNames) {
        Objects.requireNonNull(fields, "fields");
        if (signedFieldNames == null || signedFieldNames.isBlank()) {
            throw new IllegalArgumentException("signedFieldNames cannot be blank");
        }

        String[] fieldNames = signedFieldNames.split(",");
        StringBuilder builder = new StringBuilder();
        boolean firstSignedField = true;

        for (String rawFieldName : fieldNames) {
            String fieldName = rawFieldName.trim();
            if (fieldName.isEmpty()) {
                continue;
            }

            if (!fields.containsKey(fieldName)) {
                throw new IllegalArgumentException("Missing required signed field: " + fieldName);
            }

            if (!firstSignedField) {
                builder.append(',');
            }
            firstSignedField = false;
            builder.append(fieldName).append('=').append(Objects.toString(fields.get(fieldName), ""));
        }

        if (builder.isEmpty()) {
            throw new IllegalArgumentException("No signed fields were provided");
        }

        return builder.toString();
    }

    /**
     * Builds a URL query string from the provided parameters.
     *
     * @param parameters the map of query parameters
     * @return formatted query string
     */
    public static String buildQueryString(Map<String, String> parameters) {
        Objects.requireNonNull(parameters, "parameters");

        StringBuilder builder = new StringBuilder();
        boolean first = true;

        for (Map.Entry<String, String> entry : parameters.entrySet()) {
            if (!first) {
                builder.append('&');
            }
            first = false;

            builder.append(urlEncode(entry.getKey()))
                    .append('=')
                    .append(urlEncode(Objects.toString(entry.getValue(), "")));
        }

        return builder.toString();
    }

    /**
     * Reads all content from an input stream into a string.
     *
     * @param inputStream the input stream
     * @return the string content
     * @throws IOException if an I/O error occurs
     */
    public static String readFully(InputStream inputStream) throws IOException {
        if (inputStream == null) {
            return "";
        }

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            StringBuilder builder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                builder.append(line);
            }
            return builder.toString();
        }
    }

    /**
     * Extracts a string value from a simple JSON string based on a key.
     *
     * @param json the JSON string
     * @param key the key to extract
     * @return the extracted value, or null if not found
     */
    public static String extractJsonStringValue(String json, String key) {
        if (json == null || json.isBlank() || key == null || key.isBlank()) {
            return null;
        }

        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*(\"((?:\\\\.|[^\"\\\\])*)\"|([^,}\\s]+))");
        Matcher matcher = pattern.matcher(json);
        if (!matcher.find()) {
            return null;
        }

        String quotedValue = matcher.group(2);
        String rawValue = matcher.group(3);
        String value = quotedValue != null ? quotedValue : rawValue;
        return value == null ? null : unescapeJson(value);
    }

    /**
     * Checks if the provided status string represents a complete payment status.
     *
     * @param status the status string
     * @return true if the status is complete, false otherwise
     */
    public static boolean isCompleteStatus(String status) {
        if (status == null) {
            return false;
        }

        String normalized = status.trim().toUpperCase();
        return "COMPLETE".equals(normalized)
                || "SUCCESS".equals(normalized)
                || "SUCCESSFUL".equals(normalized)
                || "PAID".equals(normalized);
    }

    /**
     * Sanitizes an identifier to ensure it contains only safe characters.
     *
     * @param value the identifier to sanitize
     * @return the sanitized identifier
     */
    public static String sanitizeIdentifier(String value) {
        if (value == null || value.isBlank()) {
            return "txn";
        }

        String sanitized = value.trim().replaceAll("[^A-Za-z0-9_-]", "");
        return sanitized.isBlank() ? "txn" : sanitized;
    }

    /**
     * URL-encodes a string value.
     *
     * @param value the string to encode
     * @return the encoded string
     */
    private static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    /**
     * Unescapes a JSON string value.
     *
     * @param value the string to unescape
     * @return the unescaped string
     */
    private static String unescapeJson(String value) {
        return value
                .replace("\\\\", "\\")
                .replace("\\\"", "\"")
                .replace("\\n", "\n")
                .replace("\\r", "\r")
                .replace("\\t", "\t");
    }
}

