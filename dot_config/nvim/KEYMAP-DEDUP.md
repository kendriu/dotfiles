# Keymap Deduplication Report

## Summary
Audited all keymaps for duplicates and redundancies. Removed duplicate mappings while keeping the most ergonomic and discoverable options.

## Duplicates Found & Resolved

### 1. ✅ LSP Go-To Commands - DEDUPLICATED
**Issue:** Duplicate mappings for Implementation and Type Definition

**Before:**
- `gI` → Implementation (Neovim default)
- `<leader>ci` → Implementation (custom mapping)
- `gy` → Type Definition (Neovim default)
- `<leader>ct` → Type Definition (custom mapping)

**Resolution:** Removed `<leader>ci` and `<leader>ct`
- **Kept:** `gI` and `gy` (standard Neovim keybindings)
- **Reason:** g-prefix keys are muscle memory for vim users, more ergonomic
- **Files modified:** 
  - `lua/plugins/lsp.lua` (removed keymaps)
  - `lua/plugins/which-key.lua` (removed descriptions)

### 2. ✅ References - KEPT BOTH (Different functionality)
**Mappings:**
- `gR` → Telescope References (UI picker)
- `grr` → Native LSP References (quickfix list)

**Decision:** Keep both
- **Reason:** Different UX - Telescope has fuzzy search, native is faster for quick jumps
- Both serve different workflows

### 3. ✅ Code Actions & Rename - KEPT BOTH (Discoverability)
**Mappings:**
- `gra` → Code Action (Neovim default)
- `<leader>ca` → Code Action (discoverable via which-key)
- `grn` → Rename (Neovim default)
- `<leader>cr` → Rename (discoverable via which-key)

**Decision:** Keep both
- **Reason:** `gr*` for power users, `<leader>c*` for discoverability
- Helps new users learn keybindings via which-key menu

### 4. ✅ Buffer Navigation - KEPT BOTH (Different use cases)
**Mappings:**
- `Tab` / `S-Tab` → Next/Prev Buffer
- `]b` / `[b` → Next/Prev Buffer (Neovim default)

**Decision:** Keep both
- **Reason:** Tab/S-Tab is more ergonomic for frequent switching
- ]b/[b follows bracket navigation pattern (consistent with ]d, ]q, etc.)

### 5. ✅ Find Files - KEPT BOTH (Quick access vs Menu)
**Mappings:**
- `<leader><space>` → Find Files
- `<leader>ff` → Find Files

**Decision:** Keep both
- **Reason:** `<leader><space>` for quick access (most common action)
- `<leader>ff` for discoverability in Find menu

### 6. ✅ Search - KEPT BOTH (Quick access vs Menu)
**Mappings:**
- `<leader>/` → Search in Project
- `<leader>sg` → Search in Project

**Decision:** Keep both
- **Reason:** `<leader>/` for quick access
- `<leader>sg` for discoverability in Search menu

### 7. ✅ Tag Navigation - DOCUMENTED
**Issue:** `]T` and `[T` showed cryptic descriptions (`:tlast`, `:trewind`)

**Fixed:**
- `]T` → "Last Tag"
- `[T` → "First Tag"

**Files modified:** `lua/plugins/which-key.lua`

### 8. ✅ Section Navigation - DOCUMENTED
**Issue:** `]]`, `[[`, `][`, `[]` showed raw vim commands

**Fixed:**
- `]]` → "Next Section"
- `[[` → "Prev Section"
- `][` → "Next Section End"
- `[]` → "Prev Section End"

**Files modified:** `lua/plugins/which-key.lua`

## Final Keymap Inventory

### Buffer Navigation (3 methods - all useful)
- `Tab` / `S-Tab` - Fast switching (most ergonomic)
- `]b` / `[b` - Bracket pattern navigation
- `<leader>b1-5` - Direct buffer access

### LSP Navigation (Neovim defaults - single source of truth)
- `gd` - Definition
- `gD` - Declaration
- `gI` - Implementation ⚠️ (removed duplicate <leader>ci)
- `gy` - Type Definition ⚠️ (removed duplicate <leader>ct)
- `gR` - References (Telescope)
- `gO` - Document Symbols

### LSP Actions (Dual mapping for discoverability)
- `gra` / `<leader>ca` - Code Action
- `grn` / `<leader>cr` - Rename
- `grr` - References (native)
- `gri` - Implementation
- `grt` - Type Definition

### Bracket Navigation (All unique functions)
- `]d` / `[d` - Diagnostics
- `]q` / `[q` - Quickfix
- `]l` / `[l` - Location (treesitter loops override)
- `]b` / `[b` - Buffers (treesitter blocks override)
- `]f` / `[f` - Functions
- `]c` / `[c` - Classes
- `]a` / `[a` - Arguments (treesitter overrides default)
- `]t` / `[t` - TODOs (todo-comments overrides tags)
- `]w` / `[w` - WARNINGs
- `]n` / `[n` - NOTEs
- `]T` / `[T` - Tags (first/last)
- `]]` / `[[` - Sections
- `][` / `[]` - Section ends

## Benefits of Deduplication

1. ✅ **Less confusion** - Clear which key to use for each action
2. ✅ **Faster learning** - Fewer overlapping bindings to remember
3. ✅ **Better muscle memory** - Consistent patterns (g* for LSP, <leader>c* for code)
4. ✅ **Cleaner which-key** - No redundant entries confusing users
5. ✅ **Maintained discoverability** - Kept <leader> alternatives for learning

## Deduplication Strategy

**Removed duplicates when:**
- Same exact functionality from same source
- Less ergonomic alternative existed
- Breaking Neovim conventions

**Kept both when:**
- Different implementations (Telescope vs native)
- Different workflows (quick access vs discoverable menu)
- Teaching aids (gr* + <leader>c* for new users)

## Files Modified

1. `lua/plugins/lsp.lua` - Removed <leader>ci and <leader>ct mappings
2. `lua/plugins/which-key.lua` - Removed duplicate descriptions, fixed cryptic labels

## Verification Commands

```vim
" Check for remaining duplicates:
:nmap gI
:nmap <leader>ci  " Should be empty now

:nmap gy
:nmap <leader>ct  " Should be empty now

" Test deduplicated keymaps work:
gI  " Jump to implementation
gy  " Jump to type definition
```

## Summary Stats

- **Duplicates removed:** 2 (ci, ct)
- **Dual mappings kept:** 4 pairs (ca/gra, cr/grn, <space>/ff, //sg)
- **Cryptic descriptions fixed:** 6 (]T, [T, ]], [[, ][, [])
- **Total keymaps documented:** 100+

**Status:** ✅ Keymap configuration clean and optimized!
