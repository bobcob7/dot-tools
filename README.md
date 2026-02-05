# dot-tools

Personal dotfiles and configuration tools.

## Documentation

### Terminal Setup
- [Windows Terminal](docs/windows-terminal.md) - Complete Windows Terminal configuration guide
- [macOS iTerm2](docs/macos-iterm.md) - Complete iTerm2 configuration guide for macOS

### Vim
- [Vim Plugins & Extensions Reference](docs/vim-plugins.md) - Curated list of 100 Vim plugins organized by category

## Configurations

### Claude Code (`configs/claude/`)

User-level Claude Code configuration. Symlink to `~/.claude/`:

```bash
ln -s /path/to/dot-tools/configs/claude ~/.claude
```

**Contents:**

| Path | Description |
|------|-------------|
| `CLAUDE.md` | User preferences and coding style |
| `settings.json` | Permissions and tool allowlists |
| `skills/commit/` | Guided git commit workflow |
| `skills/review/` | Code review checklist |
| `skills/explain/` | Code explanation helper |
| `skills/refactor/` | Refactoring guide |
| `agents/code-reviewer.md` | Specialized code review agent |
| `agents/test-runner.md` | Test execution and debugging agent |
| `rules/git-workflow.md` | Git conventions |
| `rules/error-handling.md` | Error handling best practices |
| `rules/testing.md` | Testing conventions |

## Setup

```bash
./setup.sh
```
