#!/usr/bin/env bash

# Usage function
usage() {
  echo "Usage: $(basename "$0") <output_name> <target_folder>"
  echo ""
  echo "Creates a zip archive of a folder excluding common build/config directories."
  echo ""
  echo "Arguments:"
  echo "  output_name     Name for the output zip file (without .zip extension)"
  echo "  target_folder   Folder to zip (use . for current directory)"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") my-project ."
  echo "  # Creates: my-project.zip (from current directory)"
  echo ""
  echo "  $(basename "$0") backup ../my-app"
  echo "  # Creates: backup.zip (from ../my-app directory)"
  exit 1
}

# Check if both arguments are provided
if [ $# -lt 2 ]; then
  echo "Error: Missing required arguments"
  echo ""
  usage
fi

# Get the arguments
OUTPUT_NAME="$1"
TARGET_NAME="$2"

# Validate the output name
if [[ "$OUTPUT_NAME" == -* ]]; then
  echo "Error: Output name cannot start with a dash"
  echo ""
  usage
fi

# Validate the target folder exists
if [ ! -e "$TARGET_NAME" ]; then
  echo "Error: Target '$TARGET_NAME' does not exist"
  exit 1
fi

# Create the zip with default exclusions
echo "Creating ${OUTPUT_NAME}.zip from ${TARGET_NAME}..."
zip -r "${OUTPUT_NAME}.zip" "$TARGET_NAME" \
  -x '*node_modules*' \
  -x '*dist*' \
  -x '*.vscode*' \
  -x '*.astro*' \
  -x '*.git*'

if [ $? -eq 0 ]; then
  echo "✅ Successfully created ${OUTPUT_NAME}.zip"
else
  echo "❌ Failed to create zip file"
  exit 1
fi
