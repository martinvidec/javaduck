package com.example.service;

/**
 * Interface for authentication-related operations.
 *
 * Classes implementing this interface must provide
 * methods for user authentication and session management.
 *
 * @author Bob Jones <bob@example.com>
 * @version 1.0
 * @since 1.0
 * @see UserService
 */
public interface Authenticatable {

    /**
     * Authenticates a user with the given credentials.
     *
     * @param username The username
     * @param password The password
     * @return true if authentication successful, false otherwise
     * @throws AuthenticationException if authentication fails
     */
    boolean authenticate(String username, String password) throws AuthenticationException;

    /**
     * Logs out the current user.
     */
    void logout();

    /**
     * Checks if a user is currently logged in.
     *
     * @return true if logged in, false otherwise
     */
    boolean isLoggedIn();

    /**
     * Refreshes the user's authentication token.
     *
     * @return The new authentication token
     * @throws TokenExpiredException if the current token has expired
     */
    String refreshToken() throws TokenExpiredException;
}
