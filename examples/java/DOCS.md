# JavaDuck Example Documentation

## Viewing the Documentation

### Option 1: Full JSDuck UI with ExtJS (Recommended)

**ExtJS is now installed and ready to use!**

The complete JSDuck experience with advanced features:
- Full-text search
- Source code browser
- Advanced navigation
- Class hierarchies
- Interactive tree view
- Professional UI

**Quick Start:**
```bash
cd /Users/vid/Documents/GitHub/javaduck
./examples/java/generate-docs.sh
```

Then open http://localhost:8000 in your browser!

### Option 2: Simple HTML Viewer (Lightweight Alternative)

The `viewer.html` provides a lightweight, modern documentation browser that works without ExtJS.

**To view:**

1. Generate JSON documentation:
   ```bash
   cd /Users/vid/Documents/GitHub/javaduck
   bundle exec ruby bin/jsduck examples/java/src \
       --export=full \
       --output examples/java/docs-json \
       --processes=0
   ```

2. Start a local web server:
   ```bash
   cd examples/java
   python3 -m http.server 8000
   ```

3. Open in browser:
   ```
   http://localhost:8000/viewer.html
   ```

**Features:**
- Clean, modern UI
- Statistics dashboard
- Class browser with type badges
- Method listings with parameters and types
- Javadoc tags (@author, @version, @since, @see)
- Responsive design
- Zero dependencies

### Manual Generation (Advanced)

If you want to customize the generation process:

```bash
cd /Users/vid/Documents/GitHub/javaduck

bundle exec ruby bin/jsduck examples/java/src \
    --output examples/java/docs \
    --title "JavaDuck Example - Java API Documentation" \
    --template template \
    --exclude vendor \
    --processes=0
```

Then start a server and open in browser:
```bash
cd examples/java/docs
python3 -m http.server 8000
open http://localhost:8000
```

## What's Generated

### JSON Export (`docs-json/`)

Contains structured JSON for each class:
- Full class metadata
- All methods with signatures
- Parameters with types
- Return types
- Javadoc comments and tags
- Inheritance information

### Simple Viewer (`viewer.html`)

Standalone HTML file that:
- Loads JSON files via fetch API
- Renders clean, browsable documentation
- Works with any HTTP server
- No build step required
- Mobile-friendly

### Full HTML Docs (`docs/` - requires ExtJS)

Complete documentation website with:
- ExtJS 4-based UI
- Search functionality
- Source code browser
- Class trees
- Guides and examples support

## Current Status

✅ **Fully Working:**
- Java source parsing
- Javadoc tag extraction
- JSON export
- Simple HTML viewer
- **Full JSDuck UI with ExtJS 4.2.1 GPL**
- Full-text search
- Source code browser
- Class tree navigation
- All core JavaDuck features

## Quick Start Commands

### Full Documentation (Recommended)
```bash
cd /Users/vid/Documents/GitHub/javaduck
./examples/java/generate-docs.sh
# Then open http://localhost:8000
```

### Simple Viewer (JSON + viewer.html)
```bash
cd /Users/vid/Documents/GitHub/javaduck

# Generate JSON docs
bundle exec ruby bin/jsduck examples/java/src \
    --export=full \
    --output examples/java/docs-json \
    --processes=0

# View docs
cd examples/java
python3 -m http.server 8000
open http://localhost:8000/viewer.html
```

## ExtJS Setup (Already Done!)

ExtJS 4.2.1 GPL is already installed in `template/extjs/`. The setup included:

1. ✅ Downloaded ExtJS 4.2.1 GPL from Sencha CDN
2. ✅ Installed to `template/extjs/`
3. ✅ Created minimal CSS files (no SASS compilation needed)
4. ✅ Ready to use!

**License:** ExtJS 4.2.1 is available under GPL v3 license.

## Troubleshooting

**"Oh noes! ExtJS directory not found":**
- Make sure you're using `--template template` option
- Default is `template-min` which doesn't exist
- Use `./examples/java/generate-docs.sh` which handles this correctly

**Warnings about vendor/bundle files:**
- These are harmless warnings from gem dependencies
- Use `--exclude vendor` to suppress them
- The `generate-docs.sh` script filters them out

**CSS files missing:**
- Simplified CSS files are in `template/resources/css/`
- No SASS compilation needed!
- ExtJS provides most styling anyway

## Example Classes

The example project includes:
- **User** - User model with authentication
- **Person** - Base person class
- **UserService** - Service layer for user operations
- **StringUtils** - Utility methods for string manipulation
- **UserRole** - Enum for user roles
- **Authenticatable** - Interface for authentication
- **Various Exceptions** - Custom exception classes

All with full Javadoc documentation demonstrating JavaDuck's capabilities!
