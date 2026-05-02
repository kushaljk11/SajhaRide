package com.riderental.myriderental.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class for password hashing and verification.
 */
public class PasswordUtil {

    /**
     * Hashes a plain text password using SHA-256 algorithm.
     *
     * @param plainTextPassword the plain text password to hash
     * @return the hashed password as a hexadecimal string
     */
    public static String hashPassword(String plainTextPassword) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(plainTextPassword.getBytes(StandardCharsets.UTF_8));

            StringBuilder builder = new StringBuilder();
            for (byte b : hash) {
                builder.append(String.format("%02x", b));
            }
            return builder.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 is not available", e);
        }
    }

    /**
     * Checks if a plain text password matches a given hashed password.
     *
     * @param plainTextPassword the plain text password
     * @param hashedPassword the previously hashed password
     * @return true if the passwords match, false otherwise
     */
    public static boolean matches(String plainTextPassword, String hashedPassword) {
        return hashPassword(plainTextPassword).equals(hashedPassword);
    }
}
