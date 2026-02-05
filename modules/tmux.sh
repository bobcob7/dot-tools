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

    # Copy the default local config if it doesn't exist
    if [ ! -f "$tmux_local" ]; then
        if [ -f "$HOME/.tmux/.tmux.conf.local" ]; then
            log_info "Creating tmux local config from template..."
            cp "$HOME/.tmux/.tmux.conf.local" "$tmux_local"
        else
            log_warn "Oh My Tmux template not found"
            return 0
        fi
    fi

    # Apply Dracula theme colors (modify in place - Oh My Tmux reads these before EOF)
    log_info "Applying Dracula theme colors..."
    sed -i \
        -e 's/^tmux_conf_theme_colour_1=.*/tmux_conf_theme_colour_1="default"    # transparent/' \
        -e 's/^tmux_conf_theme_colour_2=.*/tmux_conf_theme_colour_2="#44475a"    # dracula current line/' \
        -e 's/^tmux_conf_theme_colour_3=.*/tmux_conf_theme_colour_3="#f8f8f2"    # dracula foreground/' \
        -e 's/^tmux_conf_theme_colour_4=.*/tmux_conf_theme_colour_4="#bd93f9"    # dracula purple/' \
        -e 's/^tmux_conf_theme_colour_5=.*/tmux_conf_theme_colour_5="#ff79c6"    # dracula pink/' \
        -e 's/^tmux_conf_theme_colour_6=.*/tmux_conf_theme_colour_6="#282a36"    # dracula background/' \
        -e 's/^tmux_conf_theme_colour_7=.*/tmux_conf_theme_colour_7="#f8f8f2"    # dracula foreground/' \
        -e 's/^tmux_conf_theme_colour_8=.*/tmux_conf_theme_colour_8="#282a36"    # dracula background/' \
        -e 's/^tmux_conf_theme_colour_9=.*/tmux_conf_theme_colour_9="#bd93f9"    # dracula purple/' \
        -e 's/^tmux_conf_theme_colour_10=.*/tmux_conf_theme_colour_10="#ff79c6"  # dracula pink/' \
        -e 's/^tmux_conf_theme_colour_11=.*/tmux_conf_theme_colour_11="#50fa7b"  # dracula green/' \
        -e 's/^tmux_conf_theme_colour_12=.*/tmux_conf_theme_colour_12="#6272a4"  # dracula comment/' \
        -e 's/^tmux_conf_theme_colour_13=.*/tmux_conf_theme_colour_13="#f8f8f2"  # dracula foreground/' \
        -e 's/^tmux_conf_theme_colour_14=.*/tmux_conf_theme_colour_14="#282a36"  # dracula background/' \
        -e 's/^tmux_conf_theme_colour_15=.*/tmux_conf_theme_colour_15="default"  # transparent/' \
        -e 's/^tmux_conf_theme_colour_16=.*/tmux_conf_theme_colour_16="#ff5555"  # dracula red/' \
        -e 's/^tmux_conf_theme_colour_17=.*/tmux_conf_theme_colour_17="#f8f8f2"  # dracula foreground/' \
        "$tmux_local"
    log_success "Applied Dracula theme"

    # Add custom settings at end (only if not already present)
    if ! grep -qF "$marker" "$tmux_local"; then
        log_info "Adding custom tmux settings..."
        cat >> "$tmux_local" << 'EOF'

# DOT-TOOLS MANAGED - Custom additions below
# Use zsh as default shell
set -g default-shell /bin/zsh

# Increase history limit
set -g history-limit 50000

# Enable mouse support
set -g mouse on

# Enable 256 colors and true color
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
EOF
        log_success "Added custom tmux settings"
    else
        log_success "Custom tmux settings already present"
    fi

    log_success "Tmux setup complete"
}
