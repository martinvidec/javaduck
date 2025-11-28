#!/bin/bash

# JavaDuck Documentation Build Script
# Generates HTML documentation from Java source files

set -e  # Exit on error

echo "========================================="
echo "  JavaDuck - Java Documentation Builder"
echo "========================================="
echo ""

# Configuration
SOURCE_DIR="src"
OUTPUT_DIR="docs"
PROJECT_ROOT="../.."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: Source directory '$SOURCE_DIR' not found${NC}"
    exit 1
fi

# Check if we're in the correct directory
if [ ! -f "README.md" ]; then
    echo -e "${YELLOW}Warning: README.md not found. Are you in the examples/java directory?${NC}"
fi

# Clean output directory if it exists
if [ -d "$OUTPUT_DIR" ]; then
    echo -e "${YELLOW}Cleaning existing output directory...${NC}"
    rm -rf "$OUTPUT_DIR"
fi

echo -e "${GREEN}Generating documentation...${NC}"
echo ""
echo "Source: $SOURCE_DIR"
echo "Output: $OUTPUT_DIR"
echo ""

# Run JSDuck from project root
cd "$PROJECT_ROOT"

# Check if jsduck binary exists
if [ ! -f "bin/jsduck" ]; then
    echo -e "${RED}Error: jsduck binary not found at bin/jsduck${NC}"
    echo "Please run from the project root or ensure jsduck is installed."
    exit 1
fi

# Generate documentation
ruby bin/jsduck \
    examples/java/$SOURCE_DIR \
    --output examples/java/$OUTPUT_DIR \
    --title "JavaDuck Example - Java API Documentation" \
    --footer "Generated with JavaDuck - Java support for JSDuck" \
    --verbose

# Return to examples/java directory
cd examples/java

# Check if generation was successful
if [ -d "$OUTPUT_DIR" ] && [ -f "$OUTPUT_DIR/index.html" ]; then
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}Documentation generated successfully!${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo "Output location: $OUTPUT_DIR/"
    echo ""

    # Offer to open the documentation
    if command -v open &> /dev/null; then
        # macOS
        read -p "Open documentation in browser? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open "$OUTPUT_DIR/index.html"
        fi
    elif command -v xdg-open &> /dev/null; then
        # Linux
        read -p "Open documentation in browser? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            xdg-open "$OUTPUT_DIR/index.html"
        fi
    else
        echo "To view the documentation, open: $OUTPUT_DIR/index.html"
    fi

    echo ""
    echo "Next steps:"
    echo "  - Browse the generated documentation"
    echo "  - Modify Java files and regenerate"
    echo "  - Add your own Java classes"
    echo ""
else
    echo -e "${RED}Error: Documentation generation failed${NC}"
    echo "Check the output above for errors."
    exit 1
fi
