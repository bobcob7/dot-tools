#!/usr/bin/env bash
# Main setup script for dot-tools
# Usage: ./setup.sh [module1] [module2] ...
# Run without arguments to install everything

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="$SCRIPT_DIR"

# Source helper functions
source "$SCRIPT_DIR/lib/helpers.sh"

# Available modules
MODULES=(zsh tmux vim utils claude)

# Print banner
print_banner() {
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║           dot-tools setup             ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""
    log_info "Detected OS: $(detect_os)"
    echo ""
}

# Load and run a module
run_module() {
    local module="$1"
    local module_file="$SCRIPT_DIR/modules/${module}.sh"

    if [ -f "$module_file" ]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        log_info "Running module: $module"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        source "$module_file"
        setup_${module}
    else
        log_error "Module not found: $module"
        return 1
    fi
}

# Main function
main() {
    print_banner

    local modules_to_run=()

    if [ $# -eq 0 ]; then
        # No arguments - run all modules
        modules_to_run=("${MODULES[@]}")
    else
        # Run specified modules
        modules_to_run=("$@")
    fi

    for module in "${modules_to_run[@]}"; do
        run_module "$module"
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "Setup complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    log_info "Notes:"
    echo "  - Restart your terminal or run 'exec zsh' to apply changes"
    echo "  - In tmux, press prefix + I to install plugins"
    echo "  - Prefix is Ctrl+a (changed from default Ctrl+b)"
    echo ""
}

main "$@"
