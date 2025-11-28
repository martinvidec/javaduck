package com.example.model;

/**
 * Enumeration of user roles in the system.
 *
 * Defines the different privilege levels available
 * for user accounts.
 *
 * @author Jane Smith
 * @version 1.0
 * @since 1.0
 */
public enum UserRole {
    /**
     * Regular user with basic privileges.
     */
    USER,

    /**
     * Moderator with elevated privileges.
     */
    MODERATOR,

    /**
     * Administrator with full system access.
     */
    ADMIN,

    /**
     * Guest user with read-only access.
     */
    GUEST
}
