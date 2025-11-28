# JavaDuck Documentation

Welcome to the JavaDuck documentation!

## Quick Links

### Getting Started

- **[Java Support Guide](java-support.md)** - Complete guide to using JavaDuck with Java code
- **[Migration Guide](migration-guide.md)** - Moving from JSDuck to JavaDuck
- **[FAQ](faq.md)** - Frequently asked questions

### Reference

- **[Javadoc Tags Reference](javadoc-tags.md)** - Complete reference for all supported Javadoc tags
- **[Architecture](architecture.md)** - Technical architecture and implementation details

### Other Documents

- **[Parser Evaluation](parser-evaluation.md)** - Research and decision process for Java parser selection

## What is JavaDuck?

JavaDuck is a fork of [JSDuck](https://github.com/senchalabs/jsduck) extended with Java source code parsing and Javadoc documentation support.

**Key features:**
- Full JavaScript/JSDoc support (original JSDuck features)
- Complete Java source code parsing
- All standard Javadoc tags (@param, @return, @throws, @author, @version, @see, @since, @deprecated)
- Unified documentation for mixed JavaScript/Java projects
- Modern, searchable UI with Markdown support

## Documentation Overview

### [Java Support Guide](java-support.md)

The main guide for using JavaDuck with Java:
- How Java parsing works
- Supported Javadoc tags
- Usage examples
- Best practices
- Troubleshooting

**Start here** if you're new to JavaDuck and want to document Java code.

### [Migration Guide](migration-guide.md)

For existing JSDuck users:
- Backward compatibility details
- How to add Java to existing JavaScript docs
- Configuration changes (spoiler: none required!)
- Common migration scenarios

**Start here** if you're already using JSDuck for JavaScript.

### [Javadoc Tags Reference](javadoc-tags.md)

Complete reference for all Javadoc tags:
- Tag syntax and usage
- Examples for each tag
- Inline tags ({@link}, {@code}, etc.)
- Best practices
- Complete examples

**Use this** as a quick reference when writing Javadoc comments.

### [Architecture](architecture.md)

Technical deep-dive:
- System architecture
- Java parser integration (JavaParser CLI)
- AST detection
- Data flow through the system
- Extension points

**Read this** if you want to understand how JavaDuck works internally or contribute code.

### [FAQ](faq.md)

Answers to common questions:
- Installation and setup
- Usage and features
- Troubleshooting
- Performance
- Comparison with other tools

**Check here** if you have a specific question or problem.

## Quick Start

### Installation

```bash
git clone https://github.com/martinvidec/javaduck.git
cd javaduck
bundle install
rake build
gem install pkg/jsduck-*.gem
```

### Prerequisites

- Ruby 2.0+
- **Java Runtime Environment (JRE) 8+** (for Java support)

### Basic Usage

**Document Java code:**
```bash
jsduck src/main/java --output docs
```

**Document JavaScript + Java:**
```bash
jsduck src/main/java src/main/resources/js --output docs
```

**Use configuration file:**
```bash
jsduck --config jsduck.json
```

## Example Configuration

```json
{
  "input": [
    "src/main/java",
    "src/main/resources/js"
  ],
  "output": "docs",
  "title": "My Project API",
  "exclude": ["**/test/**"],
  "warnings": ["-all"]
}
```

## Need Help?

- Read the [FAQ](faq.md)
- Check [GitHub Issues](https://github.com/martinvidec/javaduck/issues)
- Review the [Java Support Guide](java-support.md)

## Contributing

Contributions welcome! Please:
- Report bugs via GitHub Issues
- Suggest features or improvements
- Submit pull requests
- Improve documentation

## License

JavaDuck is distributed under the GNU General Public License version 3, same as the original JSDuck.

## Credits

JavaDuck is based on [JSDuck](https://github.com/senchalabs/jsduck) by Rene Saarsoo and the JSDuck contributors.

Java support added by the JavaDuck project.
