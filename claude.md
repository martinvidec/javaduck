# JavaDuck - Plan zur Erweiterung von JSDuck für Java-Dokumentation

## Projektübersicht

**JSDuck** ist ein API-Dokumentationsgenerator für JavaScript (ursprünglich für Sencha/Ext JS), geschrieben in Ruby. Das Projekt wird nicht mehr aktiv gewartet, bietet aber eine solide Architektur für Dokumentationsgenerierung.

**Ziel:** Erweiterung des Tools um Java-Support (inkl. Javadoc-Kommentaren), sodass es sowohl JavaScript- als auch Java-Code dokumentieren kann.

## Architekturanalyse

### Aktuelle JSDuck-Architektur

Die Architektur von JSDuck ist modular aufgebaut:

```
┌─────────────────────────────────────────────────────────────┐
│                        App (app.rb)                         │
│              Haupteinstiegspunkt & Orchestrierung           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   BatchParser (batch_parser.rb)             │
│              Verarbeitet alle Eingabedateien parallel       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Parser (parser.rb)                     │
│           Delegiert an JS/SCSS-Parser basierend auf         │
│                      Dateiendung (.scss)                    │
└─────────────────────────────────────────────────────────────┘
                              │
            ┌─────────────────┴─────────────────┐
            ▼                                   ▼
┌──────────────────────┐           ┌──────────────────────┐
│   Js::Parser         │           │   Css::Parser        │
│  (js/parser.rb)      │           │  (css/parser.rb)     │
│                      │           │                      │
│  - RKelly für AST    │           │  - CSS/SCSS Parsing  │
│  - Js::Associator    │           │                      │
└──────────────────────┘           └──────────────────────┘
            │
            ▼
┌──────────────────────┐
│     Js::Ast          │
│   (js/ast.rb)        │
│                      │
│  - Js::Class         │
│  - Js::Method        │
│  - Js::Property      │
│  - Js::Event         │
└──────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────┐
│                 Doc::Parser (doc/parser.rb)                 │
│           Parst JSDoc-Kommentare und @tags                  │
└─────────────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────┐
│               TagRegistry (tag_registry.rb)                 │
│          Verwaltet alle @tag-Definitionen (lib/jsduck/tag/) │
│                                                              │
│  Beispiele: @param, @return, @class, @method, @property     │
└─────────────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────┐
│                   Merger (merger.rb)                        │
│         Kombiniert Doc-Kommentare mit Code-Erkennung        │
└─────────────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────┐
│                 Aggregator (aggregator.rb)                  │
│            Gruppiert Member in Klassen zusammen             │
└─────────────────────────────────────────────────────────────┘
```

### Zentrale Parsing-Komponenten

#### 1. **Parser (lib/jsduck/parser.rb)**
- **Funktion:** Hauptparser-Orchestrator
- **Relevanz:** Routing-Logik zwischen JS/SCSS - MUSS erweitert werden für .java
- **Code-Stelle:** Zeile 40-46 - `parse_js_or_scss` Methode
  ```ruby
  def parse_js_or_scss(contents, filename, options)
    if filename =~ /\.scss$/
      docs = Css::Parser.new(contents, options).parse
    else
      docs = Js::Parser.new(contents, options).parse
      docs = Js::Ast.new(docs).detect_all!
    end
  end
  ```

#### 2. **Js::Parser (lib/jsduck/js/parser.rb)**
- **Funktion:** JavaScript-spezifischer Parser
- **Parser-Library:** RKelly (Ruby-Gem für JS-Parsing)
- **Relevanz:** Template für Java::Parser
- **Wichtige Schritte:**
  1. Parst Source-Code zu AST
  2. Wandelt RKelly-AST in internes Format um (RKellyAdapter)
  3. Assoziiert Kommentare mit Code-Knoten (Js::Associator)

#### 3. **Js::Ast (lib/jsduck/js/ast.rb)**
- **Funktion:** Erkennt JavaScript-Strukturen (Klassen, Methoden, Properties, Events)
- **Relevanz:** Parallel-Implementierung für Java::Ast erforderlich
- **Detektoren:**
  - `Js::Class.detect` - Erkennt Klassendefinitionen
  - `Js::Method.detect` - Erkennt Methoden
  - `Js::Property.detect` - Erkennt Properties
  - `Js::Event.detect` - Erkennt Events

#### 4. **Doc::Parser (lib/jsduck/doc/parser.rb)**
- **Funktion:** Parst Dokumentationskommentare (JSDoc-Format)
- **Relevanz:** Weitgehend wiederverwendbar, aber Javadoc-spezifische Tags beachten
- **Format:** `/** @tag {Type} name description */`

#### 5. **TagRegistry (lib/jsduck/tag_registry.rb)**
- **Funktion:** Registry für alle @tag-Implementierungen
- **Relevanz:** Javadoc-spezifische Tags müssen hinzugefügt werden
- **Tags in lib/jsduck/tag/:**
  - Bestehende: @param, @return, @class, @method, @property, @private, etc.
  - Benötigt: @author, @version, @see, @throws, @deprecated (anpassen)

#### 6. **Aggregator (lib/jsduck/aggregator.rb)**
- **Funktion:** Gruppiert Dokumentation in Klassen
- **Relevanz:** Sollte sprachunabhängig funktionieren

#### 7. **Merger (lib/jsduck/merger.rb)**
- **Funktion:** Kombiniert Code-Erkennung mit Dokumentation
- **Relevanz:** Sollte sprachunabhängig funktionieren

## Unterschiede zwischen JSDoc und Javadoc

### Kommentar-Syntax
Beide verwenden ähnliche Syntax:
```javascript
/**
 * JSDoc Kommentar
 * @param {string} name - Parameter Beschreibung
 * @return {boolean} Beschreibung
 */
```

```java
/**
 * Javadoc Kommentar
 * @param name Parameter Beschreibung
 * @return Beschreibung
 */
```

### Tag-Unterschiede

| JSDoc-Tag       | Javadoc-Tag    | Unterschied                                |
|-----------------|----------------|--------------------------------------------|
| @param {Type}   | @param         | Javadoc hat keine Inline-Type-Syntax      |
| @return {Type}  | @return        | Javadoc hat keine Inline-Type-Syntax      |
| @class          | -              | Javadoc erkennt Klassen aus Code          |
| @method         | -              | Javadoc erkennt Methoden aus Code         |
| @property       | -              | Javadoc nutzt Fields                      |
| @throws         | @throws        | Beide vorhanden                           |
| @deprecated     | @deprecated    | Beide vorhanden                           |
| -               | @author        | Nur Javadoc                               |
| -               | @version       | Nur Javadoc                               |
| -               | @since         | Nur Javadoc                               |
| -               | @see           | Nur Javadoc                               |
| @fires          | -              | Nur JSDoc (Events)                        |

## Implementierungsplan

### Phase 1: Grundgerüst für Java-Parsing

#### Schritt 1.1: Java-Parser-Gem recherchieren und auswählen
**Datei:** Gemfile

**Aufgabe:**
- Ruby-Gem für Java-Parsing finden
- Optionen evaluieren:
  - `java_parser` - Wenn verfügbar
  - `parser` gem mit Java-Grammar
  - Alternative: JVM über `java` command nutzen (Eclipse JDT, JavaParser)

**Empfehlung:**
- Recherche nach Ruby-Gems für Java-AST-Parsing
- Notfalls: Java-Tool als externe Dependency nutzen (z.B. JavaParser CLI)

#### Schritt 1.2: Java-Parser Klasse erstellen
**Datei:** `lib/jsduck/java/parser.rb` (NEU)

**Aufgabe:**
```ruby
require 'jsduck/java/associator'
# require gem for Java parsing

module JsDuck
  module Java
    class Parser
      def initialize(input, options={})
        @input = input
      end

      # Parses Java source code with chosen parser
      # Returns array of docsets similar to Js::Parser
      def parse
        # 1. Parse Java to AST
        # 2. Associate comments with code nodes
        # 3. Return in standardized format
      end
    end
  end
end
```

**Vorbild:** `lib/jsduck/js/parser.rb`

#### Schritt 1.3: Java-Associator erstellen
**Datei:** `lib/jsduck/java/associator.rb` (NEU)

**Aufgabe:**
- Kommentare mit Java-Code-Knoten assoziieren
- Javadoc-Kommentare extrahieren (/** ... */)
- Struktur ähnlich wie `lib/jsduck/js/associator.rb`

#### Schritt 1.4: Parser Routing erweitern
**Datei:** `lib/jsduck/parser.rb`

**Änderung:**
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

**Alternative:** Methode umbenennen in `parse_by_extension` für Klarheit

### Phase 2: Java-AST-Erkennung implementieren

#### Schritt 2.1: Java::Ast Hauptklasse
**Datei:** `lib/jsduck/java/ast.rb` (NEU)

**Aufgabe:**
```ruby
require "jsduck/java/class"
require "jsduck/java/method"
require "jsduck/java/field"
require "jsduck/java/interface"
require "jsduck/java/enum"

module JsDuck
  module Java
    class Ast
      def initialize(docs = [])
        @docs = docs
      end

      def detect_all!
        doc_comments = @docs.find_all {|d| d[:type] == :doc_comment }

        doc_comments.each do |docset|
          code = docset[:code]
          docset[:code] = detect(code) unless code && code[:tagname]
        end

        @docs.find_all {|d| d[:type] == :doc_comment || d[:code] && d[:code][:tagname] }
      end

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
          Java::Field.make()
        end
      end
    end
  end
end
```

**Vorbild:** `lib/jsduck/js/ast.rb`

#### Schritt 2.2: Java::Class Detektor
**Datei:** `lib/jsduck/java/class.rb` (NEU)

**Aufgabe:**
- Klassendefinitionen erkennen
- Vererbung extrahieren (`extends`)
- Interfaces extrahieren (`implements`)
- Modifikatoren extrahieren (public, abstract, final)
- Member extrahieren (Methoden, Fields)

**Java-Struktur:**
```java
public class MyClass extends BaseClass implements Interface1, Interface2 {
    // fields
    // methods
    // constructors
}
```

**Vorbild:** `lib/jsduck/js/class.rb`

#### Schritt 2.3: Java::Interface Detektor
**Datei:** `lib/jsduck/java/interface.rb` (NEU)

**Aufgabe:**
- Interface-Definitionen erkennen
- Als `:interface` tagname markieren
- Methoden-Signaturen extrahieren

#### Schritt 2.4: Java::Enum Detektor
**Datei:** `lib/jsduck/java/enum.rb` (NEU)

**Aufgabe:**
- Enum-Definitionen erkennen
- Als `:enum` tagname markieren
- Enum-Konstanten extrahieren

#### Schritt 2.5: Java::Method Detektor
**Datei:** `lib/jsduck/java/method.rb` (NEU)

**Aufgabe:**
- Methodendefinitionen erkennen
- Parameter extrahieren (Name + Typ)
- Return-Type extrahieren
- Modifikatoren extrahieren (public, private, static, final)
- Exceptions extrahieren (throws)
- Constructors erkennen

**Vorbild:** `lib/jsduck/js/method.rb`

#### Schritt 2.6: Java::Field Detektor
**Datei:** `lib/jsduck/java/field.rb` (NEU)

**Aufgabe:**
- Field-Deklarationen erkennen
- Typ extrahieren
- Initialwert extrahieren (falls vorhanden)
- Modifikatoren extrahieren (public, private, static, final)

**Äquivalent zu:** `lib/jsduck/js/property.rb`

#### Schritt 2.7: Java::Node Helper
**Datei:** `lib/jsduck/java/node.rb` (NEU)

**Aufgabe:**
- Wrapper um AST-Knoten für einheitliche API
- Helper-Methoden für Typ-Checks

**Vorbild:** `lib/jsduck/js/node.rb`

### Phase 3: Javadoc-Tag-Unterstützung

#### Schritt 3.1: Doc::Parser Anpassungen prüfen
**Datei:** `lib/jsduck/doc/parser.rb`

**Analyse:**
- Prüfen, ob bestehender Parser Javadoc-Syntax unterstützt
- Javadoc verwendet keine {Type}-Syntax bei @param/@return
- Bei Bedarf Type-Parsing conditional machen

**Mögliche Änderung:**
```ruby
# In StandardTagParser
def parse_type
  if look(/\{/)
    # JSDoc-style: @param {Type} name
    parse_jsdoc_type
  else
    # Javadoc-style: @param name description
    # Type kommt aus Code-Erkennung
    nil
  end
end
```

#### Schritt 3.2: Javadoc-spezifische Tags hinzufügen

**@author Tag**
**Datei:** `lib/jsduck/tag/author.rb` (VORHANDEN - prüfen)

**@version Tag**
**Datei:** `lib/jsduck/tag/version.rb` (NEU)
```ruby
require "jsduck/tag/tag"

module JsDuck::Tag
  class Version < Tag
    def initialize
      @pattern = "version"
      @tagname = :version
    end

    def parse_doc(p, pos)
      {
        :tagname => :version,
        :version => p.input.scan(/.+/).strip
      }
    end

    def process_doc(h, tags, pos)
      h[:version] = tags.first[:version] if tags.first
    end

    def to_html(cls)
      "<p><strong>Version:</strong> #{cls[:version]}</p>" if cls[:version]
    end
  end
end
```

**@see Tag**
**Datei:** `lib/jsduck/tag/see.rb` (NEU)
```ruby
require "jsduck/tag/tag"

module JsDuck::Tag
  class See < Tag
    def initialize
      @pattern = "see"
      @tagname = :see
      @repeatable = true
    end

    def parse_doc(p, pos)
      {
        :tagname => :see,
        :reference => p.input.scan(/.+/).strip
      }
    end

    def process_doc(h, tags, pos)
      h[:see] = tags.map {|t| t[:reference] }
    end

    def to_html(cls)
      if cls[:see] && cls[:see].length > 0
        refs = cls[:see].map {|ref| "<li>#{ref}</li>" }.join
        "<p><strong>See also:</strong></p><ul>#{refs}</ul>"
      end
    end
  end
end
```

**@since Tag**
**Datei:** `lib/jsduck/tag/since.rb` (VORHANDEN - prüfen für Javadoc-Kompatibilität)

**@throws Tag (Javadoc-Stil)**
**Datei:** `lib/jsduck/tag/throws.rb` (VORHANDEN)
- Prüfen ob bereits vorhanden
- Falls nicht, analog zu @param implementieren

#### Schritt 3.3: TagRegistry für Java-Tags konfigurieren
**Datei:** TagLoader sollte automatisch neue Tags laden

**Sicherstellen:**
- Alle neuen Tag-Dateien werden erkannt
- Tags in lib/jsduck/tag/ werden automatisch geladen

### Phase 4: Type-System Anpassungen

#### Schritt 4.1: Java-Types in BaseType registrieren
**Datei:** `lib/jsduck/base_type.rb`

**Änderung:**
- Java primitive types: int, long, double, float, boolean, char, byte, short
- Java Objekt-Types: String, Integer, Object, List, Map, etc.

#### Schritt 4.2: Type-Linking für Java-Klassen
**Datei:** Eventuell in Format-Klassen

**Aufgabe:**
- Java-Package-Namen korrekt verlinken
- z.B. `java.util.List` → Link zur List-Dokumentation

### Phase 5: Integration & Testing

#### Schritt 5.1: Input-File-Erkennung
**Datei:** `lib/jsduck/options/input_files.rb`

**Aufgabe:**
- `.java` Dateien in Input-File-Sammlung einbeziehen
- File-Glob-Patterns erweitern

#### Schritt 5.2: Template-Anpassungen
**Dateien:** `template/**/*`

**Aufgabe:**
- UI-Labels für Java-spezifische Konzepte
- Interface/Enum Icons
- Class-Browser für Java-Packages

#### Schritt 5.3: Test-Suite erweitern
**Verzeichnis:** `spec/`

**Aufgabe:**
- Unit-Tests für Java::Parser
- Unit-Tests für Java::Ast, Java::Class, Java::Method, etc.
- Integration-Tests mit Sample-Java-Dateien
- Regression-Tests für JavaScript-Funktionalität

#### Schritt 5.4: Beispiel-Java-Projekt
**Verzeichnis:** `examples/java/` (NEU)

**Aufgabe:**
- Minimal-Beispiel mit Java-Klassen
- Javadoc-Kommentare
- README mit Anweisungen
- Script zum Generieren der Docs

### Phase 6: Dokumentation & Polishing

#### Schritt 6.1: README aktualisieren
**Datei:** `README.md`

**Änderungen:**
- JavaDuck in Titel
- Java-Support dokumentieren
- Beispiel-Kommandos für Java
- Java-spezifische Tags auflisten

#### Schritt 6.2: Wiki/Dokumentation
**Aufgabe:**
- Wiki-Seite für Java-Support
- Migration-Guide von JSDuck
- Tag-Referenz für Javadoc

#### Schritt 6.3: CLI-Optionen
**Datei:** `lib/jsduck/options/parser.rb`

**Aufgabe:**
- Flag für Java-Mode (falls nötig)
- Java-spezifische Optionen
- Package-Exclude-Patterns

## Technische Entscheidungen

### Java-Parser-Wahl

**Option 1: Ruby Java Parser Gem**
- ✅ Native Ruby-Integration
- ❌ Möglicherweise nicht vollständig/maintained

**Option 2: JavaParser (über CLI/Bridge)**
- ✅ Vollständiger, getesteter Java-Parser
- ✅ Aktiv maintained
- ❌ Externe Dependency (Java erforderlich)
- ❌ Performance-Overhead (IPC)

**Option 3: Eigener minimaler Parser**
- ✅ Volle Kontrolle
- ❌ Sehr aufwendig
- ❌ Fehleranfällig

**Empfehlung:** Option 2 (JavaParser) für Robustheit

### Architektur-Strategie

**Modular statt Fork:**
- Neue Module unter `lib/jsduck/java/`
- Minimale Änderungen an Kern-Dateien
- Ermöglicht parallele JS/Java-Unterstützung

**Shared Components:**
- Doc::Parser (mit bedingten Anpassungen)
- TagRegistry
- Aggregator
- Merger
- Web-Output-Layer

## Abhängigkeiten & Voraussetzungen

### Ruby-Gems
```ruby
# Gemfile
gem 'jsduck' # bestehende Dependencies
gem 'java_parser' # TBD - zu recherchieren
# ODER
# External: JavaParser CLI tool
```

### Externe Tools (Optional)
- JavaParser (falls nicht Ruby-Gem)
- Java Runtime (für JavaParser)

## Risiken & Herausforderungen

1. **Java-Parser-Verfügbarkeit**
   - Risiko: Kein geeigneter Ruby-Parser
   - Mitigation: JavaParser über Bridge nutzen

2. **Performance**
   - Risiko: Externe Java-Parser-Calls langsam
   - Mitigation: Caching-Mechanismus (bereits in JSDuck vorhanden)

3. **Type-System-Komplexität**
   - Risiko: Java-Generics sind komplexer als JS-Types
   - Mitigation: Schrittweise Unterstützung, zunächst Simple-Types

4. **Backward-Compatibility**
   - Risiko: Breaking Changes für JS-Nutzer
   - Mitigation: Modulare Architektur, keine Kern-Changes

5. **Maintenance-Burden**
   - Risiko: JSDuck wird nicht mehr maintained
   - Mitigation: Fork als JavaDuck mit eigener Roadmap

## Zeitschätzung (Grob)

- **Phase 1:** 2-3 Tage (Grundgerüst, Parser-Integration)
- **Phase 2:** 3-5 Tage (AST-Erkennung)
- **Phase 3:** 2-3 Tage (Javadoc-Tags)
- **Phase 4:** 1-2 Tage (Type-System)
- **Phase 5:** 3-4 Tage (Integration, Tests)
- **Phase 6:** 1-2 Tage (Dokumentation)

**Gesamt:** 12-19 Tage (je nach Java-Parser-Verfügbarkeit)

## Nächste Schritte

1. **Java-Parser recherchieren** - Ruby-Gems und Alternativen evaluieren
2. **Proof of Concept** - Minimaler Java::Parser für eine einfache Java-Klasse
3. **Entscheidung** - Parser-Library festlegen
4. **Implementierung** - Schrittweise nach Plan vorgehen

## Referenzen

- **JSDuck Wiki:** https://github.com/senchalabs/jsduck/wiki
- **Javadoc-Tags:** https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javadoc.html
- **JSDoc-Tags:** https://jsdoc.app/
- **JavaParser:** https://github.com/javaparser/javaparser (Java-Library für Parsing)

---

## Kritische Code-Stellen (Quick Reference)

| Datei | Zeilen | Änderung benötigt |
|-------|--------|-------------------|
| `lib/jsduck/parser.rb` | 40-46 | ✅ Java-Routing hinzufügen |
| `lib/jsduck/batch_parser.rb` | 25 | ✅ .java files unterstützen |
| `lib/jsduck/options/input_files.rb` | - | ✅ .java glob patterns |
| `lib/jsduck/tag_registry.rb` | - | ℹ️ Auto-loading sollte funktionieren |
| `lib/jsduck/doc/parser.rb` | - | ⚠️ Type-Parsing conditional machen |
| `lib/jsduck/base_type.rb` | - | ✅ Java-Types hinzufügen |

**Legende:**
- ✅ = Änderung erforderlich
- ℹ️ = Prüfen, möglicherweise keine Änderung nötig
- ⚠️ = Kritische Änderung, sorgfältig testen
