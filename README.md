# dot-tools

Personal dotfiles and configuration tools.

## Architecture

[![dot-tools architecture](https://www.plantuml.com/plantuml/png/~1UDfTKprl0Z4CtVCh8dQElGEYecpTAgQgGqZ2aPAFKpveQKL_Uts9Su6J6Eptdfrtjjc4o7nCHfDmLdPWdXdAdHcSbJQ-nQkMr4iUcUsrl9CS63_ttYKhjauxJxzEAaf21e1PB-b2kBYCpkcmeB-4qlSWOngwSFgWBD2S00g_gS0uaRGCgwA7Yfzmgde82nPD-gxW61Vqeam58InOYag7YkQau5op96GbIWRCRUQ6EtjKVNFJY5m1-5IzpLBKmGlRr-Vzowupuku58oeBdnwLxKFt6PojmyW8AevE2-df0aQjTIWFbNWc03iseg34Cu77UGAVmnazwDGhYm9CikJMvb6rMXsA3e8xM3YEzMD4ReHmxPAWYtq0UcSloZjhm1eUmT-gWrLwNfVgEQ9vh-FCfysE2PAmKop94QAuYB9VU0vN2HxoTT7bSftlfcNvO5ewdahBoecq7DiHQ46xRbtSqYTQ3YDv6EVOBtFLxoCD_JERJJzIfNbcctMGXAlHofudGJE2HmOIbpo75Xjf1Vnf_m4t83KS)](https://www.plantuml.com/plantuml/uml/~1UDfTKprl0Z4CtVCh8dQElGEYecpTAgQgGqZ2aPAFKpveQKL_Uts9Su6J6Eptdfrtjjc4o7nCHfDmLdPWdXdAdHcSbJQ-nQkMr4iUcUsrl9CS63_ttYKhjauxJxzEAaf21e1PB-b2kBYCpkcmeB-4qlSWOngwSFgWBD2S00g_gS0uaRGCgwA7Yfzmgde82nPD-gxW61Vqeam58InOYag7YkQau5op96GbIWRCRUQ6EtjKVNFJY5m1-5IzpLBKmGlRr-Vzowupuku58oeBdnwLxKFt6PojmyW8AevE2-df0aQjTIWFbNWc03iseg34Cu77UGAVmnazwDGhYm9CikJMvb6rMXsA3e8xM3YEzMD4ReHmxPAWYtq0UcSloZjhm1eUmT-gWrLwNfVgEQ9vh-FCfysE2PAmKop94QAuYB9VU0vN2HxoTT7bSftlfcNvO5ewdahBoecq7DiHQ46xRbtSqYTQ3YDv6EVOBtFLxoCD_JERJJzIfNbcctMGXAlHofudGJE2HmOIbpo75Xjf1Vnf_m4t83KS)

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
| `skills/diagram/` | Create PlantUML diagrams for documentation |
| `skills/mdview/` | Render and view markdown in browser |
| `agents/code-reviewer.md` | Specialized code review agent |
| `agents/test-runner.md` | Test execution and debugging agent |
| `rules/git-workflow.md` | Git conventions |
| `rules/error-handling.md` | Error handling best practices |
| `rules/testing.md` | Testing conventions |

## Setup

```bash
./setup.sh
```
