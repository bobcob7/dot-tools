#!/usr/bin/env bash
# Tmux setup module

setup_tmux() {
    log_info "Setting up Tmux..."

    # Install tmux if not present
    if ! command_exists tmux; then
        log_info "Installing tmux..."
        install_package tmux
    else
        log_success "Tmux is already installed"
    fi

    # Install Oh My Tmux (gpakosz/.tmux)
    if [ -f "$HOME/.tmux/.tmux.conf" ]; then
        log_success "Oh My Tmux is already installed"
    elif [ -d "$HOME/.tmux" ]; then
        # Directory exists but isn't a valid Oh My Tmux install
        log_info "Installing Oh My Tmux (backing up existing ~/.tmux)..."
        mv "$HOME/.tmux" "$HOME/.tmux.backup.$(date +%s)"
        git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
        ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
        log_success "Installed Oh My Tmux"
    else
        log_info "Installing Oh My Tmux..."
        git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
        ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
        log_success "Installed Oh My Tmux"
    fi

    # Create/update local config with customizations
    local tmux_local="$HOME/.tmux.conf.local"
    local marker="# DOT-TOOLS MANAGED"

    if [ ! -f "$tmux_local" ] || ! grep -qF "$marker" "$tmux_local"; then
        log_info "Setting up tmux local config..."
        # Copy the default local config if it exists
        if [ -f "$HOME/.tmux/.tmux.conf.local" ] && [ ! -f "$tmux_local" ]; then
            cp "$HOME/.tmux/.tmux.conf.local" "$tmux_local"
        fi

        # Append our customizations
        cat >> "$tmux_local" << 'EOF'

# DOT-TOOLS MANAGED - Custom additions below
# Use zsh as default shell
set -g default-shell /bin/zsh

# Increase history limit
set -g history-limit 50000

# Enable mouse support
set -g mouse on

# ============================================
# Dracula Theme (via Oh My Tmux variables)
# ============================================
# Override Oh My Tmux theme colors with Dracula palette
tmux_conf_theme_colour_1="none"       # transparent background
tmux_conf_theme_colour_2="#44475a"    # dracula current line
tmux_conf_theme_colour_3="#f8f8f2"    # dracula foreground
tmux_conf_theme_colour_4="#bd93f9"    # dracula purple
tmux_conf_theme_colour_5="#ff79c6"    # dracula pink
tmux_conf_theme_colour_6="#282a36"    # dracula background (for text bg)
tmux_conf_theme_colour_7="#f8f8f2"    # dracula foreground
tmux_conf_theme_colour_8="#282a36"    # dracula background
tmux_conf_theme_colour_9="#bd93f9"    # dracula purple
tmux_conf_theme_colour_10="#ff79c6"   # dracula pink
tmux_conf_theme_colour_11="#50fa7b"   # dracula green
tmux_conf_theme_colour_12="#6272a4"   # dracula comment
tmux_conf_theme_colour_13="#f8f8f2"   # dracula foreground
tmux_conf_theme_colour_14="#282a36"   # dracula background
tmux_conf_theme_colour_15="none"      # transparent
tmux_conf_theme_colour_16="#bd93f9"   # dracula purple
tmux_conf_theme_colour_17="#bd93f9"   # dracula purple

# Transparent status bar background
tmux_conf_theme_status_bg="none"
tmux_conf_theme_window_status_bg="none"

# Pane borders
tmux_conf_theme_pane_border="$tmux_conf_theme_colour_2"
tmux_conf_theme_pane_active_border="$tmux_conf_theme_colour_4"

# Enable 256 colors and true color
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
EOF
        log_success "Created tmux local config"
    else
        log_success "Tmux local config already configured"
    fi

    log_success "Tmux setup complete"
}
