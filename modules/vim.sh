#!/usr/bin/env bash
# Vim setup module with vim-plug and Dracula theme

setup_vim() {
    log_info "Setting up Vim..."

    # Install vim if not present
    if ! command_exists vim; then
        log_info "Installing vim..."
        install_package vim
    else
        log_success "Vim is already installed"
    fi

    # Create vim directories
    mkdir -p ~/.vim/undodir
    mkdir -p ~/.vim/tags

    # Install vim-plug if not present
    local plug_file="$HOME/.vim/autoload/plug.vim"
    if [ ! -f "$plug_file" ]; then
        log_info "Installing vim-plug..."
        curl -fLo "$plug_file" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        log_success "Installed vim-plug"
    else
        log_success "vim-plug is already installed"
    fi

    # Install/update vimrc
    local src_vimrc="$DOTFILES_DIR/configs/vimrc"
    local dest_vimrc="$HOME/.vimrc"
    local marker="dot-tools Vim Configuration"

    if [ -f "$src_vimrc" ]; then
        if [ -f "$dest_vimrc" ] && grep -qF "$marker" "$dest_vimrc"; then
            # Check if content changed
            if ! cmp -s "$src_vimrc" "$dest_vimrc"; then
                log_info "Updating .vimrc..."
                cp "$src_vimrc" "$dest_vimrc"
                log_success "Updated .vimrc"
            else
                log_success ".vimrc is up to date"
            fi
        else
            # Backup existing vimrc if present
            if [ -f "$dest_vimrc" ]; then
                backup_file "$dest_vimrc"
            fi
            log_info "Installing .vimrc..."
            cp "$src_vimrc" "$dest_vimrc"
            log_success "Installed .vimrc"
        fi
    fi

    # Install plugins using vim-plug
    log_info "Installing Vim plugins (this may take a moment)..."
    vim -es -u "$dest_vimrc" -i NONE -c "PlugInstall" -c "qa" 2>/dev/null || \
    vim +PlugInstall +qall 2>/dev/null || \
    log_warn "Could not auto-install plugins. Run :PlugInstall in Vim manually."

    # Verify dracula was installed
    if [ -d "$HOME/.vim/plugged/dracula" ]; then
        log_success "Vim plugins installed (including Dracula theme)"
    else
        log_warn "Plugins may not be fully installed. Run :PlugInstall in Vim."
    fi

    log_success "Vim setup complete"
}
