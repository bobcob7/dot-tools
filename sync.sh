#!/usr/bin/env bash
# Diff and import tool for dot-tools
# Compares installed config files against the repo and imports changes back.
#
# Usage:
#   ./sync.sh diff              Show what differs between repo and installed
#   ./sync.sh diff --verbose    Also show identical files
#   ./sync.sh import            Copy changed/new files from system back to repo
#   ./sync.sh import --dry-run  Show what would be imported without doing it

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="$SCRIPT_DIR"

source "$SCRIPT_DIR/lib/helpers.sh"

# ============================================
# File mappings (repo_path : system_path : type)
# type = file | dir-all | dir-md | dir-skill | dir-recurse
# ============================================
FILE_MAPS=(
    "configs/claude/CLAUDE.md:$HOME/.claude/CLAUDE.md:file"
    "configs/claude/settings.json:$HOME/.claude/settings.json:file"
    "configs/vimrc:$HOME/.vimrc:file"
    "configs/zshrc.local:$HOME/.zshrc.local:file"
)

DIR_MAPS=(
    "configs/claude/skills:$HOME/.claude/skills:dir-skill"
    "configs/claude/agents:$HOME/.claude/agents:dir-md"
    "configs/claude/rules:$HOME/.claude/rules:dir-md"
    "configs/claude/mcp:$HOME/.claude/mcp:dir-recurse"
    "bin:$HOME/.local/bin:dir-all"
)

VERBOSE=false
DRY_RUN=false
HAS_DIFF=false

# ============================================
# Helpers
# ============================================

should_skip() {
    local file="$1"
    local basename
    basename=$(basename "$file")
    [[ "$basename" == ".context.md" ]] && return 0
    [[ "$basename" == ".git" ]] && return 0
    [[ "$basename" == ".gitignore" ]] && return 0
    return 1
}

show_diff() {
    local repo_file="$1"
    local sys_file="$2"
    if command_exists colordiff; then
        colordiff -u "$repo_file" "$sys_file" || true
    else
        diff -u "$repo_file" "$sys_file" || true
    fi
}

relative_repo_path() {
    local full_path="$1"
    echo "${full_path#"$DOTFILES_DIR"/}"
}

print_status() {
    local status="$1"
    local path="$2"
    case "$status" in
        identical)
            if [[ "$VERBOSE" == true ]]; then
                log_success "identical  $path"
            fi
            ;;
        modified)
            log_warn "modified   $path"
            HAS_DIFF=true
            ;;
        new)
            log_info "new        $path  (system only)"
            HAS_DIFF=true
            ;;
        missing)
            echo -e "${RED}[MISS]${NC} missing    $path  (repo only)"
            HAS_DIFF=true
            ;;
    esac
}

# ============================================
# Diff logic
# ============================================

diff_file() {
    local repo_file="$DOTFILES_DIR/$1"
    local sys_file="$2"
    local rel_path="$1"
    if [[ ! -f "$sys_file" ]] && [[ ! -f "$repo_file" ]]; then
        return
    fi
    if [[ ! -f "$sys_file" ]]; then
        print_status "missing" "$rel_path"
        return
    fi
    if [[ ! -f "$repo_file" ]]; then
        print_status "new" "$rel_path"
        return
    fi
    if cmp -s "$repo_file" "$sys_file"; then
        print_status "identical" "$rel_path"
    else
        print_status "modified" "$rel_path"
        show_diff "$repo_file" "$sys_file"
    fi
}

diff_dir_files() {
    local repo_dir="$DOTFILES_DIR/$1"
    local sys_dir="$2"
    local dir_type="$3"
    local rel_base="$1"
    case "$dir_type" in
        dir-skill)
            diff_dir_skill "$repo_dir" "$sys_dir" "$rel_base"
            ;;
        dir-md)
            diff_dir_pattern "$repo_dir" "$sys_dir" "$rel_base" "*.md"
            ;;
        dir-recurse)
            diff_dir_recursive "$repo_dir" "$sys_dir" "$rel_base"
            ;;
        dir-all)
            diff_dir_pattern "$repo_dir" "$sys_dir" "$rel_base" "*"
            ;;
    esac
}

diff_dir_pattern() {
    local repo_dir="$1"
    local sys_dir="$2"
    local rel_base="$3"
    local pattern="$4"
    local seen=()
    # Check repo files
    if [[ -d "$repo_dir" ]]; then
        for f in "$repo_dir"/$pattern; do
            [[ -f "$f" ]] || continue
            local name
            name=$(basename "$f")
            should_skip "$name" && continue
            seen+=("$name")
            diff_file "$rel_base/$name" "$sys_dir/$name"
        done
    fi
    # Check system files not in repo
    if [[ -d "$sys_dir" ]]; then
        for f in "$sys_dir"/$pattern; do
            [[ -f "$f" ]] || continue
            local name
            name=$(basename "$f")
            should_skip "$name" && continue
            local already=false
            for s in "${seen[@]}"; do
                [[ "$s" == "$name" ]] && already=true && break
            done
            [[ "$already" == true ]] && continue
            diff_file "$rel_base/$name" "$sys_dir/$name"
        done
    fi
}

diff_dir_skill() {
    local repo_dir="$1"
    local sys_dir="$2"
    local rel_base="$3"
    local seen_dirs=()
    # Check repo skill dirs
    if [[ -d "$repo_dir" ]]; then
        for d in "$repo_dir"/*/; do
            [[ -d "$d" ]] || continue
            local dname
            dname=$(basename "$d")
            should_skip "$dname" && continue
            seen_dirs+=("$dname")
            local seen_files=()
            # Files in this skill dir
            for f in "$d"*; do
                [[ -f "$f" ]] || continue
                local fname
                fname=$(basename "$f")
                should_skip "$fname" && continue
                seen_files+=("$fname")
                diff_file "$rel_base/$dname/$fname" "$sys_dir/$dname/$fname"
            done
            # System-only files in this skill dir
            if [[ -d "$sys_dir/$dname" ]]; then
                for f in "$sys_dir/$dname"/*; do
                    [[ -f "$f" ]] || continue
                    local fname
                    fname=$(basename "$f")
                    should_skip "$fname" && continue
                    local already=false
                    for s in "${seen_files[@]}"; do
                        [[ "$s" == "$fname" ]] && already=true && break
                    done
                    [[ "$already" == true ]] && continue
                    diff_file "$rel_base/$dname/$fname" "$sys_dir/$dname/$fname"
                done
            fi
        done
    fi
    # System-only skill dirs
    if [[ -d "$sys_dir" ]]; then
        for d in "$sys_dir"/*/; do
            [[ -d "$d" ]] || continue
            local dname
            dname=$(basename "$d")
            should_skip "$dname" && continue
            local already=false
            for s in "${seen_dirs[@]}"; do
                [[ "$s" == "$dname" ]] && already=true && break
            done
            [[ "$already" == true ]] && continue
            for f in "$d"*; do
                [[ -f "$f" ]] || continue
                local fname
                fname=$(basename "$f")
                should_skip "$fname" && continue
                diff_file "$rel_base/$dname/$fname" "$sys_dir/$dname/$fname"
            done
        done
    fi
}

diff_dir_recursive() {
    local repo_dir="$1"
    local sys_dir="$2"
    local rel_base="$3"
    local seen_dirs=()
    # Check repo subdirs
    if [[ -d "$repo_dir" ]]; then
        for d in "$repo_dir"/*/; do
            [[ -d "$d" ]] || continue
            local dname
            dname=$(basename "$d")
            should_skip "$dname" && continue
            seen_dirs+=("$dname")
            diff_dir_recursive_walk "$d" "$sys_dir/$dname" "$rel_base/$dname"
        done
    fi
    # System-only subdirs
    if [[ -d "$sys_dir" ]]; then
        for d in "$sys_dir"/*/; do
            [[ -d "$d" ]] || continue
            local dname
            dname=$(basename "$d")
            should_skip "$dname" && continue
            local already=false
            for s in "${seen_dirs[@]}"; do
                [[ "$s" == "$dname" ]] && already=true && break
            done
            [[ "$already" == true ]] && continue
            diff_dir_recursive_walk "$repo_dir/$dname" "$d" "$rel_base/$dname"
        done
    fi
}

diff_dir_recursive_walk() {
    local repo_path="$1"
    local sys_path="$2"
    local rel_path="$3"
    local seen_files=()
    local seen_dirs=()
    # Files in current level
    if [[ -d "$repo_path" ]]; then
        for f in "$repo_path"/*; do
            [[ -e "$f" ]] || continue
            local name
            name=$(basename "$f")
            should_skip "$name" && continue
            if [[ -f "$f" ]]; then
                seen_files+=("$name")
                diff_file "$rel_path/$name" "$sys_path/$name"
            elif [[ -d "$f" ]]; then
                seen_dirs+=("$name")
                diff_dir_recursive_walk "$f" "$sys_path/$name" "$rel_path/$name"
            fi
        done
    fi
    # System-only files
    if [[ -d "$sys_path" ]]; then
        for f in "$sys_path"/*; do
            [[ -e "$f" ]] || continue
            local name
            name=$(basename "$f")
            should_skip "$name" && continue
            if [[ -f "$f" ]]; then
                local already=false
                for s in "${seen_files[@]}"; do
                    [[ "$s" == "$name" ]] && already=true && break
                done
                [[ "$already" == true ]] && continue
                diff_file "$rel_path/$name" "$sys_path/$name"
            elif [[ -d "$f" ]]; then
                local already=false
                for s in "${seen_dirs[@]}"; do
                    [[ "$s" == "$name" ]] && already=true && break
                done
                [[ "$already" == true ]] && continue
                diff_dir_recursive_walk "$repo_path/$name" "$f" "$rel_path/$name"
            fi
        done
    fi
}

run_diff() {
    echo ""
    echo "Comparing installed files against repo..."
    echo ""
    for entry in "${FILE_MAPS[@]}"; do
        IFS=: read -r repo_rel sys_path _type <<< "$entry"
        diff_file "$repo_rel" "$sys_path"
    done
    for entry in "${DIR_MAPS[@]}"; do
        IFS=: read -r repo_rel sys_path dir_type <<< "$entry"
        diff_dir_files "$repo_rel" "$sys_path" "$dir_type"
    done
    echo ""
    if [[ "$HAS_DIFF" == true ]]; then
        log_warn "Differences found"
        return 1
    else
        log_success "Everything is in sync"
        return 0
    fi
}

# ============================================
# Import logic
# ============================================

import_file() {
    local repo_file="$DOTFILES_DIR/$1"
    local sys_file="$2"
    local rel_path="$1"
    # Skip if system file doesn't exist
    [[ -f "$sys_file" ]] || return 0
    # Skip .context.md
    should_skip "$sys_file" && return 0
    # If repo file exists and is identical, skip
    if [[ -f "$repo_file" ]] && cmp -s "$repo_file" "$sys_file"; then
        return 0
    fi
    # Modified or new
    if [[ "$DRY_RUN" == true ]]; then
        if [[ -f "$repo_file" ]]; then
            log_warn "would import  $rel_path  (modified)"
        else
            log_info "would import  $rel_path  (new)"
        fi
        HAS_DIFF=true
        return 0
    fi
    mkdir -p "$(dirname "$repo_file")"
    cp "$sys_file" "$repo_file"
    if [[ -f "$repo_file" ]]; then
        log_success "imported  $rel_path"
    fi
    HAS_DIFF=true
}

import_dir_files() {
    local repo_dir="$DOTFILES_DIR/$1"
    local sys_dir="$2"
    local dir_type="$3"
    local rel_base="$1"
    [[ -d "$sys_dir" ]] || return 0
    case "$dir_type" in
        dir-skill)
            import_dir_skill "$repo_dir" "$sys_dir" "$rel_base"
            ;;
        dir-md)
            import_dir_pattern "$sys_dir" "$rel_base" "*.md"
            ;;
        dir-recurse)
            import_dir_recursive "$sys_dir" "$rel_base"
            ;;
        dir-all)
            import_dir_pattern "$sys_dir" "$rel_base" "*"
            ;;
    esac
}

import_dir_pattern() {
    local sys_dir="$1"
    local rel_base="$2"
    local pattern="$3"
    for f in "$sys_dir"/$pattern; do
        [[ -f "$f" ]] || continue
        local name
        name=$(basename "$f")
        should_skip "$name" && continue
        import_file "$rel_base/$name" "$f"
    done
}

import_dir_skill() {
    local repo_dir="$1"
    local sys_dir="$2"
    local rel_base="$3"
    for d in "$sys_dir"/*/; do
        [[ -d "$d" ]] || continue
        local dname
        dname=$(basename "$d")
        should_skip "$dname" && continue
        for f in "$d"*; do
            [[ -f "$f" ]] || continue
            local fname
            fname=$(basename "$f")
            should_skip "$fname" && continue
            import_file "$rel_base/$dname/$fname" "$f"
        done
    done
}

import_dir_recursive() {
    local sys_dir="$1"
    local rel_base="$2"
    for f in "$sys_dir"/*; do
        [[ -e "$f" ]] || continue
        local name
        name=$(basename "$f")
        should_skip "$name" && continue
        if [[ -f "$f" ]]; then
            import_file "$rel_base/$name" "$f"
        elif [[ -d "$f" ]]; then
            import_dir_recursive "$f" "$rel_base/$name"
        fi
    done
}

run_import() {
    echo ""
    if [[ "$DRY_RUN" == true ]]; then
        echo "Dry run: showing what would be imported..."
    else
        echo "Importing changed files from system to repo..."
    fi
    echo ""
    for entry in "${FILE_MAPS[@]}"; do
        IFS=: read -r repo_rel sys_path _type <<< "$entry"
        import_file "$repo_rel" "$sys_path"
    done
    for entry in "${DIR_MAPS[@]}"; do
        IFS=: read -r repo_rel sys_path dir_type <<< "$entry"
        import_dir_files "$repo_rel" "$sys_path" "$dir_type"
    done
    echo ""
    if [[ "$HAS_DIFF" == true ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_warn "Files would be imported (run without --dry-run to apply)"
        else
            log_success "Import complete"
        fi
    else
        log_success "Nothing to import — everything is in sync"
    fi
}

# ============================================
# Main
# ============================================

usage() {
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  diff              Show differences between repo and installed files"
    echo "  import            Copy changed/new files from system back to repo"
    echo ""
    echo "Options:"
    echo "  --verbose         Show identical files in diff output"
    echo "  --dry-run         Show what import would do without copying"
}

main() {
    local command="${1:-}"
    shift || true
    # Parse flags
    for arg in "$@"; do
        case "$arg" in
            --verbose) VERBOSE=true ;;
            --dry-run) DRY_RUN=true ;;
            -h|--help) usage; exit 0 ;;
            *) log_error "Unknown option: $arg"; usage; exit 2 ;;
        esac
    done
    case "$command" in
        diff)
            run_diff
            ;;
        import)
            run_import
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        "")
            log_error "No command specified"
            usage
            exit 2
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            exit 2
            ;;
    esac
}

main "$@"
