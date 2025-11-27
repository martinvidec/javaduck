# Java Parser Evaluation für JavaDuck

## Datum
2025-11-27

## Ziel
Evaluierung verschiedener Optionen zum Parsen von Java-Code aus Ruby für das JavaDuck-Projekt.

## Recherchierte Optionen

### Option 1: JavaParser (Java Library via CLI/Bridge) ⭐ EMPFOHLEN

**Repository:** https://github.com/javaparser/javaparser

**Beschreibung:**
- Vollständiger Java 1-22 Parser mit AST-Unterstützung
- Aktiv gewartet (letzte Version 3.27.1)
- Umfangreiche Dokumentation und Community
- Schreibt AST in verschiedene Formate

**Vorteile:**
- ✅ Vollständige Java-Grammatik (bis Java 22)
- ✅ Sehr gut dokumentiert
- ✅ Aktiv maintained
- ✅ Robuste AST-Generierung
- ✅ Unterstützt moderne Java-Features
- ✅ Große Community

**Nachteile:**
- ❌ Externe Java-Dependency erforderlich
- ❌ IPC-Overhead (Ruby ↔ Java)
- ❌ Etwas komplexere Integration

**Integration-Strategie:**
1. JavaParser als JAR-Datei bundlen
2. Kleine Java-Wrapper-Anwendung schreiben, die JSON ausgibt
3. Ruby-Code ruft Java-Wrapper via `java -jar` auf
4. JSON-Output wird in Ruby geparst

**Technischer Ansatz:**
```ruby
# lib/jsduck/java/parser.rb
require 'json'
require 'open3'

module JsDuck
  module Java
    class Parser
      JAVAPARSER_JAR = File.join(__dir__, '../../../bin/javaparser-cli.jar')

      def initialize(input, options={})
        @input = input
      end

      def parse
        # Write Java source to temp file
        temp_file = Tempfile.new(['java_source', '.java'])
        temp_file.write(@input)
        temp_file.close

        # Call JavaParser CLI
        stdout, stderr, status = Open3.capture3(
          'java', '-jar', JAVAPARSER_JAR,
          '--output-format', 'json',
          temp_file.path
        )

        raise "JavaParser failed: #{stderr}" unless status.success?

        # Parse JSON output
        ast_json = JSON.parse(stdout)

        # Convert to JSDuck internal format
        convert_to_docsets(ast_json)
      ensure
        temp_file.unlink if temp_file
      end

      private

      def convert_to_docsets(ast)
        # Transform JavaParser AST to JSDuck docsets format
        # Similar to what Js::Associator does
      end
    end
  end
end
```

**Benötigte Komponenten:**
- JavaParser JAR (ca. 3-4 MB)
- Minimaler Java-Wrapper für CLI
- Ruby-Code für JSON-Parsing und Format-Konvertierung

### Option 2: Ruby-basierte Lösung (Parser Gem mit Java-Grammar)

**Repository:** https://github.com/whitequark/parser

**Beschreibung:**
- Ruby Parser Gem kann theoretisch mit Custom-Grammars erweitert werden
- Würde komplett in Ruby laufen

**Vorteile:**
- ✅ Pure Ruby (keine externe Dependencies)
- ✅ Kein IPC-Overhead
- ✅ Volle Kontrolle

**Nachteile:**
- ❌ Sehr aufwendig - komplette Java-Grammatik implementieren
- ❌ Schwer zu maintainen bei neuen Java-Versionen
- ❌ Fehleranfällig
- ❌ Monatelanges Projekt für vollständige Implementierung

**Status:** ⛔ NICHT EMPFOHLEN - Zu aufwendig

### Option 3: "javaparse" Ruby Gem

**RubyGems:** https://rubygems.org/gems/javaparse

**Beschreibung:**
- Existiert auf RubyGems (Version 0.1.5, von 2015)
- Sehr wenig Dokumentation verfügbar
- Letztes Update vor 9 Jahren

**Vorteile:**
- ✅ Ruby Gem (einfache Installation)
- ✅ Direkte Ruby-Integration

**Nachteile:**
- ❌ Sehr alt (2015)
- ❌ Nicht maintained
- ❌ Unbekannte Java-Version-Unterstützung
- ❌ Minimale Dokumentation
- ❌ Unklare Funktionalität

**Status:** ⚠️ RISIKO - Zu alt und unmaintained

### Option 4: "codemodels" Familie

**Repository:** https://github.com/ftomassetti/codemodels

**Beschreibung:**
- Federico Tomassetti's Framework für Code-Modellierung
- Verschiedene Gems für verschiedene Sprachen
- Basiert auf RGen

**Recherche-Ergebnis:**
- Kein spezifischer Java-Parser-Wrapper gefunden
- codemodels-javaparserwrapper existiert nicht (mehr?)
- Projekt scheint nicht mehr aktiv maintained

**Status:** ⛔ NICHT VERFÜGBAR

### Option 5: JRuby-basierte Lösung

**Repository:** https://github.com/jruby/jruby

**Beschreibung:**
- JRuby kann Java-Code direkt aufrufen
- JavaParser könnte direkt als Java-Library verwendet werden

**Vorteile:**
- ✅ Kein IPC-Overhead
- ✅ Direkte Java-Integration
- ✅ Zugriff auf vollständige JavaParser-API

**Nachteile:**
- ❌ Erfordert JRuby statt MRI Ruby
- ❌ Breaking Change für JSDuck-Nutzer
- ❌ Deployment-Komplexität erhöht sich

**Status:** ⚠️ MÖGLICH - Aber bricht Kompatibilität

## Vergleichsmatrix

| Kriterium | JavaParser CLI | Parser+Grammar | javaparse gem | JRuby |
|-----------|---------------|----------------|---------------|--------|
| Java-Support | ✅ Java 1-22 | ❌ Manuell | ⚠️ Unbekannt | ✅ Java 1-22 |
| Maintained | ✅ Aktiv | ⚠️ Aufwendig | ❌ 2015 | ✅ Aktiv |
| Performance | ⚠️ IPC-Overhead | ✅ Native Ruby | ✅ Native Ruby | ✅ Native |
| Setup | ⚠️ Java erforderlich | ✅ Gem install | ✅ Gem install | ❌ JRuby |
| Robustheit | ✅ Battle-tested | ❌ Selbst bauen | ⚠️ Unbekannt | ✅ Battle-tested |
| Wartbarkeit | ✅ Updates kostenlos | ❌ Selbst pflegen | ❌ Veraltet | ✅ Updates kostenlos |
| Komplexität | ⚠️ Mittel | ❌ Sehr hoch | ✅ Niedrig | ⚠️ Mittel-Hoch |

## Empfehlung

### 🏆 Option 1: JavaParser via CLI/Bridge

**Begründung:**
1. **Vollständigkeit:** Unterstützt alle Java-Versionen bis Java 22
2. **Wartbarkeit:** Aktiv maintained, Updates verfügbar
3. **Robustheit:** Battle-tested in vielen Produktions-Projekten
4. **Machbarkeit:** Proof of Concept in wenigen Tagen umsetzbar
5. **Zukunftssicher:** Neue Java-Features automatisch verfügbar

**Trade-offs akzeptiert:**
- Java Runtime als Dependency (akzeptabel für Dokumentations-Tool)
- IPC-Overhead (akzeptabel bei Batch-Processing mit Caching)

## Nächste Schritte

1. ✅ **Proof of Concept erstellen**
   - Minimaler Java-Wrapper für JavaParser
   - Ruby-Integration via JSON
   - Test mit einfacher Java-Klasse

2. **JAR bundlen**
   - JavaParser JAR herunterladen
   - In `bin/` Verzeichnis ablegen
   - Build-Script erstellen

3. **Integration implementieren**
   - `lib/jsduck/java/parser.rb` gemäß Skizze
   - Tempfile-Handling
   - JSON-zu-Docset Konvertierung

4. **Testing**
   - Unit-Tests mit verschiedenen Java-Konstrukten
   - Performance-Tests
   - Fehlerbehandlung

## Referenzen

- [JavaParser Homepage](https://javaparser.org/)
- [JavaParser GitHub](https://github.com/javaparser/javaparser)
- [JavaParser Tutorial - Baeldung](https://www.baeldung.com/javaparser)
- [Getting started with JavaParser](https://tomassetti.me/getting-started-with-javaparser-analyzing-java-code-programmatically/)
- [JavaParser Library Guide](https://www.javaguides.net/2024/05/guide-to-javaparser-library-in-java.html)

---

## ✅ Finale Entscheidung

**Datum:** 2025-11-27
**Gewählte Option:** JavaParser via CLI/Bridge (Option 1)
**Status:** ✅ Proof of Concept erfolgreich implementiert und getestet

###Proof of Concept Ergebnisse

**Implementiert in:** `poc/java-parser/`

**Komponenten:**
- ✅ `JavaParserCLI.java` - Java-Wrapper (370 Zeilen)
- ✅ `pom.xml` - Maven Build-Konfiguration
- ✅ `test_parser.rb` - Ruby-Integration (100 Zeilen)
- ✅ `TestClass.java` - Beispiel mit Javadoc
- ✅ `target/javaparser-cli.jar` - Fat JAR (1.6 MB)

**Test-Ergebnis:**
```
✅ Test completed successfully!

📋 Summary:
  - Classes parsed: 1
  - Total members: 12
  - JAR size: 1.6 MB
  - Parse time: ~1-2 seconds (inkl. JVM-Start)
```

**Erkenntnisse:**
1. ✅ Vollständiges Parsen von Java-Klassen funktioniert
2. ✅ Javadoc-Extraktion inklusive @tags (@author, @version, @return, @param)
3. ✅ Alle Member-Typen erkannt (Methods, Fields, Constructors)
4. ✅ Modifikatoren korrekt extrahiert (public, private, static, final, etc.)
5. ✅ Vererbung und Interfaces (extends, implements)
6. ✅ Exception-Handling (throws)
7. ✅ JSON-Output kompatibel mit JSDuck-Format

**Trade-offs akzeptiert:**
- ⚠️ JVM-Start-Overhead ~1s (akzeptabel mit Caching)
- ⚠️ Java Runtime als Dependency (für Dokumentations-Tool vertretbar)
- ⚠️ 1.6 MB JAR-File (klein genug für Bundling)

**Vorteile bestätigt:**
- ✅ Robustes, battle-tested Parsing
- ✅ Support für Java 1-22
- ✅ Keine manueller Grammar-Wartung
- ✅ Einfache Integration via JSON
- ✅ Zukunftssichere Updates

**Nächster Schritt:** Issue #2 - Integration in JSDuck starten
