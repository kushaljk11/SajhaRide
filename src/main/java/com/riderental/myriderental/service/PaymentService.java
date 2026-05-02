package com.riderental.myriderental.service;

import com.riderental.myriderental.config.PaymentConfig;
import com.riderental.myriderental.model.PaymentRequest;
import com.riderental.myriderental.model.PaymentResponse;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.UUID;

/**
 * Service class for integrating with payment gateways (eSewa, Khalti).
 */
public class PaymentService {

    private static final DecimalFormat AMOUNT_FORMAT = new DecimalFormat("0.00");

    /**
     * Builds a payment request object for initiating an eSewa payment.
     *
     * @param bookingId the ID of the booking being paid for
     * @param amount the total amount to be paid
     * @return a PaymentRequest populated with eSewa-specific fields and signature
     */
    public PaymentRequest buildEsewaRequest(String bookingId, double amount) {
        String formattedAmount = formatAmount(amount);
        String transactionUuid = generateTransactionUuid(bookingId);
        String signature = generateEsewaSignature(
                formattedAmount,
                transactionUuid,
                PaymentConfig.ESEWA_PRODUCT_CODE
        );

        PaymentRequest request = new PaymentRequest();
        request.setGateway(PaymentConfig.ESEWA_GATEWAY);
        request.setBookingId(bookingId);
        request.setAmount(formattedAmount);
        request.setTaxAmount("0");
        request.setTotalAmount(formattedAmount);
        request.setTransactionUuid(transactionUuid);
        request.setProductCode(PaymentConfig.ESEWA_PRODUCT_CODE);
        request.setProductServiceCharge("0");
        request.setProductDeliveryCharge("0");
        request.setSuccessUrl(PaymentConfig.ESEWA_SUCCESS_URL);
        request.setFailureUrl(PaymentConfig.ESEWA_FAILURE_URL);
        request.setSignedFieldNames(PaymentConfig.ESEWA_SIGNED_FIELD_NAMES);
        request.setSignature(signature);
        request.setFormUrl(PaymentConfig.ESEWA_FORM_URL);

        return request;
    }

    /**
     * Verifies the status of an eSewa payment via a server-to-server API call.
     *
     * @param transactionUuid the unique transaction UUID associated with the payment
     * @param totalAmount the total amount that was expected to be paid
     * @return a PaymentResponse indicating success or failure along with gateway details
     */
    public PaymentResponse verifyEsewa(String transactionUuid, String totalAmount) {
        PaymentResponse response = new PaymentResponse();
        response.setGateway(PaymentConfig.ESEWA_GATEWAY);
        response.setTransactionId(transactionUuid);

        try {
            String query = "product_code=" + encode(PaymentConfig.ESEWA_PRODUCT_CODE)
                    + "&total_amount=" + encode(totalAmount)
                    + "&transaction_uuid=" + encode(transactionUuid);

            URL url = new URL(PaymentConfig.ESEWA_STATUS_CHECK_URL + "?" + query);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            int statusCode = conn.getResponseCode();
            String raw = readResponse(conn, statusCode);
            response.setRawResponse(raw);

            String paymentStatus = extractJsonValue(raw, "status");
            String refId = extractJsonValue(raw, "ref_id");

            response.setStatus(paymentStatus);
            response.setReferenceId(refId);
            response.setSuccess("COMPLETE".equalsIgnoreCase(paymentStatus));
            response.setMessage(response.isSuccess()
                    ? "eSewa payment verified successfully."
                    : "eSewa payment verification failed.");

        } catch (Exception e) {
            response.setSuccess(false);
            response.setStatus("ERROR");
            response.setMessage("eSewa verification error: " + e.getMessage());
            response.setRawResponse(e.toString());
        }

        return response;
    }

    /**
     * Initiates a payment session with Khalti and retrieves the payment URL.
     *
     * @param bookingId the ID of the booking being paid for
     * @param amount the total amount to be paid
     * @return a PaymentRequest containing the Khalti payment URL and transaction index (pidx)
     * @throws RuntimeException if the initiation API call fails
     */
    public PaymentRequest initiateKhalti(String bookingId, double amount) {
        try {
            int amountInPaisa = (int) Math.round(amount * 100.0);

            String purchaseOrderId = generateTransactionUuid(bookingId);
            String purchaseOrderName = "Ride Booking " + bookingId;

            String payload = "{"
                    + "\"return_url\":\"" + escapeJson(PaymentConfig.KHALTI_RETURN_URL) + "\","
                    + "\"website_url\":\"" + escapeJson(PaymentConfig.KHALTI_WEBSITE_URL) + "\","
                    + "\"amount\":" + amountInPaisa + ","
                    + "\"purchase_order_id\":\"" + escapeJson(purchaseOrderId) + "\","
                    + "\"purchase_order_name\":\"" + escapeJson(purchaseOrderName) + "\""
                    + "}";

            URL url = new URL(PaymentConfig.KHALTI_INITIATE_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Key " + PaymentConfig.KHALTI_SECRET_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(payload.getBytes(StandardCharsets.UTF_8));
            }

            int statusCode = conn.getResponseCode();
            String raw = readResponse(conn, statusCode);

            String pidx = extractJsonValue(raw, "pidx");
            String paymentUrl = extractJsonValue(raw, "payment_url");

            if (pidx == null || paymentUrl == null) {
                throw new RuntimeException("Khalti initiate response missing pidx or payment_url: " + raw);
            }

            PaymentRequest request = new PaymentRequest();
            request.setGateway(PaymentConfig.KHALTI_GATEWAY);
            request.setBookingId(bookingId);
            request.setAmount(formatAmount(amount));
            request.setPidx(pidx);
            request.setPaymentUrl(paymentUrl);
            request.setPurchaseOrderId(purchaseOrderId);
            request.setPurchaseOrderName(purchaseOrderName);

            return request;

        } catch (Exception e) {
            throw new RuntimeException("Failed to initiate Khalti payment", e);
        }
    }

    /**
     * Verifies the status of a Khalti payment via a server-to-server API call.
     *
     * @param pidx the unique payment index returned by Khalti during initiation
     * @return a PaymentResponse indicating success or failure along with gateway details
     */
    public PaymentResponse verifyKhalti(String pidx) {
        PaymentResponse response = new PaymentResponse();
        response.setGateway(PaymentConfig.KHALTI_GATEWAY);
        response.setTransactionId(pidx);

        try {
            String payload = "{ \"pidx\": \"" + escapeJson(pidx) + "\" }";

            URL url = new URL(PaymentConfig.KHALTI_LOOKUP_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Key " + PaymentConfig.KHALTI_SECRET_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(payload.getBytes(StandardCharsets.UTF_8));
            }

            int statusCode = conn.getResponseCode();
            String raw = readResponse(conn, statusCode);
            response.setRawResponse(raw);

            String paymentStatus = extractJsonValue(raw, "status");
            String transactionId = extractJsonValue(raw, "transaction_id");

            response.setStatus(paymentStatus);
            response.setReferenceId(transactionId);
            response.setSuccess("Completed".equalsIgnoreCase(paymentStatus));
            response.setMessage(response.isSuccess()
                    ? "Khalti payment verified successfully."
                    : "Khalti payment verification failed.");

        } catch (Exception e) {
            response.setSuccess(false);
            response.setStatus("ERROR");
            response.setMessage("Khalti verification error: " + e.getMessage());
            response.setRawResponse(e.toString());
        }

        return response;
    }

    private String formatAmount(double amount) {
        return AMOUNT_FORMAT.format(amount);
    }

    private String generateTransactionUuid(String bookingId) {
        String timestamp = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyMMdd-HHmmss"));
        String shortId = UUID.randomUUID().toString().substring(0, 8);
        return bookingId + "-" + timestamp + "-" + shortId;
    }

    private String generateEsewaSignature(String totalAmount, String transactionUuid, String productCode) {
        try {
            String message = "total_amount=" + totalAmount
                    + ",transaction_uuid=" + transactionUuid
                    + ",product_code=" + productCode;

            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(
                    PaymentConfig.ESEWA_SECRET_KEY.getBytes(StandardCharsets.UTF_8),
                    "HmacSHA256"
            );
            mac.init(secretKeySpec);

            byte[] digest = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(digest);

        } catch (Exception e) {
            throw new RuntimeException("Failed to generate eSewa signature", e);
        }
    }

    private String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private String readResponse(HttpURLConnection conn, int statusCode) throws Exception {
        BufferedReader reader = new BufferedReader(
                new InputStreamReader(
                        statusCode >= 200 && statusCode < 300
                                ? conn.getInputStream()
                                : conn.getErrorStream(),
                        StandardCharsets.UTF_8
                )
        );

        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        return response.toString();
    }

    private String extractJsonValue(String json, String key) {
        if (json == null || json.isBlank()) {
            return null;
        }

        String pattern = "\"" + key + "\"";
        int keyIndex = json.indexOf(pattern);
        if (keyIndex == -1) {
            return null;
        }

        int colonIndex = json.indexOf(":", keyIndex);
        if (colonIndex == -1) {
            return null;
        }

        int valueStart = colonIndex + 1;
        while (valueStart < json.length() && Character.isWhitespace(json.charAt(valueStart))) {
            valueStart++;
        }

        if (valueStart < json.length() && json.charAt(valueStart) == '"') {
            int startQuote = valueStart + 1;
            int endQuote = json.indexOf('"', startQuote);
            return endQuote == -1 ? null : json.substring(startQuote, endQuote);
        }

        int valueEnd = valueStart;
        while (valueEnd < json.length()
                && json.charAt(valueEnd) != ','
                && json.charAt(valueEnd) != '}') {
            valueEnd++;
        }

        return json.substring(valueStart, valueEnd).trim();
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}