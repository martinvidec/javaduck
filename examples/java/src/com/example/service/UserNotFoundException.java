package com.example.service;

/**
 * Exception thrown when a requested user cannot be found.
 *
 * @author Jane Smith
 * @version 1.0
 * @since 1.0
 */
public class UserNotFoundException extends Exception {
    /**
     * Creates a new UserNotFoundException.
     *
     * @param userId The ID of the user that was not found
     */
    public UserNotFoundException(Long userId) {
        super("User not found: " + userId);
    }
}
