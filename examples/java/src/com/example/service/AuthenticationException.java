package com.example.service;

/**
 * Exception thrown when authentication fails.
 *
 * @author Bob Jones
 * @version 1.0
 * @since 1.0
 */
public class AuthenticationException extends Exception {
    /**
     * Creates a new AuthenticationException with a message.
     *
     * @param message The error message
     */
    public AuthenticationException(String message) {
        super(message);
    }
}
