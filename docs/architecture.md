# JavaDuck Architecture

Technical documentation of JavaDuck's architecture and implementation.

## Overview

JavaDuck extends JSDuck's modular architecture with Java parsing capabilities while maintaining full backward compatibility with JavaScript documentation generation.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CLI Entry Point                          │
│                      bin/jsduck                             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   Application (app.rb)                      │
│              Orchestrates entire doc generation             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                BatchParser (batch_parser.rb)                │
│            Processes input files in parallel                │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   Parser (parser.rb)                        │
│         Routes to language-specific parsers by file         │
│                      extension                              │
└────────────┬───────────┬────────────┬───────────────────────┘
             │           │            │
    ┌────────┘           │            └────────┐
    │                    │                     │
    ▼                    ▼                     ▼
┌──────────┐      ┌──────────┐         ┌──────────┐
│   Java   │      │    JS    │         │   CSS    │
│  Parser  │      │  Parser  │         │  Parser  │
└─────┬────┘      └─────┬────┘         └─────┬────┘
      │                 │                    │
      ▼                 ▼                    ▼
┌──────────┐      ┌──────────┐         ┌──────────┐
│   Java   │      │    JS    │         │   CSS    │
│   AST    │      │   AST    │         │   AST    │
└─────┬────┘      └─────┬────┘         └─────┬────┘
      │                 │                    │
      └─────────────────┴────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              Doc::Parser (doc/parser.rb)                    │
│         Parses documentation comment blocks                 │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│             TagRegistry (tag_registry.rb)                   │
│          Processes @tags (param, return, etc.)              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  Merger (merger.rb)                         │
│        Combines code detection with doc comments            │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│               Aggregator (aggregator.rb)                    │
│          Groups members into classes/interfaces             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                 HTML Output (template/)                     │
│              Generates browsable documentation              │
└─────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. Parser Routing (lib/jsduck/parser.rb)

**Responsibility:** Route files to appropriate language parser

**Key code:**
```ruby
def parse_js_or_scss(contents, filename, options)
  if filename =~ /\.scss$/
    docs = Css::Parser.new(contents, options).parse
  elsif filename =~ /\.java$/
    docs = Java::Parser.new(contents, options).parse
    docs = Java::Ast.new(docs).detect_all!
  else
    docs = Js::Parser.new(contents, options).parse
    docs = Js::Ast.new(docs).detect_all!
  end
end
```

**Flow:**
1. Check file extension
2. Instantiate appropriate parser
3. Parse to intermediate format
4. Run AST detection
5. Return normalized docsets

### 2. Java Parser (lib/jsduck/java/parser.rb)

**Responsibility:** Parse Java source files using JavaParser

**Architecture:**

```
┌──────────────────────────────────────────────┐
│          Java::Parser                        │
│  (lib/jsduck/java/parser.rb)                 │
└──────────────┬───────────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────────┐
│      JavaParser CLI (external)               │
│  - Parses Java source to AST                 │
│  - Exports JSON representation               │
└──────────────┬───────────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────────┐
│       JSON Processing (Ruby)                 │
│  - Parse JSON AST                            │
│  - Extract code elements                     │
└──────────────┬───────────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────────┐
│       Java::Associator                       │
│  (lib/jsduck/java/associator.rb)             │
│  - Link Javadoc comments to code             │
└──────────────┬───────────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────────┐
│        Normalized Docsets                    │
│  - Unified format for all languages          │
└──────────────────────────────────────────────┘
```

**Key features:**
- **External dependency**: Uses JavaParser CLI (Java program)
- **JSON bridge**: Communicates via JSON format
- **Comment extraction**: Preserves Javadoc comments from source
- **Type information**: Extracts complete type signatures

### 3. Java AST Detection (lib/jsduck/java/ast.rb)

**Responsibility:** Detect and classify Java code elements

**Detector chain:**

```ruby
def detect(node)
  ast = Java::Node.create(node)

  if doc = Java::Class.detect(ast, @docs)
    doc
  elsif doc = Java::Interface.detect(ast, @docs)
    doc
  elsif doc = Java::Enum.detect(ast, @docs)
    doc
  elsif doc = Java::Method.detect(ast)
    doc
  elsif doc = Java::Field.detect(ast)
    doc
  else
    Java::Field.make()  # Default fallback
  end
end
```

**Detectors:**

| Detector | File | Detects |
|----------|------|---------|
| `Java::Class` | `lib/jsduck/java/class.rb` | Class declarations with extends/implements |
| `Java::Interface` | `lib/jsduck/java/interface.rb` | Interface definitions |
| `Java::Enum` | `lib/jsduck/java/enum.rb` | Enum types with constants |
| `Java::Method` | `lib/jsduck/java/method.rb` | Methods and constructors |
| `Java::Field` | `lib/jsduck/java/field.rb` | Fields and constants |
| `Java::Node` | `lib/jsduck/java/node.rb` | AST node wrapper utilities |

### 4. Documentation Comment Parsing (lib/jsduck/doc/parser.rb)

**Responsibility:** Parse JSDoc/Javadoc comment blocks

**Shared between languages:**
- Same parser handles both JSDoc and Javadoc
- Conditional type parsing (JSDoc uses `{Type}`, Javadoc doesn't)
- Tag processing delegated to TagRegistry

**Flow:**
```
/** ... */ ──> Doc::Parser ──> Structured tags ──> TagRegistry
```

### 5. Tag System (lib/jsduck/tag/)

**Responsibility:** Process and format documentation tags

**Tag architecture:**

```
TagRegistry
│
├─ @param (lib/jsduck/tag/param.rb)
├─ @return (lib/jsduck/tag/return.rb)
├─ @throws (lib/jsduck/tag/throws.rb)
├─ @author (lib/jsduck/tag/author.rb)
├─ @version (lib/jsduck/tag/version.rb)
├─ @see (lib/jsduck/tag/see.rb)
├─ @since (lib/jsduck/tag/since.rb)
├─ @deprecated (lib/jsduck/tag/deprecated.rb)
└─ ... (other tags)
```

**Tag lifecycle:**
1. **Detection**: Tag pattern matched in comment
2. **Parsing**: Tag content extracted
3. **Processing**: Tag data added to doc hash
4. **Formatting**: Tag rendered to HTML in output

**Adding new tags:**

```ruby
# lib/jsduck/tag/newtag.rb
require "jsduck/tag/tag"

module JsDuck::Tag
  class NewTag < Tag
    def initialize
      @pattern = "newtag"
      @tagname = :newtag
    end

    def parse_doc(p, pos)
      {
        :tagname => :newtag,
        :value => p.input.scan(/.+/).strip
      }
    end

    def process_doc(h, tags, pos)
      h[:newtag] = tags.first[:value] if tags.first
    end

    def to_html(cls)
      "<p><strong>NewTag:</strong> #{cls[:newtag]}</p>" if cls[:newtag]
    end
  end
end
```

## Java-Specific Implementation Details

### JavaParser Integration

**Execution model:**

```ruby
# Simplified version
def parse_with_javaparser(source_code)
  # 1. Write source to temp file
  temp_file = write_temp_file(source_code)

  # 2. Execute JavaParser CLI
  json_output = `javaparser-cli #{temp_file}`

  # 3. Parse JSON result
  ast = JSON.parse(json_output)

  # 4. Extract elements
  extract_classes_methods_fields(ast)
end
```

**Benefits:**
- Robust Java parsing (same library javac uses internally)
- Full Java language support (generics, annotations, etc.)
- No Ruby Java parser needed

**Tradeoffs:**
- External JVM dependency required
- Subprocess overhead (mitigated by batch processing)
- JSON serialization overhead

### Type Extraction

**Java types automatically extracted:**

```java
public List<String> getUserNames(int limit) { }
```

**Extracted information:**
```ruby
{
  :name => "getUserNames",
  :params => [
    { :name => "limit", :type => "int" }
  ],
  :return => {
    :type => "List<String>"
  }
}
```

**Contrast with JavaScript:**

```javascript
/**
 * @param {Number} limit
 * @return {String[]}
 */
function getUserNames(limit) { }
```

**JavaScript extraction:**
```ruby
{
  :name => "getUserNames",
  :params => [
    { :name => "limit", :type => "Number" }  # From JSDoc tag
  ],
  :return => {
    :type => "String[]"  # From JSDoc tag
  }
}
```

### Comment Association

**Challenges:**
- Javadoc must be associated with correct element
- Comments can appear before classes, methods, fields
- Must handle multiple consecutive comments

**Solution (Java::Associator):**

```ruby
def associate_comments(ast_nodes, source_with_comments)
  comments = extract_javadoc_comments(source_with_comments)

  ast_nodes.each do |node|
    # Find comment immediately preceding this node
    comment = find_preceding_comment(node, comments)
    node[:comment] = comment if comment
  end
end
```

## Data Flow

### Complete processing pipeline:

```
Input: Calculator.java
│
├─ [Parser Router]
│  └─ Detects .java extension
│
├─ [Java::Parser]
│  ├─ Execute JavaParser CLI
│  ├─ Receive JSON AST
│  └─ Extract code elements
│
├─ [Java::Associator]
│  └─ Link Javadoc comments to elements
│
├─ [Java::Ast]
│  ├─ Java::Class.detect → Class info
│  ├─ Java::Method.detect → Method info
│  └─ Java::Field.detect → Field info
│
├─ [Doc::Parser]
│  └─ Parse Javadoc tags (@param, @return, etc.)
│
├─ [TagRegistry]
│  └─ Process tags into structured data
│
├─ [Merger]
│  └─ Merge code info + doc comments
│
├─ [Aggregator]
│  └─ Group methods/fields into classes
│
└─ [Output]
   └─ Generate HTML documentation
```

### Data structure evolution:

**1. After Java::Parser:**
```ruby
[
  {
    :type => :doc_comment,
    :comment => "/** Adds two numbers... */",
    :code => {
      :type => "MethodDeclaration",
      :name => "add",
      :parameters => [...],
      :returnType => "int"
    }
  }
]
```

**2. After Java::Ast:**
```ruby
[
  {
    :tagname => :method,
    :name => "add",
    :params => [
      { :name => "a", :type => "int" },
      { :name => "b", :type => "int" }
    ],
    :return => { :type => "int" },
    :doc => "/** Adds two numbers... */"
  }
]
```

**3. After Doc::Parser + TagRegistry:**
```ruby
[
  {
    :tagname => :method,
    :name => "add",
    :params => [
      {
        :name => "a",
        :type => "int",
        :doc => "The first number"  # From @param tag
      },
      {
        :name => "b",
        :type => "int",
        :doc => "The second number"  # From @param tag
      }
    ],
    :return => {
      :type => "int",
      :doc => "The sum of a and b"  # From @return tag
    }
  }
]
```

## Key Design Decisions

### 1. External JavaParser vs Ruby Parser

**Decision:** Use JavaParser (Java library) via CLI

**Rationale:**
- ✅ Robust, production-tested parser
- ✅ Full Java language support
- ✅ Actively maintained
- ✅ Same parser javac uses internally
- ❌ Requires JVM (acceptable tradeoff)
- ❌ Subprocess overhead (mitigated by batching)

**Alternatives considered:**
- Ruby Java parser gem - not mature enough
- Custom parser - too much work, error-prone

### 2. Parallel Parser Architecture

**Decision:** Keep Java parser parallel to JS parser

**Rationale:**
- ✅ Minimal changes to existing JSDuck code
- ✅ Clear separation of concerns
- ✅ Easy to maintain/test independently
- ✅ Can evolve Java support without breaking JS

**Structure:**
```
lib/jsduck/
├── js/          # JavaScript parsing
│   ├── parser.rb
│   ├── ast.rb
│   └── ...
├── java/        # Java parsing (parallel structure)
│   ├── parser.rb
│   ├── ast.rb
│   └── ...
└── parser.rb    # Routes between them
```

### 3. Shared vs Separate Components

**Shared components (reused for Java):**
- Doc::Parser - documentation comment parsing
- TagRegistry - @tag processing (extended for Java-specific tags)
- Merger - combining code + docs
- Aggregator - grouping into classes
- Output layer - HTML generation

**Java-specific components:**
- Java::Parser - source parsing
- Java::Ast - code detection
- Java::Associator - comment linking
- Java-specific tags (@author, @version, @see)

**Rationale:**
- Maximize code reuse where logic is language-independent
- Isolate language-specific complexity
- Maintain backward compatibility

### 4. Type System Handling

**Decision:** Extract types from code, not tags

**Rationale:**
- Java has strong typing in source code
- Redundant to require types in Javadoc
- Reduces documentation burden
- Ensures docs can't go out of sync with code

**Implementation:**
```ruby
# JavaScript: Types from JSDoc
{
  :params => [{ :name => "x", :type => "Number" }]  # From @param {Number} x
}

# Java: Types from code
{
  :params => [{ :name => "x", :type => "int" }]     # From signature: foo(int x)
}
```

## Performance Considerations

### Parsing Performance

**Bottlenecks:**
1. JavaParser subprocess spawning
2. JSON serialization/deserialization
3. File I/O

**Optimizations:**
1. **Batch processing** - parse multiple files per JavaParser invocation
2. **Parallel processing** - use Ruby threads for multiple parsers
3. **Caching** - cache AST results (inherited from JSDuck)

### Memory Usage

**Large projects:**
- AST structures held in memory
- All documentation accumulated before output

**Mitigation:**
- Stream processing where possible
- Garbage collection between phases
- Configurable memory limits for JavaParser JVM

## Testing Strategy

### Unit Tests

Located in `spec/`:

```
spec/
├── java_parser_spec.rb         # Java parser tests
├── java_ast_spec.rb            # AST detection tests
├── java_class_spec.rb          # Class detection tests
├── java_method_spec.rb         # Method detection tests
├── java_field_spec.rb          # Field detection tests
└── javadoc_tags_spec.rb        # Javadoc tag tests
```

### Integration Tests

Test complete pipeline with sample Java files:

```ruby
describe "Java documentation generation" do
  it "documents a simple class" do
    result = generate_docs_for("examples/java/Calculator.java")
    expect(result).to include_class("Calculator")
    expect(result).to include_method("add")
  end
end
```

### Test Data

Sample Java files in `examples/java/`:
- Simple classes
- Interfaces
- Enums
- Generics
- Complex inheritance
- Full Javadoc comments

## Extension Points

### Adding New Java-Specific Tags

1. Create tag file: `lib/jsduck/tag/newtag.rb`
2. Inherit from `JsDuck::Tag::Tag`
3. Implement required methods
4. Tag auto-loaded by TagRegistry

### Adding New Code Detectors

1. Create detector: `lib/jsduck/java/annotation.rb`
2. Implement `detect(ast)` method
3. Add to detection chain in `Java::Ast`

### Customizing Output

1. Modify templates: `template/`
2. Add CSS: `template/resources/css/`
3. Add JavaScript: `template/resources/js/`

## Limitations

### Current Limitations

1. **Java Modules**
   - Java 9+ module-info.java not processed
   - Workaround: Exclude from input

2. **Annotations**
   - Recognized but not fully documented
   - Future: Extract annotation parameters

3. **Generic Bounds**
   - Complex bounds may display imperfectly
   - Future: Improve generic type formatting

4. **Lambda Expressions**
   - Method references limited
   - Future: Better functional interface support

### Future Enhancements

- **Kotlin support** - Similar architecture to Java
- **Package documentation** - package-info.java support
- **Annotation processing** - Full annotation parameter extraction
- **UML diagrams** - Class hierarchy visualization
- **Cross-language linking** - Link Java ↔ JavaScript automatically

## Debugging

### Enable Debug Output

```bash
# Set environment variable
export JSDUCK_DEBUG=1
jsduck src/main/java --output docs
```

### Common Issues

**Java files skipped:**
- Check file extension is `.java`
- Verify JRE installed: `java -version`
- Enable debug mode to see parser output

**Types not showing:**
- Check Java syntax validity
- Run JavaParser directly to verify AST generation
- Inspect intermediate JSON output

**Tags not processed:**
- Verify Javadoc comment format: `/** ... */`
- Check tag spelling
- Enable debug to see tag parsing

## Further Reading

- [Java Support Guide](java-support.md)
- [Migration Guide](migration-guide.md)
- [Javadoc Tags Reference](javadoc-tags.md)
- [Original JSDuck Wiki](https://github.com/senchalabs/jsduck/wiki)
