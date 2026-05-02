package com.riderental.myriderental.util;

/**
 * Utility class for data validation operations.
 */
public class ValidationUtil {

    /**
     * Checks if a string is null, empty, or consists only of whitespace characters.
     *
     * @param value the string to check
     * @return true if the string is blank, false otherwise
     */
    public static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
