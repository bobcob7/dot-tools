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

    # Create local config from template and apply customizations
    local tmux_local="$HOME/.tmux.conf.local"
    local template="$HOME/.tmux/.tmux.conf.local"

    if [[ ! -f "$template" ]]; then
        log_warn "Oh My Tmux template not found"
        return 0
    fi

    log_info "Creating tmux local config with Dracula theme..."

    # Start with template
    cp "$template" "$tmux_local"

    # Replace theme colors in place with Dracula theme
    # Use sed -i.bak for macOS compatibility, then remove backup
    sed -i.bak \
        -e 's/^tmux_conf_theme_colour_1=.*/tmux_conf_theme_colour_1="default"/' \
        -e 's/^tmux_conf_theme_colour_2=.*/tmux_conf_theme_colour_2="#44475a"/' \
        -e 's/^tmux_conf_theme_colour_3=.*/tmux_conf_theme_colour_3="#f8f8f2"/' \
        -e 's/^tmux_conf_theme_colour_4=.*/tmux_conf_theme_colour_4="#bd93f9"/' \
        -e 's/^tmux_conf_theme_colour_5=.*/tmux_conf_theme_colour_5="#ff79c6"/' \
        -e 's/^tmux_conf_theme_colour_6=.*/tmux_conf_theme_colour_6="#282a36"/' \
        -e 's/^tmux_conf_theme_colour_7=.*/tmux_conf_theme_colour_7="#f8f8f2"/' \
        -e 's/^tmux_conf_theme_colour_8=.*/tmux_conf_theme_colour_8="#282a36"/' \
        -e 's/^tmux_conf_theme_colour_9=.*/tmux_conf_theme_colour_9="#bd93f9"/' \
        -e 's/^tmux_conf_theme_colour_10=.*/tmux_conf_theme_colour_10="#ff79c6"/' \
        -e 's/^tmux_conf_theme_colour_11=.*/tmux_conf_theme_colour_11="#50fa7b"/' \
        -e 's/^tmux_conf_theme_colour_12=.*/tmux_conf_theme_colour_12="#6272a4"/' \
        -e 's/^tmux_conf_theme_colour_13=.*/tmux_conf_theme_colour_13="#f8f8f2"/' \
        -e 's/^tmux_conf_theme_colour_14=.*/tmux_conf_theme_colour_14="#282a36"/' \
        -e 's/^tmux_conf_theme_colour_15=.*/tmux_conf_theme_colour_15="default"/' \
        -e 's/^tmux_conf_theme_colour_16=.*/tmux_conf_theme_colour_16="#ff5555"/' \
        -e 's/^tmux_conf_theme_colour_17=.*/tmux_conf_theme_colour_17="#f8f8f2"/' \
        "$tmux_local"
    rm -f "${tmux_local}.bak"

    # Append custom settings (only if not already present)
    if ! grep -q "# DOT-TOOLS: Custom settings" "$tmux_local"; then
        cat >> "$tmux_local" << 'EOF'

# DOT-TOOLS: Custom settings
set -g default-shell /bin/zsh
set -g history-limit 50000
set -g mouse on
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
EOF
    fi

    log_success "Created tmux config with Dracula theme"

    # Reload tmux config if running inside tmux
    if [[ -n "$TMUX" ]]; then
        log_info "Reloading tmux configuration..."
        # Source local config first (sets env vars), then reapply theme
        # The full config source unsets vars after theme is applied, so we re-source local before _apply_theme
        tmux source-file ~/.tmux.conf 2>/dev/null \
            && tmux source-file ~/.tmux.conf.local 2>/dev/null \
            && tmux run 'cut -c3- "$TMUX_CONF" | sh -s _apply_theme' 2>/dev/null \
            && log_success "Tmux config reloaded" \
            || log_warn "Could not reload tmux config"
    else
        log_info "Run 'tmux source ~/.tmux.conf' or press prefix+R to reload"
    fi

    log_success "Tmux setup complete"
}
