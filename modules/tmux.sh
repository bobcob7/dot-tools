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
# Dracula Theme
# ============================================
# Dracula Color Palette
dracula_bg="#282a36"
dracula_fg="#f8f8f2"
dracula_cyan="#8be9fd"
dracula_green="#50fa7b"
dracula_orange="#ffb86c"
dracula_pink="#ff79c6"
dracula_purple="#bd93f9"
dracula_red="#ff5555"
dracula_yellow="#f1fa8c"

# Pane border colors
set -g pane-border-style "fg=${dracula_purple}"
set -g pane-active-border-style "fg=${dracula_pink}"

# Message style
set -g message-style "bg=${dracula_purple},fg=${dracula_bg}"

# Status bar (default bg for transparency)
set -g status-style "bg=default,fg=${dracula_fg}"
set -g status-left-length 50
set -g status-right-length 100

# Status left: session name
set -g status-left "#[bg=${dracula_purple},fg=${dracula_bg},bold] #S #[bg=default,fg=${dracula_purple}]"

# Status right: date and time
set -g status-right "#[fg=${dracula_cyan}]%Y-%m-%d #[fg=${dracula_pink}]%H:%M #[bg=${dracula_purple},fg=${dracula_bg},bold] #h "

# Window status
set -g window-status-format "#[fg=${dracula_fg},bg=default] #I:#W "
set -g window-status-current-format "#[bg=${dracula_pink},fg=${dracula_bg},bold] #I:#W #[bg=default,fg=${dracula_pink}]"
set -g window-status-separator ""

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
