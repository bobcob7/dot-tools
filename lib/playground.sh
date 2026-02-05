#!/usr/bin/env bash
# playground - Create and enter a temporary workspace
#
# Usage: playground [name]
#
# Creates /tmp/playground/<random-id> and cd's into it.
# Optionally provide a name to use instead of random ID.

playground() {
    local base_dir="/tmp/playground"
    local dir_name

    if [[ -n "$1" ]]; then
        dir_name="$1"
    else
        dir_name="$(date +%Y%m%d)-$(head -c 4 /dev/urandom | xxd -p)"
    fi

    local target_dir="${base_dir}/${dir_name}"

    if [[ -d "$target_dir" ]]; then
        echo "Directory already exists: $target_dir"
        cd "$target_dir" || return 1
    else
        mkdir -p "$target_dir" || {
            echo "Failed to create directory: $target_dir" >&2
            return 1
        }
        echo "Created: $target_dir"
        cd "$target_dir" || return 1
    fi
}

# List all playground directories
playground-list() {
    local base_dir="/tmp/playground"
    if [[ -d "$base_dir" ]]; then
        ls -lt "$base_dir"
    else
        echo "No playground directories exist"
    fi
}

# Clean up all playground directories
playground-clean() {
    local base_dir="/tmp/playground"
    if [[ -d "$base_dir" ]]; then
        echo "Removing all playground directories..."
        rm -rf "$base_dir"
        echo "Done"
    else
        echo "No playground directories to clean"
    fi
}
