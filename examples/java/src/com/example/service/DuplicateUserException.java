package com.example.service;

/**
 * Exception thrown when attempting to create a user with a duplicate username.
 *
 * @author Jane Smith
 * @version 1.0
 * @since 1.0
 */
public class DuplicateUserException extends Exception {
    /**
     * Creates a new DuplicateUserException.
     *
     * @param username The duplicate username
     */
    public DuplicateUserException(String username) {
        super("User already exists: " + username);
    }
}
