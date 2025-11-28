# Javadoc Tag Reference

Complete reference for all Javadoc tags supported by JavaDuck.

## Overview

Javadoc tags are special markers in documentation comments that provide structured information about code elements. JavaDuck supports all standard Javadoc tags.

## Tag Categories

### Block Tags

Block tags appear at the end of documentation comments, each on its own line starting with `@`.

### Inline Tags

Inline tags can appear anywhere in documentation text, enclosed in `{@...}`.

## Supported Tags

### @param

**Purpose:** Document method or constructor parameters

**Syntax:**
```java
@param <parameter-name> <description>
```

**Example:**
```java
/**
 * Calculates the sum of two numbers.
 *
 * @param a The first number
 * @param b The second number
 */
public int add(int a, int b) {
    return a + b;
}
```

**Notes:**
- Unlike JSDoc, **no type annotation** needed - types come from code
- One `@param` tag per parameter
- Order should match parameter order in method signature
- Description can span multiple lines

**Multiple parameters:**
```java
/**
 * Creates a user account.
 *
 * @param username The desired username (must be unique)
 * @param email    User's email address for notifications
 * @param password Password (min 8 characters)
 */
public void createUser(String username, String email, String password) {
    // ...
}
```

---

### @return

**Purpose:** Document the return value of a method

**Syntax:**
```java
@return <description>
```

**Example:**
```java
/**
 * Finds a user by ID.
 *
 * @param id The user ID
 * @return The user object, or null if not found
 */
public User findById(String id) {
    // ...
}
```

**Notes:**
- Do not use for `void` methods
- Do not use for constructors
- Type is automatically extracted from method signature
- Describe what is returned, including special values (null, empty, etc.)

**Detailed example:**
```java
/**
 * Searches for products matching the query.
 *
 * @param query Search terms
 * @return List of matching products. Returns empty list if no matches found.
 *         Never returns null.
 */
public List<Product> search(String query) {
    // ...
}
```

---

### @throws / @exception

**Purpose:** Document exceptions that a method may throw

**Syntax:**
```java
@throws <exception-class> <description>
```

**Example:**
```java
/**
 * Reads a file from disk.
 *
 * @param path The file path
 * @return File contents as string
 * @throws IOException If file cannot be read
 * @throws FileNotFoundException If file does not exist
 */
public String readFile(String path) throws IOException {
    // ...
}
```

**Notes:**
- `@throws` and `@exception` are synonyms (use `@throws` by convention)
- Document both checked and unchecked exceptions
- Include when the exception is thrown
- One tag per exception type

**Multiple exceptions:**
```java
/**
 * Processes a payment transaction.
 *
 * @param amount The amount to charge
 * @throws IllegalArgumentException If amount is negative or zero
 * @throws InsufficientFundsException If account balance too low
 * @throws PaymentGatewayException If payment gateway is unavailable
 */
public void processPayment(double amount) throws PaymentGatewayException {
    // ...
}
```

---

### @author

**Purpose:** Identify the author(s) of a class or interface

**Syntax:**
```java
@author <name>
```

**Example:**
```java
/**
 * Main application entry point.
 *
 * @author Jane Smith
 * @author John Doe
 * @version 2.0
 */
public class Application {
    // ...
}
```

**Notes:**
- Typically used for classes/interfaces, not methods
- Can have multiple `@author` tags
- Can include email: `@author Jane Smith <jane@example.com>`
- Optional - use if authorship is important to track

**Team example:**
```java
/**
 * Database connection pool manager.
 *
 * @author Backend Team
 * @author Jane Smith (original implementation)
 * @author John Doe (refactoring for v2.0)
 */
public class ConnectionPool {
    // ...
}
```

---

### @version

**Purpose:** Document the version of a class or interface

**Syntax:**
```java
@version <version-string>
```

**Example:**
```java
/**
 * User authentication service.
 *
 * @author Security Team
 * @version 1.2.3
 * @since 1.0
 */
public class AuthService {
    // ...
}
```

**Notes:**
- Typically used for classes/interfaces
- Format is flexible (semantic versioning, dates, etc.)
- Often combined with `@since`

**Version formats:**
```java
@version 1.0               // Simple version
@version 1.2.3             // Semantic versioning
@version 2.0-SNAPSHOT      // Development version
@version 2021-11-28        // Date-based
@version 1.0 (Build 42)    // With build number
```

---

### @since

**Purpose:** Document when a feature was introduced

**Syntax:**
```java
@since <version>
```

**Example:**
```java
/**
 * Exports data to JSON format.
 *
 * @since 2.0
 */
public void exportToJson() {
    // ...
}
```

**Notes:**
- Use for classes, methods, fields - anything added after initial release
- Helps users understand which version they need
- Use consistent version format across project

**Class and method example:**
```java
/**
 * Data export utility.
 *
 * @author Export Team
 * @version 2.5
 * @since 1.0
 */
public class DataExporter {
    /**
     * Exports to XML format.
     *
     * @since 1.0
     */
    public void exportToXml() { }

    /**
     * Exports to JSON format.
     *
     * @since 2.0
     */
    public void exportToJson() { }

    /**
     * Exports to YAML format.
     *
     * @since 2.5
     */
    public void exportToYaml() { }
}
```

---

### @see

**Purpose:** Create cross-references to related elements

**Syntax:**
```java
@see <reference>
```

**Reference formats:**
- `@see ClassName` - Reference to a class
- `@see ClassName#methodName` - Reference to a method
- `@see ClassName#fieldName` - Reference to a field
- `@see #methodName` - Reference to method in same class
- `@see <a href="URL">Link text</a>` - External link

**Examples:**
```java
/**
 * Saves a user to database.
 *
 * @param user The user to save
 * @see #findUser(String)
 * @see #deleteUser(String)
 * @see User
 */
public void saveUser(User user) {
    // ...
}
```

**Multiple references:**
```java
/**
 * User authentication service.
 *
 * @see UserRepository
 * @see SecurityConfig
 * @see #login(String, String)
 * @see <a href="https://example.com/auth-guide">Authentication Guide</a>
 */
public class AuthService {
    // ...
}
```

**Cross-class references:**
```java
/**
 * Processes an order.
 *
 * @param order The order to process
 * @see Order#getStatus()
 * @see PaymentService#processPayment(Order)
 * @see com.example.shipping.ShippingService
 */
public void processOrder(Order order) {
    // ...
}
```

---

### @deprecated

**Purpose:** Mark elements that should no longer be used

**Syntax:**
```java
@deprecated <explanation>
```

**Example:**
```java
/**
 * Gets user by ID.
 *
 * @param id User ID
 * @return The user
 * @deprecated Use {@link #findById(String)} instead. This method
 *             will be removed in version 3.0.
 */
@Deprecated
public User getUser(String id) {
    return findById(id);
}
```

**Notes:**
- Always explain WHY deprecated and what to use instead
- Use with `@Deprecated` annotation
- Include version when it will be removed (if known)
- Use `{@link}` inline tag to reference replacement

**Detailed deprecation:**
```java
/**
 * Sends an email using SMTP.
 *
 * @param to Recipient email
 * @param subject Email subject
 * @param body Email body
 * @deprecated As of version 2.0, replaced by {@link EmailService#send(EmailMessage)}.
 *             This method uses outdated SMTP configuration and will be removed in 3.0.
 *             Please migrate to the new EmailService API which supports:
 *             - HTML emails
 *             - Attachments
 *             - Email templates
 * @see EmailService#send(EmailMessage)
 */
@Deprecated
public void sendEmail(String to, String subject, String body) {
    // ...
}
```

---

## Inline Tags

### {@link}

**Purpose:** Create an inline link to another element

**Syntax:**
```java
{@link <reference>}
{@link <reference> <label>}
```

**Example:**
```java
/**
 * Processes user authentication.
 *
 * This method uses {@link SecurityConfig} to validate credentials
 * and {@link UserRepository#findByUsername(String)} to retrieve user data.
 *
 * @param username The username
 * @param password The password
 * @return true if authentication successful
 */
public boolean authenticate(String username, String password) {
    // ...
}
```

**With label:**
```java
/**
 * See {@link AuthService the authentication service} for login details.
 */
```

---

### {@code}

**Purpose:** Format text as code (monospace, no HTML interpretation)

**Syntax:**
```java
{@code <text>}
```

**Example:**
```java
/**
 * Compares two values for equality.
 *
 * Returns {@code true} if the values are equal, {@code false} otherwise.
 * Note: {@code null == null} returns {@code true}.
 *
 * @param a First value
 * @param b Second value
 * @return {@code true} if equal
 */
public boolean equals(Object a, Object b) {
    // ...
}
```

---

### {@literal}

**Purpose:** Display text literally (no HTML interpretation, normal font)

**Syntax:**
```java
{@literal <text>}
```

**Example:**
```java
/**
 * Parses HTML input.
 *
 * Example: {@literal <div>Hello</div>} becomes a div element.
 *
 * @param html The HTML string
 */
public void parseHtml(String html) {
    // ...
}
```

---

## Less Common Tags

### @serial

**Purpose:** Document serializable fields

**Example:**
```java
/**
 * User ID.
 *
 * @serial User's unique identifier
 */
private String userId;
```

---

### @serialData

**Purpose:** Document data written by writeObject or writeExternal

**Example:**
```java
/**
 * @serialData Writes username as UTF string, followed by creation timestamp
 */
private void writeObject(ObjectOutputStream out) throws IOException {
    // ...
}
```

---

### @serialField

**Purpose:** Document ObjectStreamField component

**Example:**
```java
/**
 * @serialField username String The user's login name
 * @serialField email String The user's email address
 */
private static final ObjectStreamField[] serialPersistentFields = {
    // ...
};
```

---

## Complete Example

Here's a fully documented class using multiple tags:

```java
package com.example.service;

import com.example.model.User;
import com.example.exception.UserNotFoundException;
import java.io.IOException;

/**
 * Service for managing user accounts.
 *
 * This service provides CRUD operations for users and handles
 * user authentication and authorization. All operations are
 * transactional and thread-safe.
 *
 * <p>Example usage:
 * <pre>{@code
 * UserService service = new UserService();
 * User user = service.createUser("john", "john@example.com");
 * service.activate(user.getId());
 * }</pre>
 *
 * @author Jane Smith
 * @author John Doe
 * @version 2.1.0
 * @since 1.0
 * @see User
 * @see UserRepository
 */
public class UserService {
    /**
     * Creates a new user account.
     *
     * The user is created in {@code PENDING} status and must be
     * activated using {@link #activate(String)} before login.
     *
     * @param username Desired username (must be unique, 3-20 chars)
     * @param email    User's email address (must be valid format)
     * @return The created user with generated ID
     * @throws IllegalArgumentException If username or email invalid
     * @throws DuplicateUserException  If username already exists
     * @since 1.0
     * @see #activate(String)
     */
    public User createUser(String username, String email) {
        // ...
        return null;
    }

    /**
     * Activates a pending user account.
     *
     * @param userId The user ID to activate
     * @throws UserNotFoundException If user not found
     * @throws IllegalStateException If user already active
     * @since 1.0
     */
    public void activate(String userId) throws UserNotFoundException {
        // ...
    }

    /**
     * Authenticates a user with username and password.
     *
     * @param username The username
     * @param password The password (plain text - will be hashed internally)
     * @return {@code true} if credentials valid and user is active
     * @throws UserNotFoundException If user not found
     * @since 1.0
     * @see #createUser(String, String)
     */
    public boolean authenticate(String username, String password)
            throws UserNotFoundException {
        // ...
        return false;
    }

    /**
     * Finds user by username.
     *
     * @param username The username to search for
     * @return The user, or {@code null} if not found
     * @since 1.0
     * @deprecated As of 2.0, replaced by {@link #findByUsername(String)}
     *             which throws exception instead of returning null.
     *             This method will be removed in 3.0.
     * @see #findByUsername(String)
     */
    @Deprecated
    public User getUser(String username) {
        // ...
        return null;
    }

    /**
     * Finds user by username.
     *
     * @param username The username to search for
     * @return The user (never {@code null})
     * @throws UserNotFoundException If user not found
     * @since 2.0
     */
    public User findByUsername(String username) throws UserNotFoundException {
        // ...
        return null;
    }

    /**
     * Exports user data to JSON file.
     *
     * @param userId User ID to export
     * @param outputPath Path to output JSON file
     * @throws UserNotFoundException If user not found
     * @throws IOException If file cannot be written
     * @since 2.1
     * @see #importUser(String)
     */
    public void exportUser(String userId, String outputPath)
            throws UserNotFoundException, IOException {
        // ...
    }
}
```

## Best Practices

### 1. Always Document Public APIs

All public classes, methods, and fields should have documentation:

```java
// GOOD
/**
 * Validates email format.
 *
 * @param email The email to validate
 * @return true if valid
 */
public boolean validateEmail(String email) { }

// BAD - no documentation
public boolean validateEmail(String email) { }
```

### 2. First Sentence is Summary

The first sentence should be a complete, concise summary:

```java
// GOOD
/**
 * Calculates the total price including tax.  // Complete sentence
 *
 * This method applies the current tax rate...
 */

// BAD
/**
 * Calculates  // Incomplete
 */
```

### 3. Use Markdown for Formatting

JavaDuck supports Markdown in Javadoc:

```java
/**
 * # User Authentication
 *
 * This service supports:
 * - Username/password authentication
 * - OAuth2 integration
 * - **Two-factor authentication**
 *
 * ## Example
 *
 * ```java
 * boolean success = auth.login("user", "pass");
 * ```
 */
```

### 4. Document Edge Cases

Explain behavior for null, empty, special values:

```java
/**
 * Finds users by name.
 *
 * @param name Search name (case-insensitive).
 *             If {@code null} or empty, returns all users.
 * @return List of matching users. Never returns {@code null},
 *         returns empty list if no matches.
 */
```

### 5. Keep Tags in Standard Order

Recommended order:
1. Description
2. `@param` (in parameter order)
3. `@return`
4. `@throws` (alphabetical by exception name)
5. `@since`
6. `@deprecated`
7. `@see`

### 6. Link Related Elements

Use `@see` and `{@link}` to create documentation web:

```java
/**
 * Saves a user.
 *
 * Related operations:
 * - {@link #findUser(String)} to retrieve users
 * - {@link #deleteUser(String)} to remove users
 *
 * @see User
 * @see UserRepository
 */
```

## Summary

JavaDuck supports all standard Javadoc tags with full type extraction from Java source code. Use these tags to create comprehensive, navigable documentation for your Java projects.

**Most commonly used:**
- `@param` - Document parameters
- `@return` - Document return values
- `@throws` - Document exceptions
- `@see` - Cross-reference related elements
- `@deprecated` - Mark obsolete elements

**Project metadata:**
- `@author` - Identify authors
- `@version` - Track versions
- `@since` - Mark when features were added

For more information, see:
- [Java Support Guide](java-support.md)
- [Migration Guide](migration-guide.md)
- [FAQ](faq.md)
