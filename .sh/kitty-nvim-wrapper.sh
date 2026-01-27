#!/bin/bash
# Wrapper script to open nvim in kitty with correct working directory
# and show the last commit diff with option to edit commit message

TARGET_PATH="$1"

# If it's a file, get the directory
if [ -f "$TARGET_PATH" ]; then
    WORK_DIR=$(dirname "$TARGET_PATH")
else
    # It's a directory
    WORK_DIR="$TARGET_PATH"
fi

# Check if we're in a git repository
cd "$WORK_DIR" || exit 1

# Open nvim with DiffviewOpen command
if [ -f "$TARGET_PATH" ]; then
    exec kitty --detach --directory="$WORK_DIR" nvim -c "DiffviewOpen HEAD~1" "$TARGET_PATH"
else
    exec kitty --detach --directory="$WORK_DIR" nvim -c "DiffviewOpen HEAD~1" .
fi

