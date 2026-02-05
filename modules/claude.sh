#!/usr/bin/env bash
# Claude Code setup module

setup_claude() {
    log_info "Setting up Claude Code..."

    # Install Claude Code CLI if not present
    install_claude_cli

    local src_dir="$DOTFILES_DIR/configs/claude"
    local dest_dir="$HOME/.claude"

    # Check if source config exists
    if [ ! -d "$src_dir" ]; then
        log_error "Claude config not found at $src_dir"
        return 1
    fi

    # Create ~/.claude if it doesn't exist
    if [ ! -d "$dest_dir" ]; then
        mkdir -p "$dest_dir"
        log_info "Created $dest_dir"
    fi

    # Sync each component
    sync_claude_file "CLAUDE.md"
    sync_claude_file "settings.json"
    sync_claude_dir "skills"
    sync_claude_dir "agents"
    sync_claude_dir "rules"
    sync_claude_dir "mcp"

    # Install MCP servers
    install_mcp_servers

    # Install plugins (official marketplace)
    install_claude_plugins

    log_success "Claude Code setup complete"
}

# Install Claude Code CLI
install_claude_cli() {
    if command_exists claude; then
        log_success "Claude Code CLI is already installed"
        return 0
    fi

    log_info "Installing Claude Code CLI..."

    local os=$(detect_os)
    case "$os" in
        macos)
            if command_exists brew; then
                brew install --cask claude-code
            else
                curl -fsSL https://claude.ai/install.sh | bash
            fi
            ;;
        ubuntu|linux)
            curl -fsSL https://claude.ai/install.sh | bash
            ;;
        *)
            log_warn "Unknown OS, attempting default installation..."
            curl -fsSL https://claude.ai/install.sh | bash
            ;;
    esac

    # Source profile to get claude in path
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc" 2>/dev/null || true
    fi
    if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc" 2>/dev/null || true
    fi

    if command_exists claude; then
        log_success "Claude Code CLI installed"
    else
        log_warn "Claude Code CLI installation may require terminal restart"
    fi
}

# Install Claude Code plugins
install_claude_plugins() {
    if ! command_exists claude; then
        log_warn "Claude CLI not found, skipping plugin installation"
        return 0
    fi

    log_info "Installing Claude Code plugins..."

    # Install LSP dependencies first
    install_lsp_dependencies

    # List of plugins to install from official marketplace
    local plugins=(
        "typescript-lsp"
        "gopls-lsp"
        "playwright"
        "linear"
    )

    for plugin in "${plugins[@]}"; do
        install_claude_plugin "$plugin"
    done
}

# Install or update a single Claude plugin from official marketplace
install_claude_plugin() {
    local plugin="$1"
    local plugin_name="${plugin%%@*}"  # Extract name before @

    # Check if plugin is already installed
    if claude plugin list 2>/dev/null | grep -q "^$plugin_name"; then
        log_info "Updating plugin: $plugin_name..."
        if claude plugin update "$plugin_name" 2>/dev/null; then
            log_success "Plugin $plugin_name up to date"
        else
            log_warn "Failed to update plugin: $plugin_name"
        fi
        return 0
    fi

    log_info "Installing plugin: $plugin..."
    if claude plugin install --scope user "$plugin" 2>/dev/null; then
        log_success "Installed plugin: $plugin_name"
    else
        log_warn "Failed to install plugin: $plugin (may need manual installation)"
    fi
}


# Install LSP server dependencies
install_lsp_dependencies() {
    log_info "Checking LSP dependencies..."

    # TypeScript LSP requires typescript-language-server
    if command_exists npm; then
        if ! command_exists typescript-language-server; then
            log_info "Installing typescript-language-server..."
            npm install -g typescript-language-server typescript 2>/dev/null && \
                log_success "Installed typescript-language-server" || \
                log_warn "Failed to install typescript-language-server"
        else
            log_success "typescript-language-server already installed"
        fi
    else
        log_warn "npm not found, skipping TypeScript LSP dependency"
    fi

    # Go LSP requires gopls
    if command_exists go; then
        if ! command_exists gopls; then
            log_info "Installing gopls..."
            go install golang.org/x/tools/gopls@latest 2>/dev/null && \
                log_success "Installed gopls" || \
                log_warn "Failed to install gopls"
        else
            log_success "gopls already installed"
        fi
    else
        log_warn "go not found, skipping Go LSP dependency"
    fi
}

# Install MCP servers from mcp/ directory
install_mcp_servers() {
    if ! command_exists claude; then
        log_warn "Claude CLI not found, skipping MCP server installation"
        return 0
    fi

    local mcp_dir="$DOTFILES_DIR/configs/claude/mcp"

    if [[ ! -d "$mcp_dir" ]]; then
        return 0
    fi

    log_info "Installing MCP servers..."

    for server_dir in "$mcp_dir"/*/; do
        if [[ -d "$server_dir" ]]; then
            local server_name=$(basename "$server_dir")
            local server_script="$HOME/.claude/mcp/$server_name/main.py"

            # Check if server is already registered
            if claude mcp list 2>/dev/null | grep -q "^$server_name"; then
                log_success "MCP server $server_name already registered"
            else
                log_info "Registering MCP server: $server_name..."
                if claude mcp add --transport stdio --scope user "$server_name" -- python3 "$server_script" 2>/dev/null; then
                    log_success "Registered MCP server: $server_name"
                else
                    log_warn "Failed to register MCP server: $server_name"
                fi
            fi
        fi
    done
}

# Sync a single file
sync_claude_file() {
    local file="$1"
    local src="$DOTFILES_DIR/configs/claude/$file"
    local dest="$HOME/.claude/$file"

    if [ ! -f "$src" ]; then
        return 0
    fi

    if [ -f "$dest" ]; then
        if ! cmp -s "$src" "$dest"; then
            backup_file "$dest"
            cp "$src" "$dest"
            log_success "Updated $file"
        else
            log_success "$file is up to date"
        fi
    else
        cp "$src" "$dest"
        log_success "Installed $file"
    fi
}

# Sync a directory (skills, agents, rules)
sync_claude_dir() {
    local dir="$1"
    local src_dir="$DOTFILES_DIR/configs/claude/$dir"
    local dest_dir="$HOME/.claude/$dir"

    if [ ! -d "$src_dir" ]; then
        return 0
    fi

    # Create destination directory
    mkdir -p "$dest_dir"

    # Count items synced
    local count=0

    # For skills, each skill is a directory with SKILL.md
    if [ "$dir" = "skills" ]; then
        for skill_dir in "$src_dir"/*/; do
            if [ -d "$skill_dir" ]; then
                local skill_name=$(basename "$skill_dir")
                local dest_skill_dir="$dest_dir/$skill_name"

                mkdir -p "$dest_skill_dir"

                # Copy all files in the skill directory
                for file in "$skill_dir"*; do
                    if [ -f "$file" ]; then
                        local filename=$(basename "$file")
                        cp "$file" "$dest_skill_dir/$filename"
                    fi
                done
                count=$((count + 1))
            fi
        done
        log_success "Synced $count skills"
    elif [ "$dir" = "mcp" ]; then
        # For MCP servers, recursively copy each server directory
        for server_dir in "$src_dir"/*/; do
            if [ -d "$server_dir" ]; then
                local server_name=$(basename "$server_dir")
                local dest_server_dir="$dest_dir/$server_name"

                # Remove old version and copy fresh
                rm -rf "$dest_server_dir"
                cp -r "$server_dir" "$dest_server_dir"
                count=$((count + 1))
            fi
        done
        log_success "Synced $count MCP servers"
    else
        # For agents and rules, just copy .md files
        for file in "$src_dir"/*.md; do
            if [ -f "$file" ]; then
                local filename=$(basename "$file")
                cp "$file" "$dest_dir/$filename"
                count=$((count + 1))
            fi
        done
        log_success "Synced $count ${dir}"
    fi
}
