# JavaDuck - Java Documentation Example

This example demonstrates JavaDuck's ability to generate documentation from Java source code with Javadoc comments.

## Project Structure

```
src/
└── com/
    └── example/
        ├── model/
        │   ├── Person.java          # Abstract base class
        │   ├── User.java             # User model (extends Person)
        │   └── UserRole.java         # Enum for user roles
        ├── service/
        │   ├── Authenticatable.java  # Authentication interface
        │   ├── UserService.java      # User service implementation
        │   ├── AuthenticationException.java
        │   ├── TokenExpiredException.java
        │   ├── DuplicateUserException.java
        │   ├── UserNotFoundException.java
        │   └── UnauthorizedException.java
        └── util/
            └── StringUtils.java      # Utility class with static methods
```

## Features Demonstrated

This example showcases various Java and Javadoc features:

### Java Language Features
- **Classes**: Regular classes with inheritance (`User extends Person`)
- **Abstract Classes**: Base classes (`Person`)
- **Interfaces**: Contract definitions (`Authenticatable`)
- **Enums**: Type-safe constants (`UserRole`)
- **Generics**: Type parameters (`Optional<User>`, `List<User>`)
- **Exceptions**: Custom exception hierarchy
- **Static Methods**: Utility classes (`StringUtils`)

### Javadoc Tags
- `@author` - Document code authors
- `@version` - Track version numbers
- `@since` - Indicate when features were added
- `@see` - Cross-reference related classes
- `@param` - Document method parameters
- `@return` - Document return values
- `@throws` - Document exceptions

### Code Organization
- **Packages**: Proper package structure (`com.example.model`, `com.example.service`, `com.example.util`)
- **Visibility**: Public, private, and protected modifiers
- **Inheritance**: Class hierarchies and interface implementation
- **Best Practices**: Immutable utility classes, proper exception handling

## Generating Documentation

### Prerequisites

1. JavaDuck installed (from project root)
2. JavaParser JAR available (see main README)

### Using the Build Script

From this directory, run:

```bash
./build-docs.sh
```

The script will:
1. Generate documentation from all Java files in `src/`
2. Output HTML documentation to `docs/`
3. Open the documentation in your browser (optional)

### Manual Generation

Alternatively, generate docs manually from the project root:

```bash
ruby bin/jsduck examples/java/src --output examples/java/docs
```

## Viewing the Documentation

After generation, open `docs/index.html` in your web browser:

```bash
open docs/index.html  # macOS
xdg-open docs/index.html  # Linux
start docs/index.html  # Windows
```

## What to Look For

When viewing the generated documentation, notice:

1. **Class Hierarchy**: The `User` class shows its parent `Person`
2. **Interface Implementation**: `UserService` shows it implements `Authenticatable`
3. **Enum Values**: `UserRole` displays all available roles
4. **Method Signatures**: Parameter types and return types
5. **Cross-References**: Links to related classes via `@see` tags
6. **Author Information**: Multiple authors with email addresses
7. **Version Tracking**: Version and since tags
8. **Exception Documentation**: Throws clauses with descriptions

## Customization

You can customize the documentation generation:

```bash
# Custom title
ruby bin/jsduck examples/java/src --output docs --title "My Java API"

# Include private members
ruby bin/jsduck examples/java/src --output docs --private

# Custom footer
ruby bin/jsduck examples/java/src --output docs --footer "Copyright 2025"
```

## Next Steps

- Modify the Java files and regenerate to see changes
- Add your own Java classes to the `src/` directory
- Explore JavaDuck's configuration options
- Try combining Java and JavaScript documentation

## Troubleshooting

### JavaParser JAR Not Found

If you get an error about JavaParser JAR:

```
ERROR: JavaParser CLI JAR not found
```

Make sure you've set up the JavaParser dependency:

```bash
# From project root
cd poc/java-parser
# Follow setup instructions in poc/java-parser/README.md
```

### No Documentation Generated

Check that:
1. Java files have Javadoc comments (`/** ... */`)
2. Files are in the correct directory structure
3. Package declarations match directory structure

## Learn More

- [JSDuck Wiki](https://github.com/senchalabs/jsduck/wiki)
- [Javadoc Guide](https://www.oracle.com/technical-resources/articles/java/javadoc-tool.html)
- [JavaDuck Documentation](../../docs/)
