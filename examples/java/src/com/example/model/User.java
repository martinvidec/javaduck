package com.example.model;

/**
 * Represents a user in the system.
 *
 * This is a model class that encapsulates user data including
 * authentication credentials and profile information.
 *
 * @author Jane Smith <jane@example.com>
 * @author Bob Jones
 * @version 2.0
 * @since 1.0
 * @see UserRole
 * @see com.example.service.UserService
 */
public class User extends Person {

    /**
     * The unique identifier for this user.
     */
    private Long id;

    /**
     * The username for authentication.
     */
    private String username;

    /**
     * The encrypted password.
     */
    private String password;

    /**
     * The user's email address.
     */
    private String email;

    /**
     * The user's role in the system.
     */
    private UserRole role;

    /**
     * Flag indicating whether the account is active.
     */
    private boolean active = true;

    /**
     * Creates a new User instance.
     *
     * @param username The username for this user
     * @param email The email address
     */
    public User(String username, String email) {
        this.username = username;
        this.email = email;
        this.role = UserRole.USER;
    }

    /**
     * Gets the user's unique identifier.
     *
     * @return The user ID
     */
    public Long getId() {
        return id;
    }

    /**
     * Sets the user's unique identifier.
     *
     * @param id The new user ID
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Gets the username.
     *
     * @return The username string
     */
    public String getUsername() {
        return username;
    }

    /**
     * Sets the username.
     *
     * @param username The new username
     * @throws IllegalArgumentException if username is null or empty
     */
    public void setUsername(String username) throws IllegalArgumentException {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        this.username = username;
    }

    /**
     * Gets the email address.
     *
     * @return The email address
     */
    public String getEmail() {
        return email;
    }

    /**
     * Sets the email address.
     *
     * @param email The new email address
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Gets the user's role.
     *
     * @return The UserRole enum value
     */
    public UserRole getRole() {
        return role;
    }

    /**
     * Sets the user's role.
     *
     * @param role The new role
     */
    public void setRole(UserRole role) {
        this.role = role;
    }

    /**
     * Checks if the account is active.
     *
     * @return true if active, false otherwise
     */
    public boolean isActive() {
        return active;
    }

    /**
     * Activates or deactivates the account.
     *
     * @param active true to activate, false to deactivate
     */
    public void setActive(boolean active) {
        this.active = active;
    }

    /**
     * Checks if this user has administrator privileges.
     *
     * @return true if user is an admin, false otherwise
     */
    public boolean isAdmin() {
        return role == UserRole.ADMIN;
    }
}
