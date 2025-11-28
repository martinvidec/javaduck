#!/bin/bash

# JavaDuck Documentation Generator
# Generiert vollständige HTML-Dokumentation für das Java-Beispiel-Projekt

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "🦆 JavaDuck Documentation Generator"
echo "===================================="
echo ""

# Cleanup old docs
if [ -d "$SCRIPT_DIR/docs" ]; then
    echo "📁 Cleaning old documentation..."
    rm -rf "$SCRIPT_DIR/docs"
fi

# Generate documentation
echo "📝 Generating HTML documentation..."
cd "$PROJECT_ROOT"

bundle exec ruby bin/jsduck "$SCRIPT_DIR/src" \
    --output "$SCRIPT_DIR/docs" \
    --title "JavaDuck Example - Java API Documentation" \
    --template template \
    --exclude vendor \
    --processes=0 \
    2>&1 | grep -v "vendor/bundle" | grep -v "template/app" || true

echo ""
echo "✅ Documentation generated successfully!"
echo ""
echo "📂 Output: $SCRIPT_DIR/docs/"
echo ""
echo "To view the documentation:"
echo "  cd $SCRIPT_DIR/docs"
echo "  python3 -m http.server 8000"
echo "  open http://localhost:8000"
echo ""
