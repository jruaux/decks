.PHONY: help build serve clean install

# Configuration
DOCS_DIR := docs
BUILD_DIR := build
PORT := 8000
ASCIIDOCTOR := asciidoctor-revealjs

# Find all .adoc files in docs/ directory (excluding index.adoc)
ADOC_FILES := $(filter-out $(DOCS_DIR)/index.adoc, $(wildcard $(DOCS_DIR)/*.adoc))
HTML_FILES := $(patsubst $(DOCS_DIR)/%.adoc,$(BUILD_DIR)/%.html,$(ADOC_FILES))

# Default target
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
build: install $(BUILD_DIR) $(HTML_FILES) copy-assets
	@echo "Build complete! HTML files are in $(BUILD_DIR)/"

# Create build directory
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Convert individual .adoc files to .html
$(BUILD_DIR)/%.html: $(DOCS_DIR)/%.adoc
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
copy-assets: $(BUILD_DIR)
	@echo "Copying static assets..."
	@cp -r $(DOCS_DIR)/css $(BUILD_DIR)/ 2>/dev/null || true
	@cp -r $(DOCS_DIR)/fonts $(BUILD_DIR)/ 2>/dev/null || true
	@cp -r $(DOCS_DIR)/images $(BUILD_DIR)/ 2>/dev/null || true

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

