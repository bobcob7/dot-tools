# macOS iTerm2 Setup

A complete guide to setting up and configuring iTerm2 for development on macOS.

## Installation

### Via Homebrew (Recommended)

```bash
brew install --cask iterm2
```

### Direct Download

Download from https://iterm2.com/downloads.html

---

## Initial Setup

### Enable Shell Integration

Shell integration provides features like command history, directory tracking, and more.

```bash
# For Bash
curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash
echo 'source ~/.iterm2_shell_integration.bash' >> ~/.bashrc

# For Zsh
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
echo 'source ~/.iterm2_shell_integration.zsh' >> ~/.zshrc
```

### Make iTerm2 Default Terminal

1. Open iTerm2
2. Go to **iTerm2** → **Make iTerm2 Default Term**

---

## Preferences

Open preferences with `Cmd+,`

### General

| Setting | Recommended Value |
|---------|-------------------|
| Closing → Confirm closing multiple sessions | On |
| Closing → Confirm "Quit iTerm2" | On |
| Selection → Copy to pasteboard on selection | On |
| Selection → Applications in terminal may access clipboard | On |

### Appearance

| Setting | Recommended Value |
|---------|-------------------|
| General → Theme | Minimal |
| Windows → Show window number in title bar | Off |
| Tabs → Show tab bar even when there is only one tab | Off |
| Tabs → Tab bar position | Top |
| Panes → Show per-pane title bar with split panes | Off |

### Profiles → General

| Setting | Recommended Value |
|---------|-------------------|
| Working Directory | Reuse previous session's directory |
| Command | Login Shell |

### Profiles → Text

| Setting | Recommended Value |
|---------|-------------------|
| Cursor | Vertical bar |
| Blinking cursor | Off |
| Font | JetBrainsMono Nerd Font, 13pt |
| Use ligatures | On |
| Anti-aliased | On |

### Profiles → Window

| Setting | Recommended Value |
|---------|-------------------|
| Transparency | 0 (for accurate colors) |
| Blur | Off |
| Columns | 120 |
| Rows | 35 |

### Profiles → Terminal

| Setting | Recommended Value |
|---------|-------------------|
| Scrollback lines | 10000 |
| Save lines to scrollback when an app status bar is present | On |
| Report terminal type | xterm-256color |

### Profiles → Keys

| Setting | Recommended Value |
|---------|-------------------|
| Left Option Key | Esc+ |
| Right Option Key | Esc+ |

This allows Option as Meta key for shell shortcuts (Alt+B, Alt+F, etc).

---

## Fonts

### Recommended Fonts

| Font | Description |
|------|-------------|
| [JetBrains Mono](https://www.jetbrains.com/lp/mono/) | Free, excellent ligatures |
| [Fira Code](https://github.com/tonsky/FiraCode) | Popular, good ligatures |
| [SF Mono](https://developer.apple.com/fonts/) | Apple's monospace font |
| [Hack](https://sourcefoundry.org/hack/) | Clean, no ligatures |

### Installing Nerd Fonts

For statuslines with icons (vim-airline, powerlevel10k, starship):

```bash
# Individual font
brew install --cask font-jetbrains-mono-nerd-font

# Or browse all available
brew search nerd-font
```

Set in iTerm2: **Preferences** → **Profiles** → **Text** → **Font**

---

## Color Schemes

### Installing Dracula Theme

**Option 1: Via Git**

```bash
cd ~/Downloads
git clone https://github.com/dracula/iterm.git
```

Then import:
1. **Preferences** → **Profiles** → **Colors**
2. Click **Color Presets...** dropdown → **Import...**
3. Select `Dracula.itermcolors` from the cloned folder
4. Click **Color Presets...** → **Dracula**

**Option 2: Direct Download**

1. Download from https://draculatheme.com/iterm
2. Import via **Preferences** → **Profiles** → **Colors** → **Color Presets...** → **Import...**

### Dracula Colors (Manual)

If you prefer to set colors manually:

| Color | Hex |
|-------|-----|
| Background | #282A36 |
| Foreground | #F8F8F2 |
| Selection | #44475A |
| Comment | #6272A4 |
| Cyan | #8BE9FD |
| Green | #50FA7B |
| Orange | #FFB86C |
| Pink | #FF79C6 |
| Purple | #BD93F9 |
| Red | #FF5555 |
| Yellow | #F1FA8C |

### Other Popular Schemes

Download `.itermcolors` files from:
- [Gruvbox](https://github.com/morhetz/gruvbox-contrib/tree/master/iterm2)
- [One Dark](https://github.com/one-dark/iterm-one-dark-theme)
- [Nord](https://github.com/arcticicestudio/nord-iterm2)
- [Solarized](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized)

---

## Keyboard Shortcuts

### Essential Built-in Shortcuts

| Action | Shortcut |
|--------|----------|
| New Tab | `Cmd+T` |
| Close Tab | `Cmd+W` |
| Next Tab | `Cmd+Right` or `Cmd+Shift+]` |
| Previous Tab | `Cmd+Left` or `Cmd+Shift+[` |
| Split Horizontally | `Cmd+D` |
| Split Vertically | `Cmd+Shift+D` |
| Navigate Panes | `Cmd+Option+Arrow` |
| Close Pane | `Cmd+W` |
| Toggle Fullscreen | `Cmd+Enter` |
| Clear Screen | `Cmd+K` |
| Find | `Cmd+F` |
| Open Preferences | `Cmd+,` |

### Custom Key Mappings

To add custom shortcuts:

1. **Preferences** → **Keys** → **Key Bindings**
2. Click **+** to add a new binding

**Recommended additions:**

| Key | Action | Send |
|-----|--------|------|
| `Cmd+Left` | Send Escape Sequence | `OH` (beginning of line) |
| `Cmd+Right` | Send Escape Sequence | `OF` (end of line) |
| `Option+Left` | Send Escape Sequence | `b` (back one word) |
| `Option+Right` | Send Escape Sequence | `f` (forward one word) |
| `Option+Delete` | Send Hex Code | `0x17` (delete word) |

### Natural Text Editing Preset

For familiar macOS text editing:

1. **Preferences** → **Profiles** → **Keys** → **Key Mappings**
2. Click **Presets...** → **Natural Text Editing**

---

## Hotkey Window (Drop-down Terminal)

Create a Quake-style drop-down terminal:

1. **Preferences** → **Keys** → **Hotkey**
2. Check **Show/hide all windows with a system-wide hotkey**
3. Set hotkey (e.g., `Ctrl+\`` or `F12`)

Or create a dedicated hotkey profile:

1. **Preferences** → **Profiles** → Create new profile
2. Go to **Keys** tab
3. Check **A hotkey opens a dedicated window with this profile**
4. Configure hotkey and window behavior

---

## Status Bar

iTerm2 has a built-in configurable status bar:

1. **Preferences** → **Profiles** → **Session**
2. Check **Status bar enabled**
3. Click **Configure Status Bar**

**Recommended components:**
- Current Directory
- git state
- CPU Utilization
- Memory Utilization
- Battery Level (for laptops)

---

## tmux Integration

iTerm2 has native tmux integration that replaces tmux's UI with native iTerm2 tabs/panes:

```bash
# Start tmux in control mode
tmux -CC

# Attach to existing session in control mode
tmux -CC attach
```

### Configure tmux Integration

**Preferences** → **General** → **tmux**

| Setting | Recommended |
|---------|-------------|
| Open tmux windows as | Native tabs |
| Automatically bury the tmux client session | On |

---

## Useful Features

### Instant Replay

Review terminal history like a video:

- `Cmd+Option+B` to enter Instant Replay
- Arrow keys to navigate
- `Esc` to exit

### Broadcast Input

Type in multiple panes simultaneously:

- **Shell** → **Broadcast Input** → **Broadcast Input to All Panes in Current Tab**
- Or `Cmd+Shift+I`

### Triggers

Automatically respond to text patterns:

1. **Preferences** → **Profiles** → **Advanced** → **Triggers**
2. Click **Edit**
3. Add patterns and actions (highlight, alert, run command, etc.)

### Password Manager

Store and auto-fill passwords:

1. **Window** → **Password Manager** (`Cmd+Option+F`)
2. Add entries
3. Use in terminal when prompted

### Annotations

Add notes to terminal output:

- `Cmd+Shift+A` to add annotation at cursor
- Right-click → **Annotations** to view

---

## Shell Configuration

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# Enable 256 colors
export TERM=xterm-256color

# Enable true color support
export COLORTERM=truecolor
```

For tmux compatibility, add to `~/.tmux.conf`:

```bash
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
```

---

## Complete Settings Export/Import

### Export Settings

```bash
# Export all preferences
defaults export com.googlecode.iterm2 ~/iterm2-settings.plist
```

Or use iTerm2's built-in:
- **Preferences** → **General** → **Preferences** → **Load preferences from a custom folder or URL**
- Check **Save changes to folder when iTerm2 quits**

### Import Settings

```bash
# Import preferences
defaults import com.googlecode.iterm2 ~/iterm2-settings.plist
```

---

## Troubleshooting

### Colors Look Wrong in vim/tmux

1. Ensure `TERM=xterm-256color` in your shell config
2. For true color, add to `.vimrc`:
   ```vim
   set termguicolors
   ```
3. Check tmux is configured for true color (see Shell Configuration above)

### Option Key Not Working as Meta

- **Preferences** → **Profiles** → **Keys**
- Set **Left Option Key** to **Esc+**

### Slow Startup

1. **Preferences** → **General** → **Startup**
2. Set **Window restoration policy** to **Only Restore Hotkey Window**

### Font Icons Not Displaying

- Ensure you installed a Nerd Font variant
- Set the exact font name in **Preferences** → **Profiles** → **Text**
- Some fonts need "Nerd Font" or "NF" suffix

---

## References

- [iTerm2 Documentation](https://iterm2.com/documentation.html)
- [iTerm2 Features](https://iterm2.com/features.html)
- [Dracula Theme for iTerm](https://draculatheme.com/iterm)
- [Nerd Fonts](https://www.nerdfonts.com/)
