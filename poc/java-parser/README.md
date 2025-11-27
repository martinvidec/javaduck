# JavaParser CLI Proof of Concept

## Überblick

Dieser Proof of Concept demonstriert die Integration von JavaParser in JavaDuck über eine CLI-Bridge.

## Komponenten

1. **JavaParserCLI.java** - Java-Wrapper der JavaParser als JSON ausgibt
2. **pom.xml** - Maven Build-Konfiguration
3. **test_parser.rb** - Ruby-Script zum Testen der Integration
4. **TestClass.java** - Beispiel-Java-Klasse zum Parsen

## Voraussetzungen

- Java JDK 11 oder höher
- Maven 3.6+
- Ruby 2.7+

## Build

```bash
# Im poc/java-parser Verzeichnis
mvn clean package
```

Dies erstellt `target/javaparser-cli.jar` (ca. 3-4 MB)

## Test

```bash
# Nach dem Build
ruby test_parser.rb
```

## Erwartete Ausgabe

```
📝 Parsing TestClass.java...
============================================================
✅ Parsing successful!

📊 Results:
------------------------------------------------------------

Type: class
Name: TestClass
Public: true
Extends: BaseClass
Implements: Runnable, Comparable
Javadoc: A simple test class to demonstrate JavaParser capabilities...

Members (10):
  - Field: int MAX_SIZE
  - Field: String name
  - Field: int count
  - Constructor: TestClass()
  - Constructor: TestClass(String name)
  - Method: String getName()
  - Method: void setName(String name)
  - Method: void increment()
  - Method: int getCount()
  - Method: int getSize(List items)
  - Method: void run()
  - Method: int compareTo(TestClass other)

============================================================
✅ Test completed successfully!

📋 Summary:
  - Classes parsed: 1
  - Total members: 12

💾 Full output saved to: test_output.json
```

## JSON-Ausgabe-Format

Das JavaParser CLI gibt ein Array von "docsets" aus, ähnlich dem Format von JSDuck:

```json
[
  {
    "tagname": "class",
    "name": "TestClass",
    "type": "doc_comment",
    "comment": "Javadoc comment content...",
    "linenr": 10,
    "code": {
      "tagname": "class",
      "name": "TestClass",
      "public": true,
      "private": false,
      "extends": "BaseClass",
      "implements": ["Runnable", "Comparable"],
      "members": [
        {
          "tagname": "field",
          "name": "MAX_SIZE",
          "type": "int",
          "public": true,
          "static": true,
          "final": true,
          "comment": "...",
          "linenr": 15
        },
        {
          "tagname": "method",
          "name": "getName",
          "return_type": "String",
          "params": [],
          "public": true,
          "comment": "...",
          "linenr": 40
        }
      ]
    }
  }
]
```

## Integration in JSDuck

Das Format ist kompatibel mit JSDucks interner Struktur. Der nächste Schritt ist:

1. `lib/jsduck/java/parser.rb` implementieren (verwendet JavaParserCLI)
2. `lib/jsduck/java/associator.rb` überspringen (JavaParser macht das bereits)
3. `lib/jsduck/java/ast.rb` anpassen um JSON zu transformieren

## Performance

- Parsing von TestClass.java: ~1-2 Sekunden (inkl. JVM-Start)
- Für Batch-Processing mit JSDucks Cache-System akzeptabel
- Alternative: Persistent JVM-Prozess für längere Sessions (zukünftige Optimierung)

## Erkenntnisse

✅ **Funktioniert:**
- Vollständiges Parsen von Java-Klassen
- Javadoc-Extraktion
- Methoden, Felder, Constructors
- Modifikatoren (public, private, static, etc.)
- Vererbung (extends, implements)
- Exceptions (throws)

✅ **Vorteile:**
- Einfache Integration
- Robustes Parsing
- JSON als universelles Austauschformat

⚠️ **Trade-offs:**
- JVM-Start-Overhead (~1s)
- Externe Java-Dependency

## Nächste Schritte

1. ✅ PoC erfolgreich
2. → Integration in JSDuck starten (Issue #2)
3. → Performance-Optimierungen (persistent JVM, optional)
