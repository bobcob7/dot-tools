#!/usr/bin/env bash
# Zsh and Oh-My-Zsh setup module

# ============================================
# Oh-My-Zsh Plugins Configuration
# ============================================
# Add plugins here - they will be enabled automatically
# Built-in plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
OMZ_PLUGINS=(
    git
    per-directory-history
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# External plugins to clone (format: "repo_url plugin_name")
# These get cloned to ~/.oh-my-zsh/custom/plugins/
OMZ_EXTERNAL_PLUGINS=(
    "https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting"
)

# ============================================
# Helper Functions
# ============================================

# Enable a plugin in .zshrc
enable_omz_plugin() {
    local plugin="$1"
    # Check if plugin already in list (word boundary check)
    if grep -qE "^plugins=.*[[:space:](]${plugin}[[:space:])]" "$HOME/.zshrc" 2>/dev/null; then
        return 0  # Already enabled
    fi

    if grep -q "^plugins=" "$HOME/.zshrc"; then
        sed -i.bak "s/^plugins=(\(.*\))/plugins=(\1 $plugin)/" "$HOME/.zshrc"
        return 0
    fi
    return 1
}

# Install external plugin
install_external_plugin() {
    local repo_url="$1"
    local plugin_name="$2"
    local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/$plugin_name"

    if [ ! -d "$plugin_dir" ]; then
        log_info "Installing external plugin: $plugin_name..."
        git clone "$repo_url" "$plugin_dir"
        log_success "Installed $plugin_name"
    else
        log_success "Plugin $plugin_name already installed"
    fi
}

# Install Dracula theme for oh-my-zsh
install_dracula_theme() {
    local theme_dir="$HOME/.oh-my-zsh/custom/themes/dracula"
    local theme_link="$HOME/.oh-my-zsh/custom/themes/dracula.zsh-theme"

    if [ ! -d "$theme_dir" ]; then
        log_info "Installing Dracula theme for zsh..."
        git clone https://github.com/dracula/zsh.git "$theme_dir"
        ln -sf "$theme_dir/dracula.zsh-theme" "$theme_link"
        log_success "Installed Dracula zsh theme"
    else
        log_success "Dracula zsh theme already installed"
    fi

    # Set theme in .zshrc
    if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="dracula"/' "$HOME/.zshrc"
        log_success "Set Dracula as zsh theme"
    fi
}

# ============================================
# Main Setup
# ============================================

setup_zsh() {
    log_info "Setting up Zsh..."

    # Install zsh if not present
    if ! command_exists zsh; then
        log_info "Installing zsh..."
        install_package zsh
    else
        log_success "Zsh is already installed"
    fi

    # Install Oh-My-Zsh if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_success "Oh-My-Zsh is already installed"
    fi

    # Install external plugins
    for entry in "${OMZ_EXTERNAL_PLUGINS[@]}"; do
        if [ -n "$entry" ]; then
            read -r repo_url plugin_name <<< "$entry"
            install_external_plugin "$repo_url" "$plugin_name"
        fi
    done

    # Install Dracula theme
    install_dracula_theme

    # Enable all configured plugins
    log_info "Configuring oh-my-zsh plugins..."
    for plugin in "${OMZ_PLUGINS[@]}"; do
        if enable_omz_plugin "$plugin"; then
            log_success "Plugin enabled: $plugin"
        else
            log_warn "Could not enable plugin: $plugin"
        fi
    done

    # Copy custom zshrc to home directory (only if it doesn't exist)
    local src_zshrc="$DOTFILES_DIR/configs/zshrc.local"
    local dest_zshrc="$HOME/.zshrc.local"
    local marker="# DOT-TOOLS MANAGED"

    # Only copy if destination doesn't exist (preserves user modifications)
    if [ ! -f "$dest_zshrc" ]; then
        if [ -f "$src_zshrc" ]; then
            log_info "Installing custom zsh config to $dest_zshrc..."
            cp "$src_zshrc" "$dest_zshrc"
            log_success "Installed .zshrc.local"
        fi
    else
        log_success ".zshrc.local already exists"
    fi

    # Source it from .zshrc
    if ! grep -qF "$marker" "$HOME/.zshrc" 2>/dev/null; then
        log_info "Adding source line to .zshrc..."
        cat >> "$HOME/.zshrc" << 'EOF'

# DOT-TOOLS MANAGED - DO NOT EDIT BELOW THIS LINE
# Source dot-tools custom configurations
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
EOF
        log_success "Added custom zsh configurations to .zshrc"
    else
        log_success "Custom zsh configurations already in .zshrc"
    fi

    # Set zsh as default shell if not already
    local current_shell=$(basename "$SHELL")
    if [ "$current_shell" != "zsh" ]; then
        log_info "Setting zsh as default shell..."
        local zsh_path=$(which zsh)

        # Add to /etc/shells if not present (needed on some systems)
        if ! grep -qF "$zsh_path" /etc/shells 2>/dev/null; then
            echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
        fi

        chsh -s "$zsh_path"
        log_success "Set zsh as default shell (will take effect on next login)"
    else
        log_success "Zsh is already the default shell"
    fi
}
