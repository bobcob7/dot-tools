# Windows Terminal Setup

A complete guide to setting up and configuring Windows Terminal for development.

## Installation

### From Microsoft Store (Recommended)

Search for "Windows Terminal" in the Microsoft Store, or visit:
https://aka.ms/terminal

### Via Winget

```powershell
winget install Microsoft.WindowsTerminal
```

### Via Chocolatey

```powershell
choco install microsoft-windows-terminal
```

---

## Configuration

Windows Terminal stores settings in a JSON file. Access it via:

- **GUI**: `Ctrl+,` → Click "Open JSON file" (bottom left)
- **Keyboard**: `Ctrl+Shift+,`
- **File path**: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

---

## Recommended Settings

### Global Defaults

Add to the root of your `settings.json`:

```json
{
    "defaultProfile": "{your-wsl-guid-here}",
    "copyOnSelect": true,
    "copyFormatting": false,
    "trimBlockSelection": true,
    "wordDelimiters": " /\\()\"'-.,:;<>~!@#$%^&*|+=[]{}~?│",
    "confirmCloseAllTabs": true,
    "startOnUserLogin": false,
    "launchMode": "default",
    "snapToGridOnResize": true,
    "tabWidthMode": "equal"
}
```

### Profile Defaults

Add under `"profiles"` → `"defaults"`:

```json
"defaults": {
    "font": {
        "face": "JetBrains Mono",
        "size": 11,
        "weight": "normal"
    },
    "padding": "8",
    "scrollbarState": "visible",
    "historySize": 10000,
    "antialiasingMode": "grayscale",
    "cursorShape": "bar",
    "cursorHeight": 25
}
```

---

## Fonts

### Recommended Fonts

| Font | Description |
|------|-------------|
| [JetBrains Mono](https://www.jetbrains.com/lp/mono/) | Free, excellent ligatures |
| [Fira Code](https://github.com/tonsky/FiraCode) | Popular, good ligatures |
| [Cascadia Code](https://github.com/microsoft/cascadia-code) | Microsoft's terminal font |
| [Hack](https://sourcefoundry.org/hack/) | Clean, no ligatures |

### Nerd Fonts (for Powerline/Icons)

For statuslines with icons (vim-airline, powerlevel10k, starship), install a Nerd Font:

```powershell
# Via Chocolatey
choco install nerd-fonts-jetbrainsmono

# Or download from https://www.nerdfonts.com/
```

Then set in your profile:

```json
"font": {
    "face": "JetBrainsMono Nerd Font"
}
```

---

## Color Schemes

### Installing Dracula Theme

Add to the `"schemes"` array:

```json
{
    "name": "Dracula",
    "background": "#282A36",
    "black": "#21222C",
    "blue": "#BD93F9",
    "brightBlack": "#6272A4",
    "brightBlue": "#D6ACFF",
    "brightCyan": "#A4FFFF",
    "brightGreen": "#69FF94",
    "brightPurple": "#FF92DF",
    "brightRed": "#FF6E6E",
    "brightWhite": "#FFFFFF",
    "brightYellow": "#FFFFA5",
    "cursorColor": "#F8F8F2",
    "cyan": "#8BE9FD",
    "foreground": "#F8F8F2",
    "green": "#50FA7B",
    "purple": "#FF79C6",
    "red": "#FF5555",
    "selectionBackground": "#44475A",
    "white": "#F8F8F2",
    "yellow": "#F1FA8C"
}
```

### Other Popular Schemes

<details>
<summary>Gruvbox Dark</summary>

```json
{
    "name": "Gruvbox Dark",
    "background": "#282828",
    "black": "#282828",
    "blue": "#458588",
    "brightBlack": "#928374",
    "brightBlue": "#83A598",
    "brightCyan": "#8EC07C",
    "brightGreen": "#B8BB26",
    "brightPurple": "#D3869B",
    "brightRed": "#FB4934",
    "brightWhite": "#EBDBB2",
    "brightYellow": "#FABD2F",
    "cursorColor": "#EBDBB2",
    "cyan": "#689D6A",
    "foreground": "#EBDBB2",
    "green": "#98971A",
    "purple": "#B16286",
    "red": "#CC241D",
    "selectionBackground": "#504945",
    "white": "#A89984",
    "yellow": "#D79921"
}
```

</details>

<details>
<summary>One Dark</summary>

```json
{
    "name": "One Dark",
    "background": "#282C34",
    "black": "#282C34",
    "blue": "#61AFEF",
    "brightBlack": "#5C6370",
    "brightBlue": "#61AFEF",
    "brightCyan": "#56B6C2",
    "brightGreen": "#98C379",
    "brightPurple": "#C678DD",
    "brightRed": "#E06C75",
    "brightWhite": "#DCDFE4",
    "brightYellow": "#E5C07B",
    "cursorColor": "#A3B3CC",
    "cyan": "#56B6C2",
    "foreground": "#ABB2BF",
    "green": "#98C379",
    "purple": "#C678DD",
    "red": "#E06C75",
    "selectionBackground": "#3E4451",
    "white": "#ABB2BF",
    "yellow": "#E5C07B"
}
```

</details>

### Applying a Color Scheme

In your profile under `"profiles"` → `"list"`:

```json
{
    "name": "Ubuntu",
    "source": "Windows.Terminal.Wsl",
    "colorScheme": "Dracula"
}
```

---

## Transparency & Acrylic

### Solid Background (Recommended)

For accurate colors with tmux/vim:

```json
"useAcrylic": false,
"opacity": 100
```

### Subtle Transparency

```json
"useAcrylic": true,
"opacity": 95
```

### Background Image

```json
"backgroundImage": "C:/Users/you/Pictures/background.png",
"backgroundImageOpacity": 0.3,
"backgroundImageStretchMode": "uniformToFill"
```

---

## Keyboard Shortcuts

Add to `"actions"` array:

```json
"actions": [
    { "command": "paste", "keys": "ctrl+v" },
    { "command": "copy", "keys": "ctrl+c" },
    { "command": "find", "keys": "ctrl+shift+f" },
    { "command": { "action": "splitPane", "split": "horizontal" }, "keys": "alt+shift+-" },
    { "command": { "action": "splitPane", "split": "vertical" }, "keys": "alt+shift+=" },
    { "command": { "action": "moveFocus", "direction": "up" }, "keys": "alt+up" },
    { "command": { "action": "moveFocus", "direction": "down" }, "keys": "alt+down" },
    { "command": { "action": "moveFocus", "direction": "left" }, "keys": "alt+left" },
    { "command": { "action": "moveFocus", "direction": "right" }, "keys": "alt+right" },
    { "command": "closePane", "keys": "ctrl+shift+w" },
    { "command": { "action": "newTab" }, "keys": "ctrl+shift+t" },
    { "command": "nextTab", "keys": "ctrl+tab" },
    { "command": "prevTab", "keys": "ctrl+shift+tab" }
]
```

---

## WSL Integration

### Setting WSL as Default

1. Find your WSL profile's GUID in `settings.json`
2. Set `"defaultProfile"` to that GUID

### Starting in Linux Home Directory

Add to your WSL profile:

```json
"startingDirectory": "//wsl$/Ubuntu/home/yourusername"
```

Or use `~` if you have a recent version:

```json
"startingDirectory": "~"
```

---

## Complete Example Configuration

```json
{
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "defaultProfile": "{2c4de342-38b7-51cf-b940-2309a097f518}",
    "copyOnSelect": true,
    "copyFormatting": false,

    "profiles": {
        "defaults": {
            "font": {
                "face": "JetBrainsMono Nerd Font",
                "size": 11
            },
            "padding": "8",
            "colorScheme": "Dracula",
            "useAcrylic": false,
            "opacity": 100
        },
        "list": [
            {
                "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
                "name": "Ubuntu",
                "source": "Windows.Terminal.Wsl",
                "startingDirectory": "~"
            },
            {
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "name": "PowerShell",
                "commandline": "powershell.exe",
                "hidden": false
            }
        ]
    },

    "schemes": [
        {
            "name": "Dracula",
            "background": "#282A36",
            "black": "#21222C",
            "blue": "#BD93F9",
            "brightBlack": "#6272A4",
            "brightBlue": "#D6ACFF",
            "brightCyan": "#A4FFFF",
            "brightGreen": "#69FF94",
            "brightPurple": "#FF92DF",
            "brightRed": "#FF6E6E",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#FFFFA5",
            "cursorColor": "#F8F8F2",
            "cyan": "#8BE9FD",
            "foreground": "#F8F8F2",
            "green": "#50FA7B",
            "purple": "#FF79C6",
            "red": "#FF5555",
            "selectionBackground": "#44475A",
            "white": "#F8F8F2",
            "yellow": "#F1FA8C"
        }
    ],

    "actions": [
        { "command": "paste", "keys": "ctrl+v" },
        { "command": "copy", "keys": "ctrl+c" },
        { "command": { "action": "splitPane", "split": "horizontal" }, "keys": "alt+shift+-" },
        { "command": { "action": "splitPane", "split": "vertical" }, "keys": "alt+shift+=" }
    ]
}
```

---

## Troubleshooting

### Colors Look Wrong in tmux/vim

Ensure your WSL `~/.bashrc` or `~/.zshrc` has:

```bash
export TERM=xterm-256color
```

For tmux, add to `~/.tmux.conf`:

```bash
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
```

### Font Icons Not Displaying

- Install a Nerd Font variant
- Set the exact font name (check in Font Book/Settings)
- Restart Windows Terminal

### Cursor Invisible

Set a visible cursor color in your scheme or use:

```json
"cursorColor": "#F8F8F2"
```

---

## References

- [Windows Terminal Documentation](https://docs.microsoft.com/en-us/windows/terminal/)
- [Windows Terminal Color Schemes](https://docs.microsoft.com/en-us/windows/terminal/customize-settings/color-schemes)
- [Dracula Theme](https://draculatheme.com/windows-terminal)
- [Nerd Fonts](https://www.nerdfonts.com/)
