.PHONY: help all build serve clean install copy-assets

# Configuration
DOCS_DIR := docs
BUILD_DIR := build
PORT := 8000
# Use gem executables directory or fall back to PATH
GEM_BIN := $(shell gem environment | grep "EXECUTABLE DIRECTORY" | cut -d: -f2 | tr -d ' ')
ASCIIDOCTOR := $(GEM_BIN)/asciidoctor-revealjs

# Find all .adoc files in docs/ directory (excluding index.adoc)
ADOC_FILES := $(filter-out $(DOCS_DIR)/index.adoc, $(wildcard $(DOCS_DIR)/*.adoc))
HTML_FILES := $(patsubst $(DOCS_DIR)/%.adoc,$(BUILD_DIR)/%.html,$(ADOC_FILES))

# Default target
.DEFAULT_GOAL := build

help:
	@echo "Available targets:"
	@echo "  make install    - Install required dependencies (asciidoctor-revealjs)"
	@echo "  make build      - Build all presentations from AsciiDoc to HTML"
	@echo "  make serve      - Start a local web server on port $(PORT)"
	@echo "  make clean      - Remove generated files"
	@echo "  make all        - Build and serve presentations"

# Install dependencies
install:
	@echo "Installing asciidoctor-revealjs..."
	@if ! command -v gem >/dev/null 2>&1; then \
		echo "Error: Ruby and gem are required. Please install Ruby first."; \
		exit 1; \
	fi
	@gem install asciidoctor-revealjs

# Build all presentations
build: install $(HTML_FILES) copy-assets
	@echo "Generating index.html..."
	@echo '<!DOCTYPE html>' > $(BUILD_DIR)/index.html
	@echo '<html lang="en"><head><meta charset="UTF-8">' >> $(BUILD_DIR)/index.html
	@echo '<meta name="viewport" content="width=device-width, initial-scale=1.0">' >> $(BUILD_DIR)/index.html
	@echo '<title>Julien'\''s Presentations</title><style>' >> $(BUILD_DIR)/index.html
	@echo 'body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen,Ubuntu,Cantarell,sans-serif;' >> $(BUILD_DIR)/index.html
	@echo 'max-width:800px;margin:50px auto;padding:20px;line-height:1.6;background:#1a1a1a;color:#e0e0e0;}' >> $(BUILD_DIR)/index.html
	@echo 'h1{color:#fff;border-bottom:2px solid #444;padding-bottom:10px;}' >> $(BUILD_DIR)/index.html
	@echo 'ul{list-style:none;padding:0;}li{margin:10px 0;}' >> $(BUILD_DIR)/index.html
	@echo 'a{color:#4a9eff;text-decoration:none;font-size:18px;}' >> $(BUILD_DIR)/index.html
	@echo 'a:hover{text-decoration:underline;color:#6bb3ff;}' >> $(BUILD_DIR)/index.html
	@echo '</style></head><body><h1>Julien'\''s Presentations</h1><ul>' >> $(BUILD_DIR)/index.html
	@for file in $(BUILD_DIR)/*.html; do \
		[ "$$(basename $$file)" = "index.html" ] && continue; \
		filename=$$(basename $$file); \
		title=$$(echo "$${filename%.html}" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $$i=toupper(substr($$i,1,1)) tolower(substr($$i,2));}1'); \
		echo "<li><a href=\"$$filename\">$$title</a></li>" >> $(BUILD_DIR)/index.html; \
	done
	@echo '</ul></body></html>' >> $(BUILD_DIR)/index.html
	@echo "Build complete! HTML files are in $(BUILD_DIR)/"

# Convert individual .adoc files to .html
$(BUILD_DIR)/%.html: $(DOCS_DIR)/%.adoc
	@mkdir -p $(BUILD_DIR)
	@echo "Building $@..."
	@$(ASCIIDOCTOR) \
		-a revealjsdir=https://cdn.jsdelivr.net/npm/reveal.js@4.5.0 \
		-a revealjs_theme=black \
		-a revealjs_transition=slide \
		-a revealjs_slideNumber=true \
		-a revealjs_history=true \
		-a customcss=css/headings.css \
		-a source-highlighter=highlight.js \
		-o $@ $<

# Copy static assets (CSS, fonts, images)
copy-assets:
	@mkdir -p $(BUILD_DIR)
	@echo "Copying static assets..."
	@cp -r $(DOCS_DIR)/css $(BUILD_DIR)/ 2>/dev/null || true
	@cp -r $(DOCS_DIR)/fonts $(BUILD_DIR)/ 2>/dev/null || true
	@cp -r $(DOCS_DIR)/images $(BUILD_DIR)/ 2>/dev/null || true
	@echo "Generating short URL redirects..."
	@for file in $(BUILD_DIR)/*.html; do \
		[ "$$(basename $$file)" = "index.html" ] && continue; \
		name=$${file%.html}; \
		mkdir -p $$name; \
		echo '<!DOCTYPE html><html><head><meta http-equiv="refresh" content="0; url=../'"$$(basename $$file)"'"><link rel="canonical" href="https://decks.ruaux.org/'"$$(basename $$file)"'"></head><body><p>Redirecting...</p></body></html>' > $$name/index.html; \
	done

# Start a local web server
serve:
	@echo "Starting web server on http://localhost:$(PORT)"
	@echo "Press Ctrl+C to stop the server"
	@if command -v python3 >/dev/null 2>&1; then \
		cd $(BUILD_DIR) && python3 -m http.server $(PORT); \
	elif command -v python >/dev/null 2>&1; then \
		cd $(BUILD_DIR) && python -m SimpleHTTPServer $(PORT); \
	else \
		echo "Error: Python is required to run the web server"; \
		exit 1; \
	fi

# Build and serve
all: build serve

# Clean generated files
clean:
	@echo "Cleaning build directory..."
	@rm -rf $(BUILD_DIR)

