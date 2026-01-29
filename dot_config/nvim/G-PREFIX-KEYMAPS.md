# Complete g-prefix Keymap Descriptions

## Summary

Added which-key descriptions for all `g` prefix keymaps that were missing labels.

## Keymaps Added

### LSP Navigation (already existed, verified complete)
- `gd` - Go to Definition
- `gD` - Go to Declaration
- `gR` - References
- `gI` - Go to Implementation
- `gy` - Go to Type Definition
- `gO` - Document Symbols ✅ NEW

### LSP Actions (gr group)
- `gr` - Group: LSP
- `gra` - Code Action (normal + visual) ✅ FIXED
- `grn` - Rename
- `grr` - References
- `gri` - Implementation
- `grt` - Type Definition

### Comment Operations ✅ NEW
- `gc` - Toggle Comment (normal + visual)
- `gcc` - Toggle Comment Line (normal)

### Open URL/File ✅ NEW
- `gx` - Open URL/File (normal + visual)

### AI Assistant (already existed)
- `gA` - Add to AI Chat (visual)

## Before & After

### Before
```
When pressing 'g', which-key showed:
  A  → Add to AI Chat  ✅
  d  → Go to Definition  ✅
  D  → Go to Declaration  ✅
  R  → References  ✅
  I  → Go to Implementation  ✅
  y  → Go to Type Definition  ✅
  O  → (no description)  ❌
  c  → (no description)  ❌
  cc → (no description)  ❌
  x  → (no description)  ❌
  
  r  → LSP group  ✅
    a → Code Action (only normal)  ⚠️
    n → Rename  ✅
    r → References  ✅
    i → Implementation  ✅
    t → Type Definition  ✅
```

### After
```
When pressing 'g', which-key shows:
  A  → Add to AI Chat  ✅
  d  → Go to Definition  ✅
  D  → Go to Declaration  ✅
  R  → References  ✅
  I  → Go to Implementation  ✅
  y  → Go to Type Definition  ✅
  O  → Document Symbols  ✅
  c  → Toggle Comment  ✅
  cc → Toggle Comment Line  ✅
  x  → Open URL/File  ✅
  
  r  → LSP group  ✅
    a → Code Action (normal + visual)  ✅
    n → Rename  ✅
    r → References  ✅
    i → Implementation  ✅
    t → Type Definition  ✅
```

## Complete g-prefix Keymap Reference

### Navigation
| Keymap | Mode | Description | Function |
|--------|------|-------------|----------|
| `gd` | n | Go to Definition | LSP definition |
| `gD` | n | Go to Declaration | LSP declaration |
| `gR` | n | References | LSP references |
| `gI` | n | Go to Implementation | LSP implementation |
| `gy` | n | Go to Type Definition | LSP type definition |
| `gO` | n | Document Symbols | LSP document symbols |

### LSP Actions (gr*)
| Keymap | Mode | Description | Function |
|--------|------|-------------|----------|
| `gra` | n, v | Code Action | LSP code action |
| `grn` | n | Rename | LSP rename symbol |
| `grr` | n | References | LSP references |
| `gri` | n | Implementation | LSP implementation |
| `grt` | n | Type Definition | LSP type definition |

### Comment
| Keymap | Mode | Description | Function |
|--------|------|-------------|----------|
| `gc` | n, v | Toggle Comment | Comment operator |
| `gcc` | n | Toggle Comment Line | Comment current line |

### Utilities
| Keymap | Mode | Description | Function |
|--------|------|-------------|----------|
| `gx` | n, v | Open URL/File | Open with system handler |
| `gA` | v | Add to AI Chat | CodeCompanion add selection |

## Usage Examples

### LSP Navigation
```python
def hello():  # Cursor here
    pass

# gd  → Go to definition of 'hello'
# gD  → Go to declaration
# gR  → Find all references
# gI  → Go to implementation
# gy  → Go to type definition
# gO  → Show document symbols picker
```

### LSP Actions (gr prefix)
```python
def hello():  # Cursor here
    pass

# gra → Show code actions (normal mode)
# grn → Rename 'hello'
# grr → Find references
# gri → Go to implementation
# grt → Go to type definition

# Visual mode:
# Select code, then gra → Code actions for selection
```

### Comment
```python
def hello():
    print("hi")  # Cursor here
    
# gcc → Toggle comment on this line
# gc + motion → Comment with motion (e.g., gcip = comment paragraph)

# Visual mode:
# Select lines, gc → Toggle comment on selection
```

### Open URL/File
```markdown
Visit [GitHub](https://github.com)
Click the link: https://example.com
Open file: /path/to/file.txt

# Cursor on URL or file path
# gx → Opens in browser or file explorer
```

### AI Assistant
```python
def buggy_code():
    # Select this code in visual mode
    result = x + y
    return result

# Select code in visual, then gA
# → Adds selection to CodeCompanion chat for discussion
```

## File Modified

**File:** `~/.config/nvim/lua/plugins/which-key.lua`

**Changes:**
```lua
-- LSP (when available)
{ "gO", desc = "Document Symbols", icon = "" },  -- Added

-- LSP gr* keymaps
{ "gra", desc = "Code Action", icon = "", mode = { "n", "v" } },  -- Added visual mode

-- Comment (Neovim defaults) - NEW SECTION
{ "gc", desc = "Toggle Comment", icon = "󰆉", mode = { "n", "v" } },
{ "gcc", desc = "Toggle Comment Line", icon = "󰆉" },

-- Open URL/File - NEW SECTION
{ "gx", desc = "Open URL/File", icon = "", mode = { "n", "v" } },
```

## Benefits

1. ✅ **Complete coverage** - All `g` prefix keymaps now labeled
2. ✅ **Consistent descriptions** - Clear, concise labels
3. ✅ **Mode awareness** - Shows which modes each keymap works in
4. ✅ **Better discoverability** - Press `g` and see everything
5. ✅ **Proper grouping** - `gr` group for LSP actions
6. ✅ **Visual mode support** - `gra` and `gc` work in visual mode

## Quick Reference Card

```
g - Prefix for "Go to" and general operations
│
├─ Navigation (LSP)
│  ├─ d  → Definition
│  ├─ D  → Declaration
│  ├─ R  → References
│  ├─ I  → Implementation
│  ├─ y  → Type definition
│  └─ O  → Document symbols
│
├─ LSP Actions (r prefix)
│  ├─ ra → Code action
│  ├─ rn → Rename
│  ├─ rr → References
│  ├─ ri → Implementation
│  └─ rt → Type definition
│
├─ Comment
│  ├─ c  → Toggle comment (operator)
│  └─ cc → Toggle comment line
│
├─ Utilities
│  ├─ x  → Open URL/file
│  └─ A  → Add to AI chat (visual)
│
└─ Standard Vim
   ├─ g% → Go to matching bracket
   ├─ gg → Top of file
   └─ G  → Bottom of file
```

## Notes

### Neovim Default Keymaps
These are built into Neovim 0.10+:
- `gr*` - LSP actions
- `gc`/`gcc` - Commenting
- `gx` - Open URL/file

### Custom Keymaps (from plugins)
- `gd`, `gD`, `gR`, `gI`, `gy` - Snacks.nvim (LSP picker integration)
- `gA` - CodeCompanion (visual mode only)

### Which-key Enhancement
All these keymaps work without which-key, but which-key adds:
- Visual menu when you pause after pressing `g`
- Descriptions for each option
- Grouping for related actions (like `gr*`)
- Mode indicators (n, v, x, o)

## Summary

**Before:** 4 missing descriptions
**After:** All `g` prefix keymaps documented

**Now when you press `g`, you see a complete, well-organized menu!** 🎯
