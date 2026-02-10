#!/usr/bin/env bash
# Utilities setup module

setup_utils() {
    log_info "Setting up utilities..."

    # Ensure Python 3 is installed
    if ! command_exists python3; then
        log_info "Installing Python 3..."
        install_package python3
    else
        log_success "Python 3 is already installed"
    fi

    # Ensure pip is installed
    if ! command_exists pip3; then
        log_info "Installing pip..."
        install_package python3-pip
    else
        log_success "pip is already installed"
    fi

    # Ensure GitHub CLI (gh) is installed
    if ! command_exists gh; then
        log_info "Installing GitHub CLI..."
        local os=$(detect_os)
        case "$os" in
            macos)
                brew install gh
                ;;
            ubuntu)
                # Add GitHub CLI repository
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt-get update -qq
                sudo apt-get install -y gh
                ;;
            *)
                log_warn "Could not install gh automatically on this OS"
                ;;
        esac
        if command_exists gh; then
            log_success "GitHub CLI installed"
        fi
    else
        log_success "GitHub CLI is already installed"
    fi

    # Ensure ctags is installed (for code navigation in vim/editors)
    if ! command_exists ctags; then
        log_info "Installing ctags..."
        local os=$(detect_os)
        case "$os" in
            macos)
                brew install universal-ctags
                ;;
            ubuntu)
                sudo apt-get update -qq
                sudo apt-get install -y universal-ctags
                ;;
            *)
                log_warn "Could not install ctags automatically on this OS"
                ;;
        esac
        if command_exists ctags; then
            log_success "ctags installed"
        fi
    else
        log_success "ctags is already installed"
    fi

    # Install Python dependencies (only if not already installed)
    if ! python3 -c "import markdown" 2>/dev/null; then
        log_info "Installing Python dependencies..."
        # Try normal install first, then with --break-system-packages for PEP 668
        pip3 install --user markdown 2>/dev/null || \
        pip3 install --user --break-system-packages markdown 2>/dev/null || \
        pip install --user markdown 2>/dev/null || \
        pip install --user --break-system-packages markdown 2>/dev/null || \
        log_warn "Could not install markdown package automatically"

        if python3 -c "import markdown" 2>/dev/null; then
            log_success "Python dependencies installed"
        fi
    else
        log_success "Python dependencies already installed"
    fi

    # Create ~/.local/bin if it doesn't exist
    local local_bin="$HOME/.local/bin"
    mkdir -p "$local_bin"

    # Copy scripts from bin/ to ~/.local/bin
    local src_bin="$DOTFILES_DIR/bin"
    if [ -d "$src_bin" ]; then
        for script in "$src_bin"/*; do
            if [ -f "$script" ]; then
                local script_name=$(basename "$script")
                local dest_script="$local_bin/$script_name"
                if [ -f "$dest_script" ] && cmp -s "$script" "$dest_script"; then
                    log_success "$script_name already installed"
                else
                    cp "$script" "$dest_script"
                    chmod +x "$dest_script"
                    log_success "Installed $script_name"
                fi
            fi
        done
    fi

    # Add ~/.local/bin to PATH in ~/.zshrc.local
    local zshrc_local="$HOME/.zshrc.local"

    if ! grep -qF "LOCAL BIN PATH" "$zshrc_local" 2>/dev/null; then
        log_info "Adding ~/.local/bin to PATH..."
        cat >> "$zshrc_local" << 'EOF'

# ============================================
# LOCAL BIN PATH
# ============================================
if [[ -d "$HOME/.local/bin" && ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
EOF
        log_success "Added ~/.local/bin to PATH"
    else
        log_success "~/.local/bin already in PATH config"
    fi

    # Source playground functions in shell
    if ! grep -qF "PLAYGROUND FUNCTIONS" "$zshrc_local" 2>/dev/null; then
        log_info "Adding playground functions to shell..."
        cat >> "$zshrc_local" << EOF

# ============================================
# PLAYGROUND FUNCTIONS
# ============================================
if [[ -f "$DOTFILES_DIR/lib/playground.sh" ]]; then
    source "$DOTFILES_DIR/lib/playground.sh"
fi
EOF
        log_success "Added playground functions"
    else
        log_success "Playground functions already configured"
    fi

    log_success "Utilities setup complete"
}
