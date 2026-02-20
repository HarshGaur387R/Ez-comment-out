# ez-comment-out

A lightweight Neovim plugin that makes commenting out code effortless. 
It also allows you to customize key-bindings and comment symbols.
This plugin supports single-line and multi-line comments across multiple programming languages.

## Features

- 🚀 **Easy to use** - Single keybinding for both normal and visual modes
- 🎯 **Multi-language support** - Configurable comment symbols for any language
- 📝 **Flexible commenting** - Supports both single-line and multi-line comments
- 🎨 **Smart defaults** - Uses single-line comments when available, falls back
  to multi-line
- ⚡ **Lightweight** - Minimal dependencies, fast performance

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "HarshGaur387R/ez-comment-out",
    config = function()
        require("ez-comment-out").setup()
    end
}
```

### Using [packer.nvim](https://github.com/wbthomson/packer.nvim)

```lua
use {
    "HarshGaur387R/ez-comment-out",
    config = function()
        require("ez-comment-out").setup()
    end
}
```

## Quick Start

After installation and setup, use **`Ctrl+_`** or **`Ctrl+/`** (Ctrl+slash behave like Ctrl+undersore) to comment:
User default Undo key (**`u`**) to un-comment

### Normal Mode

- Place cursor on any line
- Press `<C+_>` or `<C+/>` to add comment

### Visual Mode

- Select multiple lines
- Press `<C+_>` to comment all selected lines

## How It Works

### Comment Symbols Configuration

The plugin uses `comments_symbols.json` to define language-specific comment
symbols:

```json
{
    "languages": {
        "lua": {
            "single_line": "--"
        },
        "python": {
            "single_line": "#"
        },
        "javascript": {
            "single_line": "//",
            "multi_line": {
                "start": "/*",
                "end": "*/"
            }
        },
        "html": {
            "multi_line": {
                "start": "<!--",
                "end": "-->"
            }
        }
    }
}
```

### Comment Strategy

1. **Single-line mode** (Normal mode):
   - If single-line comment exists: Prepends symbol + space to line
   - Otherwise: Wraps line with multi-line comment symbols

2. **Multi-line selection** (Visual mode):
   - If multi-line comment exists: Wraps entire selection
   - Otherwise: Applies single-line comment to each line

## File Structure

```
lua/ez-comment-out/
├── init.lua              # Plugin setup and keybindings
├── utils.lua             # Utility functions (file type detection, JSON reading)
├── comments.lua          # Core comment logic
└── comments_symbols.json # Language comment symbol definitions
```

## Configuration

Currently, the plugin works with default settings. Customize comment symbols by
editing `comments_symbols.json`:

```lua
require("ez-comment-out").setup()
```

## Supported Languages

Support depends on configurations in `comments_symbols.json`. Common supported
languages include:

- Lua (`--`)
- Python (`#`)
- JavaScript/TypeScript (`//`, `/* */`)
- HTML/XML (`<!-- -->`)
- C/C++ (`//`, `/* */`)
- And more (add as needed)

## Keybindings

| Mode   | Key                | Action                 |
| ------ | -------------------| ---------------------- |
| Normal | `<C-/>` or `<C-_>` | Comment current line   |
| Visual | `<C-/>` or `<C-_>` | Comment selected lines |

### Custom Keybinding

To customize the keybinding, modify `init.lua` and change `<C-_>` to your
preferred key:

```lua
vim.keymap.set({ 'n' }, '<your-key>', function()
    -- comment logic
end)
```

## FAQ

**Q: Why use `Ctrl+_` instead of `Ctrl+/`?** A: `Ctrl+_` is more reliably
recognized across different terminal configurations.

**Q: Can I add support for a new language?** A: Yes! Add an entry to
`comments_symbols.json` with your language's comment symbols.

**Q: Does it work with uncomment?** A: Currently, it only adds comments.
to uncomment use nvim default undo `u` key.

## TODO

- **CustomConfig** - User can configure commands and add new comment symbols.

## License

MIT

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.
