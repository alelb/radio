# Directory where your script is located
SCRIPT_DIR := $(shell pwd)

# Installation directory (must be in PATH)
INSTALL_DIR := /usr/local/bin

# Config directory and file
CONFIG_DIR := $(HOME)/.config
CONFIG_FILE := $(CONFIG_DIR)/favorite_radio_stations.csv
SOURCE_CONFIG := $(SCRIPT_DIR)/.config/favorite_radio_stations.csv

# Script name
SCRIPT := radio.sh

# Default target
.PHONY: all
all: install

# Install script and config
.PHONY: install
install:
	@echo "Coping radio script to $(INSTALL_DIR)..."
	@sudo ln -sf $(SCRIPT_DIR)/$(SCRIPT) $(INSTALL_DIR)/radio
	@chmod +x $(SCRIPT_DIR)/$(SCRIPT)
	@echo "✓ radio script copied"
	@echo "Coping config file to $(CONFIG_FILE)..."
	@mkdir -p $(CONFIG_DIR)
	@cp $(SOURCE_CONFIG) $(CONFIG_FILE)
	@echo "✓ config file copied"

# Remove script and config
.PHONY: uninstall
uninstall:
	@echo "Removing radio script..."
	@sudo rm -f $(INSTALL_DIR)/radio
	@echo "✓ radio script removed"
	@echo "Removing config file..."
	@rm -f $(CONFIG_FILE)
	@echo "✓ config file removed"

# Show status
.PHONY: status
status:
	@echo "Installation status:"
	@if [ -L $(INSTALL_DIR)/radio ]; then \
		echo "✓ radio -> $$(readlink $(INSTALL_DIR)/radio)"; \
	else \
		echo "✗ radio not found"; \
	fi
	@if [ -f $(CONFIG_FILE) ]; then \
		echo "✓ config -> $(CONFIG_FILE)"; \
	else \
		echo "✗ config not found"; \
	fi