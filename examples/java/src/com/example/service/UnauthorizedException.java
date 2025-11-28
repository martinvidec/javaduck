package com.example.service;

/**
 * Exception thrown when a user attempts an unauthorized operation.
 *
 * @author Jane Smith
 * @version 1.0
 * @since 1.0
 */
public class UnauthorizedException extends Exception {
    /**
     * Creates a new UnauthorizedException.
     *
     * @param message The error message
     */
    public UnauthorizedException(String message) {
        super(message);
    }
}
