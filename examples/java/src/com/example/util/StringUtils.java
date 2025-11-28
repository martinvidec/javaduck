package com.example.util;

/**
 * Utility class for string manipulation operations.
 *
 * Provides static helper methods for common string operations
 * throughout the application.
 *
 * @author Bob Jones
 * @version 1.0
 * @since 1.0
 */
public final class StringUtils {

    /**
     * Private constructor to prevent instantiation.
     */
    private StringUtils() {
        throw new AssertionError("Utility class cannot be instantiated");
    }

    /**
     * Checks if a string is null or empty.
     *
     * @param str The string to check
     * @return true if string is null or empty, false otherwise
     */
    public static boolean isEmpty(String str) {
        return str == null || str.isEmpty();
    }

    /**
     * Checks if a string is null, empty, or contains only whitespace.
     *
     * @param str The string to check
     * @return true if string is blank, false otherwise
     */
    public static boolean isBlank(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Capitalizes the first letter of a string.
     *
     * @param str The string to capitalize
     * @return The capitalized string, or null if input is null
     */
    public static String capitalize(String str) {
        if (isEmpty(str)) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }

    /**
     * Truncates a string to the specified length.
     *
     * @param str The string to truncate
     * @param maxLength The maximum length
     * @return The truncated string with "..." appended if truncated
     * @throws IllegalArgumentException if maxLength is negative
     */
    public static String truncate(String str, int maxLength) {
        if (maxLength < 0) {
            throw new IllegalArgumentException("maxLength cannot be negative");
        }
        if (isEmpty(str) || str.length() <= maxLength) {
            return str;
        }
        return str.substring(0, maxLength) + "...";
    }

    /**
     * Reverses a string.
     *
     * @param str The string to reverse
     * @return The reversed string, or null if input is null
     */
    public static String reverse(String str) {
        if (str == null) {
            return null;
        }
        return new StringBuilder(str).reverse().toString();
    }

    /**
     * Counts the occurrences of a substring in a string.
     *
     * @param str The string to search in
     * @param substring The substring to count
     * @return The number of occurrences
     */
    public static int countOccurrences(String str, String substring) {
        if (isEmpty(str) || isEmpty(substring)) {
            return 0;
        }
        int count = 0;
        int index = 0;
        while ((index = str.indexOf(substring, index)) != -1) {
            count++;
            index += substring.length();
        }
        return count;
    }
}
