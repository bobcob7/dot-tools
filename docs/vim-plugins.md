# Vim Plugins & Extensions Reference

A curated list of 100 Vim plugins organized by category. All plugins work with Vim 8+.

**Legend:**
- `[RECOMMENDED]` - Highly recommended for most users

---

## Plugin Managers

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 1 | [vim-plug](https://github.com/junegunn/vim-plug) | Minimalist plugin manager with parallel installation | `[RECOMMENDED]` |
| 2 | [Vundle](https://github.com/VundleVim/Vundle.vim) | Classic plugin manager, easy to configure | |
| 3 | [pathogen](https://github.com/tpope/vim-pathogen) | Simple runtime path manager | |
| 4 | [dein.vim](https://github.com/Shougo/dein.vim) | Dark-powered plugin manager, fast startup | |
| 5 | [minpac](https://github.com/k-takata/minpac) | Minimal package manager using Vim 8 packages | |

---

## Code Completion & LSP

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 6 | [coc.nvim](https://github.com/neoclide/coc.nvim) | VS Code-like completion with extension ecosystem | `[RECOMMENDED]` |
| 7 | [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) | Fast completion engine, excellent for C/C++ | |
| 8 | [vim-lsp](https://github.com/prabirshrestha/vim-lsp) | Async LSP support for Vim 8 | `[RECOMMENDED]` |
| 9 | [vim-lsp-settings](https://github.com/mattn/vim-lsp-settings) | Auto-install language servers for vim-lsp | `[RECOMMENDED]` |
| 10 | [asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) | Async completion in pure Vim script | |
| 11 | [completor.vim](https://github.com/maralla/completor.vim) | Async completion framework for Vim 8 | |
| 12 | [vimcomplete](https://github.com/girishji/vimcomplete) | Async autocompletion with multiple sources | |
| 13 | [supertab](https://github.com/ervandew/supertab) | Tab completion in insert mode | |
| 14 | [vim-mucomplete](https://github.com/lifepillar/vim-mucomplete) | Chained completion that works the way you want | |

---

## Linting & Formatting

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 15 | [ALE](https://github.com/dense-analysis/ale) | Asynchronous Lint Engine with LSP support | `[RECOMMENDED]` |
| 16 | [syntastic](https://github.com/vim-syntastic/syntastic) | Syntax checking plugin (synchronous) | |
| 17 | [neomake](https://github.com/neomake/neomake) | Async linting and make framework | |
| 18 | [vim-autoformat](https://github.com/vim-autoformat/vim-autoformat) | Format code with one button press | |
| 19 | [neoformat](https://github.com/sbdchd/neoformat) | Format code using formatters | |

---

## Syntax Highlighting

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 20 | [vim-polyglot](https://github.com/sheerun/vim-polyglot) | Language pack with syntax for 100+ languages | `[RECOMMENDED]` |
| 21 | [vim-javascript](https://github.com/pangloss/vim-javascript) | JavaScript syntax and indentation | |
| 22 | [typescript-vim](https://github.com/leafgarland/typescript-vim) | TypeScript syntax highlighting | |
| 23 | [vim-jsx-pretty](https://github.com/MaxMEllon/vim-jsx-pretty) | JSX/TSX syntax highlighting | |
| 24 | [vim-go](https://github.com/fatih/vim-go) | Go development plugin | `[RECOMMENDED]` |
| 25 | [rust.vim](https://github.com/rust-lang/rust.vim) | Rust file detection and syntax | |
| 26 | [python-syntax](https://github.com/vim-python/python-syntax) | Enhanced Python syntax highlighting | |
| 27 | [vim-ruby](https://github.com/vim-ruby/vim-ruby) | Ruby configuration files | |

---

## File Navigation & Fuzzy Finding

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 28 | [fzf](https://github.com/junegunn/fzf) | Command-line fuzzy finder | `[RECOMMENDED]` |
| 29 | [fzf.vim](https://github.com/junegunn/fzf.vim) | fzf integration for Vim | `[RECOMMENDED]` |
| 30 | [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim) | Fuzzy file/buffer/mru/tag finder | |
| 31 | [NERDTree](https://github.com/preservim/nerdtree) | Tree file explorer | `[RECOMMENDED]` |
| 32 | [vim-vinegar](https://github.com/tpope/vim-vinegar) | Enhanced netrw file browser | |
| 33 | [ranger.vim](https://github.com/francoiscabrol/ranger.vim) | Ranger file manager integration | |
| 34 | [vim-dirvish](https://github.com/justinmk/vim-dirvish) | Path navigator designed to work with Vim | |
| 35 | [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin) | Git status flags for NERDTree | |
| 36 | [vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs) | NERDTree across all tabs | |

---

## Tags & Code Navigation

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 37 | [tagbar](https://github.com/preservim/tagbar) | Display tags ordered by scope | `[RECOMMENDED]` |
| 38 | [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags) | Automatic tag file management | `[RECOMMENDED]` |
| 39 | [vim-easytags](https://github.com/xolox/vim-easytags) | Automated tag generation and highlighting | |
| 40 | [vim-tags](https://github.com/lukelbd/vim-tags) | Ctags integration for Vim | |

---

## Git Integration

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 41 | [vim-fugitive](https://github.com/tpope/vim-fugitive) | Premier Git wrapper for Vim | `[RECOMMENDED]` |
| 42 | [vim-gitgutter](https://github.com/airblade/vim-gitgutter) | Shows git diff in sign column | `[RECOMMENDED]` |
| 43 | [vim-signify](https://github.com/mhinz/vim-signify) | Show VCS diff in sign column (git, hg, svn) | |
| 44 | [vim-rhubarb](https://github.com/tpope/vim-rhubarb) | GitHub extension for fugitive | |
| 45 | [gv.vim](https://github.com/junegunn/gv.vim) | Git commit browser | |
| 46 | [vimagit](https://github.com/jreybert/vimagit) | Ease your git workflow | |
| 47 | [vim-merginal](https://github.com/idanarye/vim-merginal) | Fugitive extension for branch management | |

---

## Text Manipulation & Editing

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 48 | [vim-surround](https://github.com/tpope/vim-surround) | Easily add/change/delete surroundings | `[RECOMMENDED]` |
| 49 | [vim-commentary](https://github.com/tpope/vim-commentary) | Comment stuff out with gcc | `[RECOMMENDED]` |
| 50 | [NERDCommenter](https://github.com/preservim/nerdcommenter) | Feature-rich commenting plugin | |
| 51 | [targets.vim](https://github.com/wellle/targets.vim) | Additional text objects | `[RECOMMENDED]` |
| 52 | [vim-textobj-user](https://github.com/kana/vim-textobj-user) | Create your own text objects | |
| 53 | [vim-textobj-entire](https://github.com/kana/vim-textobj-entire) | Text objects for entire buffer | |
| 54 | [vim-repeat](https://github.com/tpope/vim-repeat) | Enable `.` repeat for plugin mappings | `[RECOMMENDED]` |
| 55 | [vim-abolish](https://github.com/tpope/vim-abolish) | Case-preserving substitution, coercion | |
| 56 | [vim-unimpaired](https://github.com/tpope/vim-unimpaired) | Pairs of handy bracket mappings | |
| 57 | [vim-exchange](https://github.com/tommcdo/vim-exchange) | Easy text exchange operator | |
| 58 | [vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors) | Sublime-style multiple cursors | |
| 59 | [auto-pairs](https://github.com/jiangmiao/auto-pairs) | Auto-insert matching brackets/quotes | |
| 60 | [vim-closer](https://github.com/rstacruz/vim-closer) | Auto-close brackets on Enter | |
| 61 | [vim-endwise](https://github.com/tpope/vim-endwise) | Wisely add "end" in Ruby, etc. | |
| 62 | [tabular](https://github.com/godlygeek/tabular) | Text filtering and alignment | `[RECOMMENDED]` |
| 63 | [vim-easy-align](https://github.com/junegunn/vim-easy-align) | Simple, easy-to-use alignment | |

---

## Motion & Navigation

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 64 | [vim-easymotion](https://github.com/easymotion/vim-easymotion) | Vim motions on speed | `[RECOMMENDED]` |
| 65 | [vim-sneak](https://github.com/justinmk/vim-sneak) | Jump to any location with 2 characters | `[RECOMMENDED]` |
| 66 | [quick-scope](https://github.com/unblevable/quick-scope) | Highlight unique characters for f/F/t/T | |
| 67 | [vim-matchup](https://github.com/andymass/vim-matchup) | Enhanced % matching | |
| 68 | [matchit.vim](https://github.com/vim-scripts/matchit.zip) | Extended % matching for HTML, LaTeX, etc. | |
| 69 | [vim-smoothie](https://github.com/psliwka/vim-smoothie) | Smooth scrolling | |

---

## Snippets

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 70 | [UltiSnips](https://github.com/SirVer/ultisnips) | Ultimate snippet solution for Vim | `[RECOMMENDED]` |
| 71 | [vim-snippets](https://github.com/honza/vim-snippets) | Snippet collection for various languages | `[RECOMMENDED]` |
| 72 | [vim-snipmate](https://github.com/garbas/vim-snipmate) | TextMate-style snippets | |
| 73 | [neosnippet.vim](https://github.com/Shougo/neosnippet.vim) | Snippet support with async | |

---

## Search & Replace

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 74 | [vim-grepper](https://github.com/mhinz/vim-grepper) | Use your favorite grep tool async | `[RECOMMENDED]` |
| 75 | [ack.vim](https://github.com/mileszs/ack.vim) | Ack/ag search integration | |
| 76 | [far.vim](https://github.com/brooth/far.vim) | Find and replace across files | |
| 77 | [vim-abolish](https://github.com/tpope/vim-abolish) | Search for word variations | |
| 78 | [vim-visual-star-search](https://github.com/nelstrom/vim-visual-star-search) | Search for visual selection with * | |

---

## Status Line & UI

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 79 | [vim-airline](https://github.com/vim-airline/vim-airline) | Lean & mean status/tabline | `[RECOMMENDED]` |
| 80 | [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | Themes for vim-airline | `[RECOMMENDED]` |
| 81 | [lightline.vim](https://github.com/itchyny/lightline.vim) | Light and configurable statusline | |
| 82 | [vim-buftabline](https://github.com/ap/vim-buftabline) | Buffer list in tabline | |
| 83 | [vim-devicons](https://github.com/ryanoasis/vim-devicons) | File type icons | |

---

## Color Schemes (Dark Themes)

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 84 | [gruvbox](https://github.com/morhetz/gruvbox) | Retro groove colorscheme | `[RECOMMENDED]` |
| 85 | [onedark.vim](https://github.com/joshdick/onedark.vim) | Atom One Dark theme | `[RECOMMENDED]` |
| 86 | [dracula](https://github.com/dracula/vim) | Dark Dracula theme | `[RECOMMENDED]` |
| 87 | [nord-vim](https://github.com/arcticicestudio/nord-vim) | Arctic north-bluish theme | |
| 88 | [molokai](https://github.com/tomasr/molokai) | Monokai-inspired dark theme | |
| 89 | [vim-code-dark](https://github.com/tomasiser/vim-code-dark) | VS Code Dark+ theme | |
| 90 | [sonokai](https://github.com/sainnhe/sonokai) | High contrast Monokai Pro variant | |
| 91 | [palenight.vim](https://github.com/drewtempelmeyer/palenight.vim) | Material palenight theme | |
| 92 | [ayu-vim](https://github.com/ayu-theme/ayu-vim) | Ayu dark/mirage theme | |
| 93 | [vim-one](https://github.com/rakr/vim-one) | Adaptation of Atom One | |
| 94 | [spacegray](https://github.com/ajh17/Spacegray.vim) | Spacegray dark theme | |

---

## Undo & History

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 95 | [undotree](https://github.com/mbbill/undotree) | Undo history visualizer (pure Vim script) | `[RECOMMENDED]` |
| 96 | [vim-mundo](https://github.com/simnalamburt/vim-mundo) | Undo tree visualizer (Gundo fork) | |

---

## Session & Startup

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 97 | [vim-obsession](https://github.com/tpope/vim-obsession) | Continuously updated session files | `[RECOMMENDED]` |
| 98 | [vim-startify](https://github.com/mhinz/vim-startify) | Start screen with MRU and sessions | `[RECOMMENDED]` |
| 99 | [vim-session](https://github.com/xolox/vim-session) | Extended session management | |

---

## Miscellaneous

| # | Plugin | Description | Tags |
|---|--------|-------------|------|
| 100 | [vim-sensible](https://github.com/tpope/vim-sensible) | Universal set of defaults | `[RECOMMENDED]` |

---

## Quick Start Recommendations

For a productive Vim 8 setup, start with these essentials:

**Plugin Manager:**
- vim-plug

**Core Development:**
- coc.nvim or vim-lsp + vim-lsp-settings (completion/LSP)
- ALE (linting)
- vim-polyglot (syntax)

**Navigation:**
- fzf + fzf.vim (fuzzy finding)
- NERDTree (file explorer)
- tagbar + vim-gutentags (code navigation)

**Git:**
- vim-fugitive + vim-gitgutter

**Editing:**
- vim-surround
- vim-commentary
- targets.vim
- UltiSnips + vim-snippets
- tabular

**Motion:**
- vim-easymotion or vim-sneak

**UI:**
- vim-airline + vim-airline-themes
- gruvbox or onedark.vim or dracula

**Utilities:**
- vim-sensible (sane defaults)
- vim-repeat
- undotree
- vim-startify

---

## Theme Options

Themes that support transparency, powerline/airline, and have matching tmux themes:

### Dracula
[GitHub](https://github.com/dracula/vim) | [Tmux](https://github.com/dracula/tmux)

<div style="display:flex;gap:4px;margin:8px 0;">
<span style="background:#282a36;color:#fff;padding:4px 8px;border-radius:3px;">#282a36</span>
<span style="background:#ff79c6;color:#000;padding:4px 8px;border-radius:3px;">#ff79c6</span>
<span style="background:#bd93f9;color:#000;padding:4px 8px;border-radius:3px;">#bd93f9</span>
<span style="background:#8be9fd;color:#000;padding:4px 8px;border-radius:3px;">#8be9fd</span>
<span style="background:#50fa7b;color:#000;padding:4px 8px;border-radius:3px;">#50fa7b</span>
<span style="background:#ffb86c;color:#000;padding:4px 8px;border-radius:3px;">#ffb86c</span>
<span style="background:#ff5555;color:#000;padding:4px 8px;border-radius:3px;">#ff5555</span>
<span style="background:#f1fa8c;color:#000;padding:4px 8px;border-radius:3px;">#f1fa8c</span>
</div>

Purple/pink/cyan palette. Best ecosystem with official themes for 200+ apps.

---

### Gruvbox
[GitHub](https://github.com/morhetz/gruvbox) | [Tmux](https://github.com/egel/tmux-gruvbox)

<div style="display:flex;gap:4px;margin:8px 0;">
<span style="background:#282828;color:#fff;padding:4px 8px;border-radius:3px;">#282828</span>
<span style="background:#fb4934;color:#000;padding:4px 8px;border-radius:3px;">#fb4934</span>
<span style="background:#fe8019;color:#000;padding:4px 8px;border-radius:3px;">#fe8019</span>
<span style="background:#fabd2f;color:#000;padding:4px 8px;border-radius:3px;">#fabd2f</span>
<span style="background:#b8bb26;color:#000;padding:4px 8px;border-radius:3px;">#b8bb26</span>
<span style="background:#8ec07c;color:#000;padding:4px 8px;border-radius:3px;">#8ec07c</span>
<span style="background:#83a598;color:#000;padding:4px 8px;border-radius:3px;">#83a598</span>
<span style="background:#d3869b;color:#000;padding:4px 8px;border-radius:3px;">#d3869b</span>
</div>

Warm retro palette (orange/yellow/green). Most popular Vim theme, very readable.

---

### Sonokai
[GitHub](https://github.com/sainnhe/sonokai) | Tmux: community themes

<div style="display:flex;gap:4px;margin:8px 0;">
<span style="background:#2c2e34;color:#fff;padding:4px 8px;border-radius:3px;">#2c2e34</span>
<span style="background:#fc5d7c;color:#000;padding:4px 8px;border-radius:3px;">#fc5d7c</span>
<span style="background:#f39660;color:#000;padding:4px 8px;border-radius:3px;">#f39660</span>
<span style="background:#e7c664;color:#000;padding:4px 8px;border-radius:3px;">#e7c664</span>
<span style="background:#9ed072;color:#000;padding:4px 8px;border-radius:3px;">#9ed072</span>
<span style="background:#76cce0;color:#000;padding:4px 8px;border-radius:3px;">#76cce0</span>
<span style="background:#b39df3;color:#000;padding:4px 8px;border-radius:3px;">#b39df3</span>
</div>

High contrast Monokai Pro variant. Vivid and punchy colors.

---

### Onedark
[GitHub](https://github.com/joshdick/onedark.vim) | [Tmux](https://github.com/odedlaz/tmux-onedark-theme)

<div style="display:flex;gap:4px;margin:8px 0;">
<span style="background:#282c34;color:#fff;padding:4px 8px;border-radius:3px;">#282c34</span>
<span style="background:#e06c75;color:#000;padding:4px 8px;border-radius:3px;">#e06c75</span>
<span style="background:#d19a66;color:#000;padding:4px 8px;border-radius:3px;">#d19a66</span>
<span style="background:#e5c07b;color:#000;padding:4px 8px;border-radius:3px;">#e5c07b</span>
<span style="background:#98c379;color:#000;padding:4px 8px;border-radius:3px;">#98c379</span>
<span style="background:#56b6c2;color:#000;padding:4px 8px;border-radius:3px;">#56b6c2</span>
<span style="background:#61afef;color:#000;padding:4px 8px;border-radius:3px;">#61afef</span>
<span style="background:#c678dd;color:#000;padding:4px 8px;border-radius:3px;">#c678dd</span>
</div>

Atom One Dark port. Clean, modern, balanced colors.

---

## Mods to Install

Selected recommended plugins (excluding snippets, themes, and conflicting overlaps):

| # | Plugin | Category | Notes |
|---|--------|----------|-------|
| 1 | [vim-plug](https://github.com/junegunn/vim-plug) | Plugin Manager | |
| 2 | [vim-lsp](https://github.com/prabirshrestha/vim-lsp) | LSP | Lighter than coc.nvim |
| 3 | [vim-lsp-settings](https://github.com/mattn/vim-lsp-settings) | LSP | Auto-install servers |
| 4 | [ALE](https://github.com/dense-analysis/ale) | Linting | |
| 5 | [vim-polyglot](https://github.com/sheerun/vim-polyglot) | Syntax | 100+ languages |
| 6 | [vim-go](https://github.com/fatih/vim-go) | Syntax | Go development |
| 7 | [fzf](https://github.com/junegunn/fzf) | Navigation | CLI fuzzy finder |
| 8 | [fzf.vim](https://github.com/junegunn/fzf.vim) | Navigation | Vim integration |
| 9 | [NERDTree](https://github.com/preservim/nerdtree) | Navigation | File explorer |
| 10 | [tagbar](https://github.com/preservim/tagbar) | Tags | Code outline |
| 11 | [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags) | Tags | Auto tag management |
| 12 | [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git | Git wrapper |
| 13 | [vim-gitgutter](https://github.com/airblade/vim-gitgutter) | Git | Diff in sign column |
| 14 | [vim-surround](https://github.com/tpope/vim-surround) | Editing | Surroundings |
| 15 | [vim-commentary](https://github.com/tpope/vim-commentary) | Editing | Comments with gcc |
| 16 | [targets.vim](https://github.com/wellle/targets.vim) | Editing | Extra text objects |
| 17 | [vim-repeat](https://github.com/tpope/vim-repeat) | Editing | Dot repeat for plugins |
| 18 | [tabular](https://github.com/godlygeek/tabular) | Editing | Text alignment |
| 19 | [vim-easymotion](https://github.com/easymotion/vim-easymotion) | Motion | Visual jump hints |
| 20 | [vim-sneak](https://github.com/justinmk/vim-sneak) | Motion | 2-char jump |
| 21 | [vim-grepper](https://github.com/mhinz/vim-grepper) | Search | Async grep |
| 22 | [vim-airline](https://github.com/vim-airline/vim-airline) | UI | Status line |
| 23 | [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | UI | Airline themes |
| 24 | [undotree](https://github.com/mbbill/undotree) | Undo | Undo visualizer |
| 25 | [vim-obsession](https://github.com/tpope/vim-obsession) | Session | Auto session files |
| 26 | [vim-startify](https://github.com/mhinz/vim-startify) | Session | Start screen |
| 27 | [vim-sensible](https://github.com/tpope/vim-sensible) | Misc | Sane defaults |
| 28 | [dracula](https://github.com/dracula/vim) | Theme | Dark with colorful text |

**Excluded due to conflicts:**
- coc.nvim (overlaps with vim-lsp)

---

## Sources

- [GitHub - vim-plug](https://github.com/junegunn/vim-plug)
- [Slant - Best Vim Plugins](https://www.slant.co/topics/1224/~best-plugin-managers-for-vim)
- [VimColorSchemes](https://vimcolorschemes.com/i/top/b.dark)
- [Awesome Vim](https://github.com/akrawchyk/awesome-vim)
