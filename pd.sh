#!/bin/bash

# Project Directory Sync Script
# Synchronizes directory changes between frontend and backend terminals

# Configuration - customize these directory names for your project structure
DIR_FRONTEND="frontend"
DIR_BACKEND="backend"

PD_DATA_FILE="$HOME/.pd"

# Function to swap frontend/backend in a path and find the deepest existing directory
swap_project_dir() {
    local path="$1"
    local swapped_path=""

    # Swap DIR_FRONTEND/DIR_BACKEND in the path
    if [[ "$path" == *"/$DIR_FRONTEND"* ]]; then
        swapped_path="${path//\/$DIR_FRONTEND/\/$DIR_BACKEND}"
    elif [[ "$path" == *"/$DIR_BACKEND"* ]]; then
        swapped_path="${path//\/$DIR_BACKEND/\/$DIR_FRONTEND}"
    else
        echo "$path"
        return
    fi

    # Try the full swapped path first
    if [ -d "$swapped_path" ]; then
        echo "$swapped_path"
        return
    fi

    # Walk up the directory tree to find the deepest existing directory
    local current_path="$swapped_path"
    while [ "$current_path" != "/" ] && [ -n "$current_path" ]; do
        # Move up one directory
        current_path=$(dirname "$current_path")

        if [ -d "$current_path" ]; then
            echo "$current_path"
            return
        fi
    done

    # Fallback to the swapped path even if it doesn't exist
    echo "$swapped_path"
}

# If a directory argument is provided, save it and cd to it
if [ $# -eq 1 ]; then
    target_dir="$1"

    # Expand to absolute path
    if [[ "$target_dir" != /* ]]; then
        target_dir="$(cd "$target_dir" 2>/dev/null && pwd)" || {
            echo "Error: Directory '$1' does not exist" >&2
            return 1 2>/dev/null || exit 1
        }
    fi

    # Check if directory exists
    if [ ! -d "$target_dir" ]; then
        echo "Error: Directory '$target_dir' does not exist" >&2
        return 1 2>/dev/null || exit 1
    fi

    # Save the directory to the sync file
    echo "$target_dir" > "$PD_DATA_FILE"

    # Change to the directory
    cd "$target_dir" || return 1

    echo "Saved and changed to: $target_dir"

# If no argument, read from file and swap frontend/backend
elif [ $# -eq 0 ]; then
    if [ ! -f "$PD_DATA_FILE" ]; then
        echo "Error: No saved directory found. Use 'pd <directory>' first." >&2
        return 1 2>/dev/null || exit 1
    fi

    saved_dir=$(cat "$PD_DATA_FILE")
    target_dir=$(swap_project_dir "$saved_dir")

    # Check if the swapped directory exists
    if [ ! -d "$target_dir" ]; then
        echo "Error: Corresponding directory '$target_dir' does not exist" >&2
        echo "Saved directory was: $saved_dir" >&2
        return 1 2>/dev/null || exit 1
    fi

    # Change to the swapped directory
    cd "$target_dir" || return 1

    echo "Changed to: $target_dir"

else
    echo "Usage: pd [directory]" >&2
    echo "  pd <directory>  - Save and change to directory" >&2
    echo "  pd              - Change to corresponding frontend/backend directory" >&2
    return 1 2>/dev/null || exit 1
fi