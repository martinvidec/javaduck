package com.example.service;

/**
 * Exception thrown when an authentication token has expired.
 *
 * @author Bob Jones
 * @version 1.0
 * @since 1.0
 */
public class TokenExpiredException extends Exception {
    /**
     * Creates a new TokenExpiredException.
     */
    public TokenExpiredException() {
        super("Token has expired");
    }
}
