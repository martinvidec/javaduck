# Migration Guide: JSDuck to JavaDuck

This guide helps you migrate from JSDuck to JavaDuck and take advantage of Java support.

## Overview

JavaDuck is a fork of JSDuck with added Java support. It maintains **100% backward compatibility** with JSDuck for JavaScript projects while adding new capabilities for Java.

## Quick Start

### For Existing JSDuck Users

If you're already using JSDuck for JavaScript documentation, migration is simple:

1. **Install JavaDuck** (replace JSDuck)
2. **Run with same commands** - all JSDuck options work
3. **Optionally add Java sources** if you have Java code

**No changes required to your existing setup!**

## Installation

### Uninstall JSDuck (Optional)

```bash
gem uninstall jsduck
```

### Install JavaDuck

From source:

```bash
git clone https://github.com/martinvidec/javaduck.git
cd javaduck
bundle install
rake build
gem install pkg/jsduck-*.gem
```

The command is still called `jsduck` for compatibility.

## Configuration Migration

### No Changes Needed

Your existing JSDuck configuration files work as-is:

```json
{
  "input": ["src/js"],
  "output": "docs",
  "title": "My JavaScript Project"
}
```

Simply run:

```bash
jsduck --config jsduck.json
```

### Adding Java Sources

To add Java documentation, just include Java directories:

```json
{
  "input": ["src/js", "src/main/java"],
  "output": "docs",
  "title": "My Project (JS + Java)"
}
```

Or via command line:

```bash
jsduck src/js src/main/java --output docs
```

## Feature Comparison

### What Stays the Same

All JSDuck features continue to work:

- ✅ JavaScript/JSDoc parsing
- ✅ SCSS/CSS documentation
- ✅ Markdown support
- ✅ Custom tags
- ✅ Guides and videos
- ✅ HTML output with search
- ✅ All command-line options
- ✅ Configuration files
- ✅ Warning system
- ✅ External classes

### What's New

JavaDuck adds:

- ✨ **Java source parsing** - `.java` files automatically detected
- ✨ **Javadoc support** - Standard Javadoc tags (@author, @version, @see, @since)
- ✨ **Java type system** - Automatic type extraction from code
- ✨ **Mixed projects** - Document Java and JavaScript together
- ✨ **Unified output** - Single documentation site for all languages

## Command-Line Options

### Unchanged Options

All JSDuck command-line options work identically:

```bash
# These all work exactly as before
jsduck --output docs
jsduck --title "My Docs"
jsduck --builtin-classes
jsduck --warnings=-all
jsduck --config config.json
jsduck --guides guides.json
```

### New Java-Specific Behavior

JavaDuck automatically detects file types:

- `.js` → JavaScript parser (same as JSDuck)
- `.scss`/`.css` → CSS parser (same as JSDuck)
- `.java` → **Java parser (NEW)**

No special flags needed - just point to your source directories!

## Documentation Comment Migration

### JavaScript → No Changes

Your existing JSDoc comments work unchanged:

```javascript
/**
 * This still works exactly as before.
 *
 * @param {String} name The name
 * @return {Boolean} True if valid
 */
function validateName(name) {
    return name.length > 0;
}
```

### Adding Java Documentation

For Java code, use standard Javadoc:

```java
/**
 * Validates a user name.
 *
 * @param name The name to validate
 * @return true if valid
 */
public boolean validateName(String name) {
    return name.length() > 0;
}
```

**Key difference**: Javadoc doesn't use `{Type}` syntax - types come from code!

## Tag Compatibility

### Shared Tags (Work in Both)

These tags work in both JavaScript and Java:

| Tag | JavaScript | Java | Notes |
|-----|------------|------|-------|
| `@param` | ✅ | ✅ | JS uses `{Type}`, Java infers from code |
| `@return` | ✅ | ✅ | JS uses `{Type}`, Java infers from code |
| `@deprecated` | ✅ | ✅ | Same syntax |
| `@private` | ✅ | ✅ | Same syntax |
| `@protected` | ✅ | ✅ | Same syntax |

### JavaScript-Only Tags

These work in JS but not Java:

- `@class` - Java classes auto-detected
- `@method` - Java methods auto-detected
- `@property` - Java uses fields
- `@cfg` - Configuration (JS-specific)
- `@event` - Events (JS-specific)
- `@fires` - Event firing (JS-specific)

### Java-Specific Tags

These are new for Java:

- `@author` - Author information
- `@version` - Version number
- `@see` - Cross-references
- `@since` - Version introduced
- `@throws` - Exception documentation (replaces `@throws` in JSDoc)

## Project Structure Examples

### Pure JavaScript (No Changes)

**Before (JSDuck):**
```
my-js-project/
├── src/
│   └── *.js
└── jsduck.json
```

**After (JavaDuck):**
```
# Same structure, just install JavaDuck instead
```

### Mixed JavaScript/Java

**New structure with JavaDuck:**
```
my-mixed-project/
├── src/
│   ├── main/
│   │   └── java/       # Java backend
│   └── webapp/
│       └── js/         # JavaScript frontend
└── jsduck.json
```

**Configuration:**
```json
{
  "input": [
    "src/main/java",
    "src/webapp/js"
  ],
  "output": "docs"
}
```

### Java Only

**Pure Java project:**
```bash
jsduck src/main/java --output docs
```

## Common Migration Scenarios

### Scenario 1: Pure JavaScript Project

**You have:** Existing JSDuck setup for JavaScript

**Migration:**
1. Install JavaDuck
2. Run same commands
3. ✅ Done! No changes needed.

### Scenario 2: Add Java to Existing JS Docs

**You have:** JavaScript docs with JSDuck, now adding Java backend

**Migration:**
1. Install JavaDuck
2. Add Java source path to input
3. ✅ Done! Both documented together.

**Example:**
```bash
# Before
jsduck src/js --output docs

# After (adds Java)
jsduck src/js src/main/java --output docs
```

### Scenario 3: Pure Java Project (New)

**You have:** Java project, never used JSDuck

**Migration:**
1. Install JavaDuck
2. Point to Java sources
3. ✅ Done! Full Javadoc support.

**Example:**
```bash
jsduck src/main/java --output docs
```

### Scenario 4: Multi-Module Maven Project

**You have:** Maven project with multiple modules

**Migration:**
```bash
jsduck \
  module1/src/main/java \
  module2/src/main/java \
  module3/src/main/java \
  --output target/javaduck
```

Or use find:
```bash
jsduck $(find . -type d -path '*/src/main/java') --output docs
```

## Troubleshooting

### Issue: "JavaParser not found"

**Symptom:** Java files are skipped or errors about JavaParser

**Solution:**
- Install Java Runtime Environment (JRE 8+)
- Verify: `java -version`
- JavaDuck automatically uses JavaParser CLI

### Issue: Types Not Showing for Java Methods

**Symptom:** Java method parameters have no types in docs

**Solution:**
- Unlike JSDoc, Javadoc types come from code, not comments
- Ensure Java code is syntactically correct
- JavaParser extracts types automatically

### Issue: Custom JSDoc Tags Not Working

**Symptom:** Custom tags from JSDuck not recognized

**Solution:**
- Custom tags should still work for JavaScript
- Check tag definitions in `lib/jsduck/tag/`
- Java doesn't support custom tags (use standard Javadoc)

### Issue: Mixed Output Looks Inconsistent

**Symptom:** Java and JavaScript docs look different

**Solution:**
- Both use same templates - should look identical
- Check CSS customizations
- Verify both languages using same output directory

## Best Practices

### 1. Keep JavaScript and Java Separate (Initially)

When migrating, generate separate docs first:

```bash
# JavaScript only
jsduck src/js --output docs/js

# Java only
jsduck src/java --output docs/java
```

Then combine when comfortable:

```bash
# Both together
jsduck src/js src/java --output docs
```

### 2. Use Consistent Naming

Keep class/method names similar between languages:

```javascript
// JavaScript
class UserService {
    findUser(id) { }
}
```

```java
// Java
public class UserService {
    public User findUser(String id) { }
}
```

This helps users navigate between languages.

### 3. Cross-Link Between Languages

Reference related classes:

```java
/**
 * Java backend for user management.
 *
 * See JavaScript client: UserServiceClient
 *
 * @see UserServiceClient
 */
public class UserService { }
```

### 4. Document Type Mapping

When JS and Java interact (e.g., REST API), document type mappings:

```javascript
/**
 * @param {Object} user User object
 * @param {String} user.id User ID
 * @param {String} user.name User name
 *
 * Maps to Java class: com.example.User
 */
function saveUser(user) { }
```

### 5. Use Same Build Process

Integrate JavaDuck into existing build:

```json
{
  "scripts": {
    "docs": "jsduck src/js src/java --output docs"
  }
}
```

Or in Maven:

```xml
<plugin>
    <artifactId>exec-maven-plugin</artifactId>
    <executions>
        <execution>
            <phase>site</phase>
            <goals>
                <goal>exec</goal>
            </goals>
            <configuration>
                <executable>jsduck</executable>
                <arguments>
                    <argument>src/main/java</argument>
                    <argument>--output</argument>
                    <argument>target/javaduck</argument>
                </arguments>
            </configuration>
        </execution>
    </executions>
</plugin>
```

## Compatibility Matrix

| Feature | JSDuck | JavaDuck |
|---------|--------|----------|
| JavaScript parsing | ✅ | ✅ |
| JSDoc tags | ✅ | ✅ |
| SCSS/CSS parsing | ✅ | ✅ |
| Java parsing | ❌ | ✅ |
| Javadoc tags | ❌ | ✅ |
| Markdown | ✅ | ✅ |
| Guides | ✅ | ✅ |
| Videos | ✅ | ✅ |
| Custom tags | ✅ | ✅ (JS only) |
| Search | ✅ | ✅ |
| Mobile responsive | ✅ | ✅ |

## Getting Help

- **Documentation:** [docs/java-support.md](java-support.md)
- **Tag Reference:** [docs/javadoc-tags.md](javadoc-tags.md)
- **FAQ:** [docs/faq.md](faq.md)
- **Issues:** [GitHub Issues](https://github.com/martinvidec/javaduck/issues)

## Summary

**Migration is simple:**

1. ✅ Install JavaDuck (replaces JSDuck)
2. ✅ Use same commands and configuration
3. ✅ Optionally add Java sources
4. ✅ Enjoy unified documentation!

**Key takeaway:** JavaDuck is JSDuck with Java support added. Everything that worked before still works!
