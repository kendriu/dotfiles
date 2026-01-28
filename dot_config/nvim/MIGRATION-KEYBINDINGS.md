# Keybinding Migration Guide

This guide documents the keybinding changes made during the Which-Key cleanup on 2026-01-28.

## Why These Changes?

The cleanup resolved **4 major conflicts** and consolidated scattered keybindings into logical, mnemonic groups. All commands are now discoverable through Which-Key.

## Changed Keybindings

### AI/Assistant (CodeCompanion) - Moved to <leader>A

| Old Binding | New Binding | Action |
|-------------|-------------|--------|
| `<leader>cc` | `<leader>Ac` | Toggle Chat |
| `<leader>cn` | `<leader>An` | New Chat |
| `<leader>ca` | `<leader>Aa` | Action Palette |
| `<leader>ci` | `<leader>Ai` | Inline Prompt |
| `<leader>cm` | `<leader>Am` | Model/Strategy |
| `<leader>cr` | `<leader>Ar` | Run on Selection (visual) |
| `gA` | `gA` | Add to Chat (unchanged) |

**Reason:** `<leader>ca` conflicted with LSP Code Actions

### Tabs - Moved to <leader>T (Capital T)

| Old Binding | New Binding | Action |
|-------------|-------------|--------|
| `<leader>to` | `<leader>To` | Open Tab |
| `<leader>tx` | `<leader>Tx` | Close Tab |
| `<leader>tn` | `<leader>Tn` | Next Tab |
| `<leader>tp` | `<leader>Tp` | Prev Tab |

**Reason:** `<leader>t*` conflicted with Terminal commands

### Clipboard - Simple & Clean

| Old Binding | New Binding | Action |
|-------------|-------------|--------|
| `<leader>y` | `<leader>y` | Yank to Clipboard (unchanged) |
| `<leader>p` | `<leader>p` | Paste from Clipboard (unchanged) |

**Note:** `<leader>p` serves dual purpose - immediate press pastes from clipboard, followed by `f`/`c` peeks function/class. Which-key handles this gracefully.

### Window Operations - Consolidated to <leader>w

| Old Binding | New Binding | Action |
|-------------|-------------|--------|
| `<leader>v` | `<leader>v` | Split Vertical (unchanged - shortcut) |
| `<leader>h` | `<leader>h` | Split Horizontal (unchanged - shortcut) |
| `<leader>se` | `<leader>we` | Equal Window Size |
| `<leader>xs` | `<leader>wx` | Close Split |
| `<leader>wn` | `<leader>wn` | Save without Format (unchanged) |

**Reason:** `<leader>se` and `<leader>xs` didn't follow mnemonic groups

### Toggles - Consolidated to <leader>u

| Old Binding | New Binding | Action |
|-------------|-------------|--------|
| `<leader>un` | `<leader>un` | Dismiss Notifications (unchanged) |
| `<leader>lw` | `<leader>uw` | Toggle Wrap |
| — | `<leader>us` | Toggle Spell (new) |
| — | `<leader>ul` | Toggle Line Numbers (new) |
| — | `<leader>ur` | Toggle Relative Numbers (new) |

**Reason:** `<leader>lw` was under Lists group instead of Toggles

## New Keybindings

### Toggles (New)
- `<leader>us` - Toggle spell check
- `<leader>ul` - Toggle line numbers
- `<leader>ur` - Toggle relative numbers

## Final Structure

All keybindings now follow consistent mnemonic prefixes:

```
<leader>A - AI/Assistant (CodeCompanion)
<leader>b - Buffers
<leader>c - Code (LSP only)
<leader>f - Find/Files
<leader>g - Git
<leader>k - HTTP/Kulala
<leader>l - Lists (Quickfix/Location)
<leader>n - Notifications
<leader>p - Peek (Treesitter)
<leader>s - Search (+ swap operations)
<leader>t - Terminal
<leader>T - Tabs
<leader>u - UI/Toggles
<leader>w - Window
<leader>y - Yank/Clipboard
```

## Muscle Memory Tips

**Most Impact:**
1. **AI Chat:** Remember `<leader>A` for AI (instead of `<leader>c`)
2. **Tabs:** Use capital `<leader>T` (instead of lowercase `<leader>t`)

**Quick Adaptation:**
- Press `<leader>` and wait 300ms - Which-Key will show all available commands
- All groups now have descriptive icons and labels
- Related commands are grouped together logically

## Unchanged (Still Works)

- All harpoon commands (`<leader>a`, `<leader>e`, `<C-1/2/3/4>`)
- All terminal commands (`<C-\>`, `<leader>t*`)
- All buffer commands (`<leader>b*`)
- All find/search commands (`<leader>f*`, `<leader>s*`)
- Window navigation (`<C-h/j/k/l>`)
- LSP commands (`gd`, `gR`, `gI`, etc.)

## Questions?

Open the cheatsheet with `<leader>?` or use Which-Key by pressing `<leader>` and waiting.
