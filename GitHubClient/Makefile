# To see how to drive this makefile use:
#
#   % make help

# The following values can be changed here, or passed on the command line.
SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR ?= $(CURRENT_MAKEFILE_DIR)/../Tuist/.build/checkouts/swift-openapi-generator
SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION ?= debug
OPENAPI_YAML_PATH ?= $(CURRENT_MAKEFILE_DIR)/Resources/openapi.yaml
OPENAPI_SEARCH_YAML_PATH ?= $(CURRENT_MAKEFILE_DIR)/Resources/search.yaml
OPENAPI_GENERATOR_CONFIG_PATH ?= $(CURRENT_MAKEFILE_DIR)/Resources/openapi-generator-config.yaml
OUTPUT_DIRECTORY ?= $(CURRENT_MAKEFILE_DIR)/Sources/Generated

# Derived values (don't change these).
CURRENT_MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_MAKEFILE_DIR := $(patsubst %/,%,$(dir $(CURRENT_MAKEFILE_PATH)))
SWIFT_OPENAPI_GENERATOR_BIN := $(SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR)/.build/$(SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION)/swift-openapi-generator

# If no target is specified, display help
.DEFAULT_GOAL := help

help:  # Display this help.
	@-+echo "Run make with one of the following targets:"
	@-+echo
	@-+grep -Eh "^[a-z-]+:.*#" $(CURRENT_MAKEFILE_PATH) | sed -E 's/^(.*:)(.*#+)(.*)/  \1 @@@ \3 /' | column -t -s "@@@"
	@-+echo
	@-+echo "The following options can be overriden on the command line:"
	@-+echo
	@-+echo "  SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR (e.g. .swift-openapi-generator)"
	@-+echo "  SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION (e.g. release)"
	@-+echo "  OPENAPI_YAML_PATH (e.g. openapi.yaml)"
	@-+echo "  OPENAPI_GENERATOR_CONFIG_PATH (e.g. openapi-generator-config.yaml)"
	@-+echo "  OUTPUT_DIRECTORY (e.g. Sources/Generated)"

generate: $(SWIFT_OPENAPI_GENERATOR_BIN) $(OPENAPI_YAML_PATH) $(OPENAPI_GENERATOR_CONFIG_PATH) $(OUTPUT_DIRECTORY)  # Generate the sources using swift-openapi-generator.
	$< generate \
		--config "$(OPENAPI_GENERATOR_CONFIG_PATH)" \
		--output-directory "$(OUTPUT_DIRECTORY)" \
		"$(OPENAPI_SEARCH_YAML_PATH)"
		
filter: $(SWIFT_OPENAPI_GENERATOR_BIN)
	$< filter \
		--config "$(OPENAPI_GENERATOR_CONFIG_PATH)" \
		"$(OPENAPI_YAML_PATH)" > "$(OPENAPI_SEARCH_YAML_PATH)"

build:  # Runs swift build.
	swift build

clean:  # Delete the output directory used for generated sources.
	@echo 'Delete entire directory: $(OUTPUT_DIRECTORY)? [y/N] ' && read ans && [ $${ans:-N} = y ] || (echo "Aborted"; exit 1)
	rm -rf "$(OUTPUT_DIRECTORY)"

clean-all: clean  # Clean everything, including the checkout of swift-openapi-generator.
	@echo 'Delete checkout of swift-openapi-generator $(SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR)? [y/N] ' && read ans && [ $${ans:-N} = y ] || (echo "Aborted"; exit 1)
	rm -rf "$(SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR)"


dump:  # Dump all derived values used by the Makefile.
	@echo "CURRENT_MAKEFILE_PATH = $(CURRENT_MAKEFILE_PATH)"
	@echo "CURRENT_MAKEFILE_DIR = $(CURRENT_MAKEFILE_DIR)"
	@echo "SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR = $(SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR)"
	@echo "SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION = $(SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION)"
	@echo "SWIFT_OPENAPI_GENERATOR_BIN = $(SWIFT_OPENAPI_GENERATOR_BIN)"
	@echo "OPENAPI_YAML_PATH = $(OPENAPI_YAML_PATH)"
	@echo "OPENAPI_GENERATOR_CONFIG_PATH = $(OPENAPI_GENERATOR_CONFIG_PATH)"
	@echo "OUTPUT_DIRECTORY = $(OUTPUT_DIRECTORY)"

$(SWIFT_OPENAPI_GENERATOR_BIN): $(SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR)
	swift \
		build \
		--package-path "$(SWIFT_OPENAPI_GENERATOR_CHECKOUT_DIR)" \
		--configuration "$(SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION)" \
		--product swift-openapi-generator

$(OUTPUT_DIRECTORY):
	mkdir -p "$@"

.PHONY: help generate build clean clean-all dump
