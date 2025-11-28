# Java Support in JavaDuck

JavaDuck extends JSDuck with comprehensive Java source code parsing and Javadoc documentation support.

## Overview

JavaDuck can parse and document:
- **Java source files** (`.java`)
- **JavaScript source files** (`.js`)
- **SCSS/CSS files** (`.scss`, `.css`)

All in a single, unified documentation site.

## Features

### Code Parsing

JavaDuck recognizes all Java language constructs:

- **Classes** - Public, abstract, final classes with full inheritance
- **Interfaces** - Interface definitions with method signatures
- **Enums** - Enumeration types with constants
- **Methods** - Constructor and regular methods with typed parameters
- **Fields** - Class and instance fields with type information
- **Modifiers** - public, private, protected, static, final, abstract
- **Generics** - Full support for generic type parameters
- **Annotations** - Recognition of Java annotations

### Javadoc Comments

JavaDuck parses standard Javadoc comment blocks:

```java
/**
 * This is a Javadoc comment.
 *
 * Multi-line descriptions are fully supported with Markdown formatting.
 *
 * @param name The parameter description
 * @return Description of return value
 */
```

### Supported Javadoc Tags

JavaDuck supports all standard Javadoc tags:

| Tag | Description | Example |
|-----|-------------|---------|
| `@param` | Parameter description | `@param name The user's name` |
| `@return` | Return value description | `@return The computed result` |
| `@throws` | Exception documentation | `@throws IOException If file not found` |
| `@author` | Author information | `@author John Doe` |
| `@version` | Version number | `@version 1.0.0` |
| `@since` | Version introduced | `@since 0.5` |
| `@see` | Cross-reference | `@see OtherClass#method()` |
| `@deprecated` | Deprecation notice | `@deprecated Use newMethod() instead` |

### Type System

JavaDuck automatically extracts type information from Java code:

- **Primitive types**: `int`, `long`, `double`, `float`, `boolean`, `char`, `byte`, `short`
- **Object types**: `String`, `Integer`, `List`, `Map`, etc.
- **Custom types**: User-defined classes and interfaces
- **Generics**: `List<String>`, `Map<K, V>`, etc.
- **Arrays**: `String[]`, `int[][]`, etc.

## How It Works

### Parser Architecture

JavaDuck uses [JavaParser](https://javaparser.org/) to analyze Java source code:

1. **Detection**: Files with `.java` extension are routed to the Java parser
2. **AST Generation**: JavaParser creates an Abstract Syntax Tree (AST)
3. **JSON Export**: AST is exported to JSON format via JavaParser CLI
4. **Ruby Processing**: JavaDuck processes the JSON to extract documentation
5. **Association**: Javadoc comments are linked to code elements
6. **Output**: Unified HTML documentation is generated

### File Routing

```ruby
# lib/jsduck/parser.rb
if filename =~ /\.java$/
  # Route to Java parser
  docs = Java::Parser.new(contents, options).parse
  docs = Java::Ast.new(docs).detect_all!
elsif filename =~ /\.scss$/
  # Route to SCSS parser
  docs = Css::Parser.new(contents, options).parse
else
  # Route to JavaScript parser (default)
  docs = Js::Parser.new(contents, options).parse
  docs = Js::Ast.new(docs).detect_all!
end
```

## Usage Examples

### Basic Java Project

Document a simple Java project:

```bash
jsduck src/main/java --output docs
```

### Mixed Java/JavaScript Project

Document both Java backend and JavaScript frontend:

```bash
jsduck src/main/java src/main/resources/js --output docs
```

### With Custom Configuration

Use a config file for advanced options:

```bash
jsduck --config jsduck.json
```

Example `jsduck.json`:

```json
{
  "input": ["src/main/java", "src/main/resources/js"],
  "output": "docs",
  "title": "My Project Documentation",
  "--": ["Additional options"]
}
```

## Java-Specific Examples

### Documenting a Class

```java
/**
 * Represents a user in the system.
 *
 * This class handles user authentication and profile management.
 *
 * @author Jane Smith
 * @version 2.0
 * @since 1.0
 */
public class User {
    /**
     * The user's unique identifier.
     */
    private String id;

    /**
     * Creates a new user with the given name.
     *
     * @param name The user's full name
     * @throws IllegalArgumentException If name is null or empty
     */
    public User(String name) {
        if (name == null || name.isEmpty()) {
            throw new IllegalArgumentException("Name cannot be empty");
        }
        this.id = generateId();
    }

    /**
     * Authenticates the user with a password.
     *
     * @param password The password to verify
     * @return true if authentication successful
     * @see #resetPassword(String)
     */
    public boolean authenticate(String password) {
        // Implementation...
        return false;
    }
}
```

### Documenting an Interface

```java
/**
 * Service for handling data persistence.
 *
 * @param <T> The type of entity to persist
 * @author John Doe
 * @since 1.5
 */
public interface Repository<T> {
    /**
     * Saves an entity to the database.
     *
     * @param entity The entity to save
     * @return The saved entity with generated ID
     * @throws PersistenceException If save fails
     */
    T save(T entity) throws PersistenceException;

    /**
     * Finds an entity by its ID.
     *
     * @param id The entity identifier
     * @return The entity, or null if not found
     */
    T findById(String id);
}
```

### Documenting an Enum

```java
/**
 * Represents the status of an order.
 *
 * @author Sales Team
 * @version 1.0
 */
public enum OrderStatus {
    /**
     * Order has been placed but not yet processed.
     */
    PENDING,

    /**
     * Order is being prepared for shipment.
     */
    PROCESSING,

    /**
     * Order has been shipped to customer.
     */
    SHIPPED,

    /**
     * Order has been delivered successfully.
     */
    DELIVERED,

    /**
     * Order was cancelled.
     */
    CANCELLED
}
```

## Markdown Support

Just like JavaScript documentation, Java documentation supports full Markdown formatting:

```java
/**
 * # Advanced Calculator
 *
 * This calculator supports:
 * - Basic arithmetic (+, -, *, /)
 * - Scientific functions (sin, cos, tan)
 * - **Complex numbers**
 *
 * ## Usage Example
 *
 * ```java
 * Calculator calc = new Calculator();
 * double result = calc.add(5, 3);
 * ```
 *
 * @see <a href="https://example.com/docs">Online Documentation</a>
 */
public class Calculator {
    // ...
}
```

## Linking and Cross-References

JavaDuck automatically creates links between classes, methods, and other elements:

- **Class references**: `@see MyClass`
- **Method references**: `@see MyClass#myMethod(String)`
- **Package references**: `@see com.example.package`
- **External links**: `@see <a href="...">Link text</a>`

## Integration with JavaScript Code

When documenting mixed projects, JavaDuck provides seamless integration:

- Unified search across Java and JavaScript
- Consistent styling and navigation
- Cross-language linking (when using proper references)
- Single output directory

## Best Practices

### 1. Use Standard Javadoc Format

Stick to standard Javadoc conventions for maximum compatibility:

```java
/**
 * Brief description (first sentence).
 *
 * Detailed description with multiple paragraphs if needed.
 *
 * @param name Parameter description
 * @return Return value description
 */
```

### 2. Document Public APIs

Focus documentation efforts on public classes and methods:

```java
/**
 * Public API - well documented.
 */
public class PublicService {
    // Full documentation
}

// Private implementation - minimal docs needed
private class InternalHelper {
    // Brief comments only
}
```

### 3. Use @see for Related Items

Create a web of documentation links:

```java
/**
 * Saves a user.
 *
 * @see #findUser(String)
 * @see #deleteUser(String)
 * @see User
 */
public void saveUser(User user) { }
```

### 4. Include Examples in Long Descriptions

Help users understand complex APIs:

```java
/**
 * Transforms data using the given function.
 *
 * Example usage:
 * ```java
 * List<String> names = Arrays.asList("Alice", "Bob");
 * List<Integer> lengths = transform(names, String::length);
 * ```
 *
 * @param data Input data
 * @param function Transformation function
 * @return Transformed data
 */
```

### 5. Keep Descriptions Concise

First sentence should be a clear summary:

```java
/**
 * Validates email address format.  // GOOD - clear and concise
 *
 * This method checks if the provided string is a valid email
 * address according to RFC 5322 specification.
 */
```

## Limitations

Current limitations of Java support in JavaDuck:

1. **No module system parsing**: Java 9+ module-info.java files are not processed
2. **Limited annotation processing**: Annotations are recognized but not fully parsed
3. **Generic bounds**: Complex generic bounds may not display perfectly
4. **Nested classes**: Inner classes are supported but may have limited linking

## Troubleshooting

### Java Files Not Being Parsed

**Problem**: `.java` files are ignored

**Solution**: Ensure:
- Files have `.java` extension
- Java Runtime Environment (JRE 8+) is installed
- JavaParser CLI is accessible

### Missing Type Information

**Problem**: Method parameters show no types

**Solution**:
- JavaDuck extracts types from code, not just Javadoc
- Ensure code is valid and parseable Java
- Check for syntax errors in source files

### Javadoc Tags Not Recognized

**Problem**: Custom tags are not processed

**Solution**:
- JavaDuck supports standard Javadoc tags only
- Custom tags are preserved in the description but not specially formatted
- Consider using standard tags where possible

## Further Reading

- [Migration Guide](migration-guide.md) - Moving from JSDuck to JavaDuck
- [Javadoc Tag Reference](javadoc-tags.md) - Complete tag documentation
- [Architecture](architecture.md) - How JavaDuck is built
- [FAQ](faq.md) - Common questions
