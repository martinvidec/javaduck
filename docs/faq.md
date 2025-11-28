# JavaDuck FAQ

Frequently asked questions about JavaDuck and Java documentation support.

## General Questions

### What is JavaDuck?

JavaDuck is a fork of [JSDuck](https://github.com/senchalabs/jsduck) extended with Java source code parsing and Javadoc documentation support. It can document JavaScript, Java, and CSS/SCSS in a single unified documentation site.

### Why use JavaDuck instead of standard Javadoc?

**Advantages over standard Javadoc:**
- **Modern UI** - Clean, searchable, responsive design
- **Markdown support** - Rich formatting in doc comments
- **Mixed projects** - Document Java backend + JavaScript frontend together
- **Better navigation** - Tree view, search, inheritance visualization
- **Customizable** - Themes, guides, videos, custom branding

**Advantages over JSDuck:**
- **Java support** - Can document Java code (JSDuck only does JavaScript)
- **Javadoc parsing** - Understands standard Javadoc tags
- **Still maintained** - Fork continues development

### Is JavaDuck backward compatible with JSDuck?

**Yes, 100% backward compatible.**

All JSDuck features work unchanged:
- JavaScript/JSDoc parsing
- SCSS/CSS documentation
- Command-line options
- Configuration files
- Custom tags and guides

You can use JavaDuck as a drop-in replacement for JSDuck.

### What's the relationship to JSDuck?

JavaDuck is a **fork** of JSDuck (not a plugin or extension).

**Timeline:**
- **JSDuck** - Original project by Sencha, no longer maintained
- **JavaDuck** - Fork adding Java support, active development

We maintain the same codebase structure and keep JSDuck features intact while adding Java capabilities.

## Installation & Setup

### What are the prerequisites?

**For JavaScript documentation only:**
- Ruby 2.0 or higher
- RubyGems

**For Java documentation:**
- Ruby 2.0 or higher
- RubyGems
- **Java Runtime Environment (JRE) 8 or higher**

JavaDuck uses JavaParser (a Java program) to parse Java source files, so a JRE is required for Java support.

### How do I check if Java is installed?

```bash
java -version
```

You should see output like:
```
java version "1.8.0_292"
```

If not installed, download from [java.com](https://www.java.com) or install via your package manager.

### How do I install JavaDuck?

**From source:**

```bash
git clone https://github.com/martinvidec/javaduck.git
cd javaduck
bundle install
rake build
gem install pkg/jsduck-*.gem
```

**Note:** The command is still `jsduck` (not `javaduck`) for compatibility.

### Can I use JavaDuck without Java installed?

**Yes!** If you only document JavaScript/CSS, JavaDuck works without Java installed. It only requires Java when processing `.java` files.

## Usage

### How do I document a Java project?

**Basic usage:**

```bash
jsduck src/main/java --output docs
```

This will:
1. Find all `.java` files in `src/main/java`
2. Parse them with JavaParser
3. Extract Javadoc comments
4. Generate HTML documentation in `docs/`

### How do I document both Java and JavaScript?

**Just include both directories:**

```bash
jsduck src/main/java src/main/resources/js --output docs
```

JavaDuck automatically detects file types:
- `.java` → Java parser
- `.js` → JavaScript parser
- `.scss`/`.css` → CSS parser

All output goes to a unified documentation site.

### Do I need to change my Javadoc comments?

**No!** Standard Javadoc comments work as-is:

```java
/**
 * Adds two numbers.
 *
 * @param a The first number
 * @param b The second number
 * @return The sum
 */
public int add(int a, int b) {
    return a + b;
}
```

JavaDuck understands all standard Javadoc tags.

### Can I use JSDoc-style types in Java?

**No, and you shouldn't need to.**

In JavaScript, JSDoc types are necessary:
```javascript
/**
 * @param {String} name    // Type required
 * @return {Number}        // Type required
 */
```

In Java, types come from the code:
```java
/**
 * @param name   // NO type annotation needed
 * @return       // NO type annotation needed
 */
public int getName(String name) {
    return 42;
}
```

JavaDuck automatically extracts `String` and `int` from the method signature.

### What if I have existing JSDoc comments in Java files?

If you have JSDoc-style type annotations in Javadoc:

```java
/**
 * @param {String} name    // JSDoc style - not standard Javadoc
 */
public void setName(String name) { }
```

JavaDuck will:
- Ignore the `{String}` type (uses code signature instead)
- Still process the description
- Show a warning (can be suppressed)

**Best practice:** Remove JSDoc type annotations from Javadoc for cleaner docs.

## Features

### Which Javadoc tags are supported?

**All standard Javadoc tags:**

| Tag | Supported | Notes |
|-----|-----------|-------|
| `@param` | ✅ | Parameter documentation |
| `@return` | ✅ | Return value documentation |
| `@throws` | ✅ | Exception documentation |
| `@exception` | ✅ | Synonym for @throws |
| `@see` | ✅ | Cross-references |
| `@author` | ✅ | Author information |
| `@version` | ✅ | Version number |
| `@since` | ✅ | Version introduced |
| `@deprecated` | ✅ | Deprecation notice |
| `@serial` | ✅ | Serialization info |
| `@serialField` | ✅ | Serialization field |
| `@serialData` | ✅ | Serialization data |

See [Javadoc Tags Reference](javadoc-tags.md) for details.

### Can I use Markdown in Javadoc?

**Yes!** JavaDuck supports full Markdown formatting:

```java
/**
 * # Calculator Service
 *
 * Provides mathematical operations:
 * - Addition
 * - Subtraction
 * - **Multiplication** (new in v2.0)
 *
 * ## Example
 *
 * ```java
 * Calculator calc = new Calculator();
 * int result = calc.add(5, 3);
 * ```
 *
 * @see <a href="https://example.com">Documentation</a>
 */
public class Calculator {
    // ...
}
```

This renders with proper formatting, code blocks, lists, etc.

### Are Java generics supported?

**Yes!** JavaDuck parses generic types:

```java
/**
 * Generic repository interface.
 *
 * @param <T> The entity type
 */
public interface Repository<T> {
    /**
     * Saves an entity.
     *
     * @param entity The entity to save
     * @return The saved entity
     */
    T save(T entity);

    /**
     * Finds all entities.
     *
     * @return List of all entities
     */
    List<T> findAll();
}
```

Generics appear correctly in documentation with type parameters.

### Are annotations documented?

**Partially.** Annotations are recognized but not fully documented.

**Current support:**
- Annotations are parsed
- Annotated elements still documented
- Annotation names visible

**Not yet supported:**
- Annotation parameter extraction
- Annotation-specific documentation

**Example:**
```java
@Entity
@Table(name = "users")  // Recognized but parameters not extracted
public class User {
    // Documented normally
}
```

### Can I document interfaces and abstract classes?

**Yes!** All Java types are supported:

- Classes (concrete and abstract)
- Interfaces
- Enums
- Annotations
- Inner classes
- Anonymous classes (limited)

### How are inner classes handled?

**Inner classes are supported:**

```java
public class Outer {
    /**
     * Inner class documentation.
     */
    public class Inner {
        // ...
    }

    /**
     * Static nested class.
     */
    public static class Nested {
        // ...
    }
}
```

They appear in documentation as `Outer.Inner` and `Outer.Nested`.

## Common Issues

### "JavaParser not found" error

**Problem:** When running JavaDuck on `.java` files, get error about JavaParser.

**Solution:**
1. Verify Java is installed: `java -version`
2. Install JRE 8 or higher if missing
3. Restart terminal after Java installation
4. Verify `java` is in PATH

### Java files are being ignored

**Problem:** `.java` files in input directory but not appearing in docs.

**Check:**
1. File extension is exactly `.java` (case-sensitive)
2. Files contain valid Java syntax
3. Java is installed (see above)
4. No syntax errors in Java files

**Debug:**
```bash
# Enable debug output
export JSDUCK_DEBUG=1
jsduck src/main/java --output docs
```

### Types not showing in documentation

**Problem:** Method parameters show no type information.

**Cause:** Usually invalid Java syntax prevents parsing.

**Solution:**
1. Verify Java files compile: `javac YourFile.java`
2. Check for syntax errors
3. Ensure generic syntax is correct
4. Try parsing file alone to isolate issue

### Custom Javadoc tags not recognized

**Problem:** Custom tags (e.g., `@customTag`) not processed.

**Explanation:** JavaDuck supports standard Javadoc tags only. Custom tags are preserved in description but not specially formatted.

**Workaround:**
- Use standard tags where possible
- For custom needs, use standard `@see` tag with description
- Markdown formatting can achieve most custom formatting needs

### Javadoc and code are out of sync

**Problem:** Documentation says one thing but code does something else.

**Not really a JavaDuck issue, but common problem!**

**Prevention:**
- Keep doc comments close to code
- Update docs when changing code
- Use CI to generate docs and catch missing/outdated comments
- Use `@deprecated` tag when replacing methods

## Performance

### Is JavaDuck slow on large Java projects?

**Performance factors:**
- First run slower (Java parsing via subprocess)
- Subsequent runs faster (caching)
- Large projects (1000+ classes) take minutes, not hours

**Optimizations:**
1. **Parallel processing** - Use `--processes N` for multi-core
2. **Exclude test code** - Don't document test sources unless needed
3. **Incremental builds** - Only re-process changed files (caching)

**Example for large project:**
```bash
# Use 4 parallel processes
jsduck src/main/java --output docs --processes 4
```

### Can I speed up documentation generation?

**Tips:**

1. **Exclude unnecessary files:**
   ```bash
   jsduck src/main/java --exclude='**/test/**' --output docs
   ```

2. **Reduce warning processing:**
   ```bash
   jsduck src/main/java --warnings=-all --output docs
   ```

3. **Use caching** (automatic in JavaDuck)

4. **Parallel processing:**
   ```bash
   jsduck --processes $(nproc) src/main/java --output docs
   ```

## Advanced Topics

### Can I customize the output HTML?

**Yes!** Templates are in `template/` directory:

- **HTML templates:** `template/*.html`
- **CSS:** `template/resources/css/`
- **JavaScript:** `template/resources/js/`

You can modify these to change appearance or add features.

### Can I add custom tags?

**For JavaScript, yes.** For Java, standard tags only.

**JavaScript custom tag:**
```ruby
# lib/jsduck/tag/custom.rb
class CustomTag < Tag
  # implementation
end
```

**Why not Java?** Javadoc has standard tag set; adding custom tags would break compatibility with standard tools.

### Can I generate docs in CI/CD?

**Yes, great idea!**

**GitHub Actions example:**
```yaml
name: Generate Docs

on: [push]

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 2.7

      - name: Set up Java
        uses: actions/setup-java@v2
        with:
          java-version: '11'

      - name: Install JavaDuck
        run: |
          git clone https://github.com/martinvidec/javaduck.git
          cd javaduck
          bundle install
          rake build
          gem install pkg/jsduck-*.gem

      - name: Generate docs
        run: jsduck src/main/java --output docs

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

### Can I integrate with Maven/Gradle?

**Yes!**

**Maven exec plugin:**
```xml
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>exec-maven-plugin</artifactId>
    <version>3.0.0</version>
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

**Gradle exec task:**
```gradle
task generateDocs(type: Exec) {
    commandLine 'jsduck', 'src/main/java', '--output', 'build/javaduck'
}

build.dependsOn generateDocs
```

### Does JavaDuck support multi-module projects?

**Yes!** Just include all module source directories:

```bash
jsduck \
  module1/src/main/java \
  module2/src/main/java \
  module3/src/main/java \
  --output docs
```

Or use shell expansion:
```bash
jsduck $(find . -path '*/src/main/java') --output docs
```

All modules documented in single unified site.

## Comparison with Other Tools

### JavaDuck vs Standard Javadoc?

| Feature | Javadoc | JavaDuck |
|---------|---------|----------|
| Java support | ✅ | ✅ |
| JavaScript support | ❌ | ✅ |
| Modern UI | ❌ | ✅ |
| Markdown | ❌ | ✅ |
| Search | Basic | Advanced |
| Mobile friendly | ❌ | ✅ |
| Customizable | Limited | Highly |

**Use Javadoc if:** You need Oracle-standard output, strict compatibility

**Use JavaDuck if:** You want modern UI, mixed JS/Java, Markdown support

### JavaDuck vs Doxygen?

| Feature | Doxygen | JavaDuck |
|---------|---------|----------|
| Language support | Many | Java, JavaScript, CSS |
| Java parsing | ✅ | ✅ |
| JavaScript parsing | Limited | ✅ Full |
| Output quality | Good | Excellent |
| Ease of use | Complex | Simple |

**Use Doxygen if:** You need C/C++/Python/other languages

**Use JavaDuck if:** You have Java/JavaScript only and want beautiful output

### JavaDuck vs JSDoc?

**JSDoc is JavaScript-only.** JavaDuck is JSDoc-compatible but also supports Java.

**Use JSDoc if:** Pure JavaScript project, no Java

**Use JavaDuck if:** Mixed Java/JavaScript, or want JSDuck features

## Getting Help

### Where can I get help?

- **Documentation:** Start with [Java Support Guide](java-support.md)
- **Migration:** See [Migration Guide](migration-guide.md)
- **Tag reference:** See [Javadoc Tags](javadoc-tags.md)
- **Architecture:** See [Architecture](architecture.md)
- **Issues:** [GitHub Issues](https://github.com/martinvidec/javaduck/issues)

### How do I report a bug?

**On GitHub Issues:**

1. Go to https://github.com/martinvidec/javaduck/issues
2. Click "New Issue"
3. Include:
   - JavaDuck version
   - Java version (`java -version`)
   - Ruby version (`ruby -version`)
   - Sample code that demonstrates issue
   - Expected vs actual behavior

### How can I contribute?

**Contributions welcome!**

- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation
- Share usage examples

See [CONTRIBUTING.md](../CONTRIBUTING.md) (if exists) or create an issue to discuss.

## Troubleshooting Checklist

**If JavaDuck isn't working:**

- [ ] Java installed? (`java -version`)
- [ ] Ruby installed? (`ruby -version`)
- [ ] JavaDuck installed? (`jsduck --version`)
- [ ] Input files exist? (`ls src/main/java`)
- [ ] Correct file extensions? (`.java` not `.jav`)
- [ ] Valid Java syntax? (`javac MyFile.java`)
- [ ] Output directory writable? (`mkdir -p docs`)
- [ ] No firewall blocking subprocess execution?

**Enable debug mode:**
```bash
export JSDUCK_DEBUG=1
jsduck src/main/java --output docs 2>&1 | tee debug.log
```

Then review `debug.log` for errors.

## Quick Reference

### Basic Commands

```bash
# Document Java project
jsduck src/main/java --output docs

# Document Java + JavaScript
jsduck src/main/java src/js --output docs

# With custom title
jsduck src/main/java --output docs --title "My Project API"

# With configuration file
jsduck --config jsduck.json

# Exclude test code
jsduck src/main/java --exclude='**/test/**' --output docs
```

### Configuration File Example

```json
{
  "input": [
    "src/main/java",
    "src/main/resources/js"
  ],
  "output": "docs",
  "title": "My Project Documentation",
  "exclude": ["**/test/**", "**/internal/**"],
  "warnings": ["-all"],
  "processes": 4
}
```

## Summary

**JavaDuck = JSDuck + Java support**

- ✅ 100% backward compatible with JSDuck
- ✅ All standard Javadoc tags supported
- ✅ Automatic type extraction from Java code
- ✅ Markdown support in documentation
- ✅ Mixed JavaScript/Java projects
- ✅ Modern, searchable UI
- ✅ Active development

**Quick start:**
1. Install Java (JRE 8+)
2. Install JavaDuck
3. Run: `jsduck src/main/java --output docs`
4. Open `docs/index.html`

For more help, see the [documentation](java-support.md) or [open an issue](https://github.com/martinvidec/javaduck/issues).
