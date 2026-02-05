#!/usr/bin/env bash
# Helper functions for dotfile management

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu|debian)
                        echo "ubuntu"
                        ;;
                    *)
                        echo "linux"
                        ;;
                esac
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Install package based on OS
install_package() {
    local package="$1"
    local os=$(detect_os)

    case "$os" in
        macos)
            if ! command -v brew &> /dev/null; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install "$package"
            ;;
        ubuntu)
            sudo apt-get update -qq
            sudo apt-get install -y "$package"
            ;;
        *)
            log_error "Unsupported OS for package installation"
            return 1
            ;;
    esac
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Idempotent file append - only adds content if marker not present
append_if_missing() {
    local file="$1"
    local marker="$2"
    local content="$3"

    if [ ! -f "$file" ]; then
        echo "$content" > "$file"
        return 0
    fi

    if ! grep -qF "$marker" "$file"; then
        echo "$content" >> "$file"
        return 0
    fi

    return 1
}

# Backup file if it exists and no backup present
backup_file() {
    local file="$1"
    if [ -f "$file" ] && [ ! -f "${file}.backup" ]; then
        cp "$file" "${file}.backup"
        log_info "Backed up $file to ${file}.backup"
    fi
}

# Symlink with backup
safe_symlink() {
    local source="$1"
    local target="$2"

    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        backup_file "$target"
        rm -f "$target"
    fi

    # Create symlink if not already pointing to source
    if [ -L "$target" ]; then
        local current_target=$(readlink "$target")
        if [ "$current_target" = "$source" ]; then
            log_success "Symlink already exists: $target -> $source"
            return 0
        fi
        rm -f "$target"
    fi

    ln -s "$source" "$target"
    log_success "Created symlink: $target -> $source"
}

# Get the directory where the script is located
get_script_dir() {
    local source="${BASH_SOURCE[0]}"
    while [ -L "$source" ]; do
        local dir=$(cd -P "$(dirname "$source")" && pwd)
        source=$(readlink "$source")
        [[ $source != /* ]] && source="$dir/$source"
    done
    cd -P "$(dirname "$source")" && pwd
}
