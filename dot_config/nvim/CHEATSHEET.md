

# Neovim Workflow Quick Reference

> **📝 Note:** Keybindings were reorganized on 2026-01-28. See [MIGRATION-KEYBINDINGS.md](./MIGRATION-KEYBINDINGS.md) for changes.

## 🎯 Harpoon2 - Fast File Navigation

**Core Concept**: Mark files you're actively working on, switch instantly with 1-2 keystrokes.

### Keybindings
- `<leader>a` - **Add** current file to harpoon list
- `<leader>e` - **Toggle** harpoon menu (view/reorder marks)
- `<C-1>` - Jump to file **1**
- `<C-2>` - Jump to file **2**
- `<C-3>` - Jump to file **3**
- `<C-4>` - Jump to file **4**
- `<C-S-P>` - **Previous** file in harpoon list
- `<C-S-N>` - **Next** file in harpoon list

### Workflow Example
```
Working on a feature:
1. Open UserService.ts → Press <leader>a (mark it)
2. Open UserService.test.ts → Press <leader>a (mark it)
3. Open types.ts → Press <leader>a (mark it)

Now switch instantly:
- <C-1> → UserService.ts
- <C-2> → UserService.test.ts
- <C-3> → types.ts
```

### Tips
- Mark your "working set" (3-5 files you're actively editing)
- Use `<leader>e` to reorder files in the harpoon menu
- Marks are project-scoped (each project has its own list)
- Still use fuzzy finder for exploration, harpoon for active work

---

## 💻 Toggleterm - Terminal Integration

**Core Concept**: Quick access to floating terminals without leaving neovim.

### Quick Toggle
- `<C-\>` - **Toggle** floating terminal (works in normal, insert, and terminal mode)

### Terminal Types
- `<leader>tf` - **Float** terminal (large floating window)
- `<leader>th` - **Horizontal** terminal (bottom split)
- `<leader>tv` - **Vertical** terminal (side split)
- `<leader>tt` - **Tab** terminal (new tab)

### Specialized Terminals
- `<leader>tg` - **Lazygit** (git TUI in floating terminal)
- `<leader>tp` - **Python** REPL
- `<leader>tn` - **Node** REPL

### Terminal Mode Navigation
When in terminal mode:
- `<Esc>` or `jk` - Exit terminal mode (back to normal mode)
- `<C-h/j/k/l>` - Navigate between splits (works in terminal)
- `<C-w>` - Window commands prefix

### Tips
- Use `<C-\>` to quickly toggle terminal for running commands
- Exit terminal mode with `<Esc>`, navigate normally, press `i` to go back
- Terminal state persists when you toggle it off
- Multiple terminals can run simultaneously

---

## 🌳 Treesitter Text Objects

**Core Concept**: Select and manipulate code structures intelligently (functions, classes, parameters, etc.).

### Text Objects (Visual/Operator Mode)
**Functions:**
- `af` - **Around function** (includes function signature)
- `if` - **Inside function** (function body only)

**Classes:**
- `ac` - **Around class** (includes class definition)
- `ic` - **Inside class** (class body only)

**Arguments/Parameters:**
- `aa` - **Around argument** (includes comma)
- `ia` - **Inside argument** (argument only)

**Blocks:**
- `ab` - **Around block** (includes braces)
- `ib` - **Inside block** (block content only)

**Conditionals & Loops:**
- `ao` - **Around conditional** (if/else)
- `io` - **Inside conditional**
- `al` - **Around loop** (for/while)
- `il` - **Inside loop**

**Comments:**
- `a/` - **Around comment**
- `i/` - **Inside comment**

### Navigation
**Functions:**
- `]f` - Jump to **next function** start
- `[f` - Jump to **previous function** start
- `]F` - Jump to **next function** end
- `[F` - Jump to **previous function** end

**Classes:**
- `]c` - Jump to **next class**
- `[c` - Jump to **previous class**
- `]C` / `[C` - Next/previous class end

**Arguments:**
- `]a` - Jump to **next argument**
- `[a` - Jump to **previous argument**
- `]A` / `[A` - Next/previous argument end

**Loops:**
- `]l` - Jump to **next loop** start
- `[l` - Jump to **previous loop** start

**Conditionals:**
- `]o` - Jump to **next conditional** start
- `[o` - Jump to **previous conditional** start

**Blocks:**
- `]b` - Jump to **next block** start
- `[b` - Jump to **previous block** start

### Peek Definition
- `<leader>pf` - **Peek function** definition
- `<leader>pc` - **Peek class** definition

### Common Operations

**Select & Edit:**
```
vif    - Visual select inside function
daf    - Delete entire function
cic    - Change inside class
yaa    - Yank argument (with comma)
```

**Navigate:**
```
]f]f   - Jump to second next function
[f     - Jump to previous function
]c     - Jump to next class
```

**Quick Edits:**
```
dif    - Delete function body
cif    - Change function body
yaf    - Yank entire function
vac    - Select entire class
```

**Swap Parameters:**
```
<leader>xn - Swap argument with next
<leader>xp - Swap argument with previous
<leader>xm - Swap function with next
<leader>xM - Swap function with previous
```

### Use Cases

**Refactoring Functions:**
```
1. Position cursor in function
2. dif (delete inside function)
3. Type new implementation
4. Or: vif to select, then paste
```

**Extracting Code:**
```
1. vib (select inside block)
2. y (yank)
3. ]f (jump to next function)
4. p (paste)
```

**Reordering Arguments:**
```
Function: foo(arg1, arg2, arg3)
1. Place cursor on arg2
2. <leader>xn (swap with next)
Result: foo(arg1, arg3, arg2)
```

**Quick Navigation:**
```
Reviewing code:
- ]f to jump between functions
- ]c to jump between classes
- ]a to review each parameter
```

### Tips
- Works with most languages (Python, JS, Rust, Go, etc.)
- Lookahead enabled (jumps forward to next text object)
- Combine with operators: d (delete), c (change), y (yank), v (visual)
- Use with flash: vif then s to jump within selection
- Repeatable with . (dot command)

### Language Support
Supported: Python, JavaScript, TypeScript, Rust, Go, Lua, C/C++, Java, Ruby, and many more. Auto-installs parsers as needed.

---

## ⚡ Flash.nvim - Enhanced Motion/Jumping

**Core Concept**: Jump to any visible location with 2-3 keystrokes using smart labels.

### Basic Flash
- `s` - **Flash jump** (type characters, see labels, press label to jump)
- `S` - **Flash treesitter** (jump to treesitter nodes: functions, classes, etc.)

### How Flash Works
1. Press `s` in normal mode
2. Type 1-2 characters of your target location
3. Labels appear over all matches
4. Press the label key to jump there instantly

### Advanced Flash
- `<leader>fw` - Flash to **word** under cursor (all occurrences)
- `<leader>fj` - Flash **jump to line** start
- `r` (operator mode) - **Remote** flash (e.g., `dr` then flash = delete to target)
- `R` (visual/operator) - **Treesitter search** 

### In Command Mode
- `<C-s>` - **Toggle** flash in search mode

### Examples
```
Want to jump to "const" 5 lines down?
1. Press 's'
2. Type 'co' 
3. See labels appear over all 'co' matches
4. Press the label (like 'a' or 'f')
5. You're there!

Delete to a target:
1. Press 'd' (delete)
2. Press 'r' (remote flash)
3. Type characters + label
4. Text deleted to that point

Select a function:
1. Press 'S' (treesitter flash)
2. Labels appear over functions/classes
3. Press label to select the function
```

### Tips
- Flash is faster than word search for visible targets
- Use `S` to quickly select code blocks
- Replaces EasyMotion/Hop with modern Lua implementation
- Works across all visible windows

---

## 🔍 Existing Navigation (Snacks.nvim)

### File Finding
- `<leader><space>` - **Smart** find files
- `<leader>ff` - **Find** files
- `<leader>fg` - Find **git** files
- `<leader>fr` - Find **recent** files
- `<leader>fc` - Find **config** files
- `<leader>fb` - Find **buffers**

### Searching
- `<leader>/` or `<leader>sg` - **Grep** (search in files)
- `<leader>sw` - Search **word** under cursor
- `<leader>sb` - Search **buffer** lines
- `<leader>sB` - Search open **buffers**

### LSP Navigation
- `gd` - **Go to Definition**
- `gD` - **Go to Declaration**
- `gR` - **References**
- `gI` - **Go to Implementation**
- `gy` - **Go to Type** definition
- `<leader>ss` - **LSP Symbols** (current file)
- `<leader>sS` - **LSP Symbols** (workspace)

### File Explorer
- `<leader><Tab>` - **Toggle** file explorer
- `\` - **Reveal** current file in explorer

---

## 📝 Buffer Management

### Navigation
- `<Tab>` - **Next** buffer
- `<S-Tab>` - **Previous** buffer
- `<leader>fb` - **Find** buffer (picker)

### Actions
- `<leader>bb` - New **blank** buffer
- `<leader>bd` - **Delete** buffer
- `<leader>bo` - Delete **other** buffers

---

## 📝 Buffer Management

### Navigation
- `<Tab>` - **Next** buffer
- `<S-Tab>` - **Previous** buffer
- `<leader>fb` - **Find** buffer (picker)
- `<leader>bj` - **Pick** buffer (interactive jump)
- `<leader>b1-5` - Jump to buffer **1-5**
- `<leader>bf` - **First** buffer
- `<leader>bl` - **Last** buffer

### Actions
- `<leader>bb` - New **blank** buffer
- `<leader>bd` - **Delete** current buffer
- `<leader>bo` - Delete **other** buffers (snacks)
- `<leader>bc` - **Close other** buffers (all except current)
- `<leader>bC` - Close buffers to **right**

### Organization
- `<leader>bp` - **Pin** current buffer
- `<leader>bP` - Close **unpinned** buffers
- `<leader>bs` - **Sort** by directory
- `<leader>bS` - **Sort** by extension
- `<leader>bm>` - **Move** buffer right
- `<leader>bm<` - **Move** buffer left

### Features
- **Diagnostics** shown in bufferline (error/warning icons)
- **Modified** indicator (● dot)
- **Pin** important buffers (won't be closed with mass operations)
- **Pick mode** - interactive buffer selection

### Workflows

**Managing Many Buffers:**
```
1. Pin important files: <leader>bp
2. Work on various files
3. Clean up: <leader>bP (close unpinned)
4. Or: <leader>bc (close others)
```

**Quick Navigation:**
```
Tab/S-Tab     - Cycle through buffers
<leader>b1    - Jump to first buffer
<leader>b3    - Jump to third buffer
<leader>bj    - Pick buffer interactively
```

**Organization:**
```
<leader>bs    - Sort by directory (group by project)
<leader>bS    - Sort by extension (group by type)
<leader>bm>   - Move important buffer forward
```

### Tips
- Pin buffers you reference frequently
- Use `<leader>bj` for quick visual selection
- Sort by directory when working on related files
- Diagnostics in bufferline help spot issues
- Tab/S-Tab is fastest for adjacent buffers

---

## 🤖 AI Assistant (CodeCompanion)

CodeCompanion provides AI-powered coding assistance using GitHub Copilot.

### Keybindings
- `<leader>Ac` - **Toggle** chat window
- `<leader>An` - **New** chat
- `<leader>Aa` - **Action** palette (context-aware actions)
- `<leader>Ai` - **Inline** prompt (type your request)
- `<leader>Am` - **Model/Strategy** selection
- `<leader>Ar` - **Run** on selection (visual mode)
- `gA` - **Add** selection to chat (visual mode)

### Usage Tips
- Use chat for complex questions and refactoring
- Inline prompts for quick code generation
- Visual selection + `gA` to add context to ongoing chat

---

## 📑 Tabs

Manage vim tabs for different workspaces.

### Keybindings  
- `<leader>To` - **Open** new tab
- `<leader>Tx` - **Close** current tab
- `<leader>Tn` - **Next** tab
- `<leader>Tp` - **Previous** tab

> **Note:** Use capital `T` - lowercase `<leader>t` is for Terminal commands!

---

## 📋 Clipboard Operations

Interact with system clipboard (works across applications).

### Keybindings
- `<leader>y` - **Yank** to clipboard (normal/visual)
- `<leader>p` - **Paste** from clipboard

### Usage
- Yank in neovim with `<leader>y`, paste anywhere (browser, terminal)
- Copy from anywhere, paste in neovim with `<leader>p`

---

## 🔧 UI Toggles

Quick toggles for editor features.

### Keybindings
- `<leader>un` - **Dismiss** all notifications
- `<leader>uw` - **Toggle** line wrap
- `<leader>us` - **Toggle** spell check
- `<leader>ul` - **Toggle** line numbers
- `<leader>ur` - **Toggle** relative line numbers
- `<leader>uh` - **Toggle** inlay hints

### Tips
- All toggles are under `<leader>u` (UI/Toggles group)
- Changes persist for current session
- Use Which-Key (`<leader>u` + wait) to discover all toggles

---

## 🪟 Window Management

### Splits
- `<leader>v` - Split **vertically**
- `<leader>h` - Split **horizontally**
- `<leader>se` - Make splits **equal** size
- `<leader>xs` - Close **split**

### Navigation
- `<C-h>` - Go to **left** window
- `<C-j>` - Go to **down** window
- `<C-k>` - Go to **up** window
- `<C-l>` - Go to **right** window

### Resize
- `<Up>` - Decrease height
- `<Down>` - Increase height
- `<Left>` - Decrease width
- `<Right>` - Increase width

---

---

## 📋 Quickfix List (nvim-bqf)

**Core Concept**: Enhanced quickfix list with preview, filtering, and better navigation.

### Opening Quickfix
- `<leader>ll` - **Toggle** quickfix list
- `<leader>lo` - **Open** quickfix list
- `<leader>lc` - **Close** quickfix list
- `<leader>ld` - Send **diagnostics** to quickfix
- `<leader>lL` - Open **location list** (window-local)
- `]q` / `[q` - **Next/Previous** quickfix item

### Inside Quickfix List
- `<Tab>` / `<S-Tab>` - Navigate down/up
- `p` - Toggle **preview** for current item
- `P` - Toggle **auto-preview** (preview on navigate)
- `o` - Open item (drop)
- `O` - Open item and close quickfix
- `<C-s>` - Open in **split**
- `<C-v>` - Open in **vertical split**
- `t` - Open in new **tab**
- `zf` - **Filter** with fzf
- `zn` - Create new quickfix list with filter
- `<C-p>` / `<C-n>` - Previous/Next **file** in quickfix

### Preview Window
- `<C-u>` / `<C-d>` - Scroll **up/down** in preview
- `zo` - Scroll back to **original** position

### Use Cases
```
1. Search Results:
   - Run :grep or :Snacks.picker.grep()
   - Results populate quickfix
   - Use Tab/S-Tab to navigate with preview
   - Press 'o' to open, 'p' to preview

2. LSP Diagnostics:
   - <leader>ld to send diagnostics to quickfix
   - Navigate with Tab/S-Tab
   - Preview errors without leaving list
   - Filter with 'zf' to focus on specific issues

3. Build/Lint Errors:
   - Compiler errors go to quickfix
   - Preview each error with 'p'
   - Fix and continue with Tab
   - Auto-preview with 'P'
```

### Tips
- Auto-resize adjusts to content
- Preview shows context around match
- Filtering with fzf is incredibly fast
- Works great with LSP references

---

## 🔧 Code Actions & LSP

### Quick Actions
- `<leader>cR` - **Rename** file
- `<leader>ca` - **Code** action (when available)
- `<leader>cr` - **Rename** symbol
- `<leader>cf` - **Format** document

### Diagnostics
- `]d` - **Next** diagnostic
- `[d` - **Previous** diagnostic

---

## 🔄 Refactoring (refactoring.nvim)

**Core Concept**: Advanced code transformations based on treesitter - extract functions, inline variables, and more.

### Extract Operations (Visual Mode)

**Extract Function:**
```
1. Select code block (visual mode)
2. Press <leader>re
3. Enter function name
4. Code extracted to new function
```
- `<leader>re` - **Extract Function** (visual)
- `<leader>rf` - **Extract Function to File** (visual)

**Extract Variable:**
```
1. Select expression (visual mode)
2. Press <leader>rv
3. Enter variable name
4. Expression replaced with variable
```
- `<leader>rv` - **Extract Variable** (visual)

### Inline Operations

**Inline Variable:**
```
1. Place cursor on variable
2. Press <leader>ri
3. Variable usages replaced with value
```
- `<leader>ri` - **Inline Variable** (normal/visual)

### Block Operations (Normal Mode)

**Extract Block:**
```
1. Place cursor in block
2. Press <leader>rb
3. Block extracted to function
```
- `<leader>rb` - **Extract Block**
- `<leader>rbf` - **Extract Block to File**

### Debug Helpers

**Debug Print:**
```
1. Place cursor on variable
2. Press <leader>rp
3. Print statement inserted
```
- `<leader>rp` - **Debug Print** (adds print statement)
- `<leader>rc` - **Cleanup Debug Prints** (removes all)

### Refactoring Menu

**Interactive Selection:**
```
1. Select code or place cursor
2. Press <leader>rs
3. Choose refactoring from menu
```
- `<leader>rs` - **Refactor Menu** (shows all available refactorings)

### Language Support

**Full Support:**
- TypeScript/JavaScript
- Python
- Go
- Rust
- C/C++
- Java
- Lua

**Type Prompting:**
- Go, Java, C/C++ prompt for return types and parameter types
- Other languages infer types automatically

### Common Workflows

**Extract Complex Logic:**
```typescript
// Before (select lines in visual mode)
const result = data
  .filter(x => x.active)
  .map(x => x.value)
  .reduce((a, b) => a + b, 0)

// Press <leader>re, enter "calculateTotal"

// After
const calculateTotal = (data) => {
  return data
    .filter(x => x.active)
    .map(x => x.value)
    .reduce((a, b) => a + b, 0)
}
const result = calculateTotal(data)
```

**Extract Magic Numbers:**
```python
# Before (select "3.14159")
area = radius * radius * 3.14159

# Press <leader>rv, enter "PI"

# After
PI = 3.14159
area = radius * radius * PI
```

**Inline Unnecessary Variables:**
```javascript
// Before (cursor on 'temp')
const temp = getUserName()
console.log(temp)

// Press <leader>ri

// After
console.log(getUserName())
```

**Debug Workflow:**
```go
// 1. Cursor on 'user'
user := getUser(id)

// Press <leader>rp

// After
user := getUser(id)
fmt.Printf("user = %+v\n", user)

// When done debugging
// Press <leader>rc to remove all debug prints
```

### Tips

- **Extract Function** works on any code block (if statements, loops, etc.)
- **Extract to File** useful for large functions (creates new file)
- **Inline Variable** works on simple assignments and const declarations
- **Debug Helpers** language-aware (uses console.log, print, fmt.Printf, etc.)
- **Refactor Menu** (`<leader>rs`) shows only valid refactorings for current context
- Works with LSP for accurate scope analysis
- Preserves formatting and comments
- Undo-friendly (each refactoring is one undo step)

### Quick Reference

| Operation | Mode | Key | Use Case |
|-----------|------|-----|----------|
| Extract Function | Visual | `<leader>re` | Pull code into new function |
| Extract Function to File | Visual | `<leader>rf` | Create new file with function |
| Extract Variable | Visual | `<leader>rv` | Replace expression with variable |
| Inline Variable | Normal/Visual | `<leader>ri` | Remove variable, inline value |
| Extract Block | Normal | `<leader>rb` | Extract current block |
| Extract Block to File | Normal | `<leader>rbf` | Extract block to new file |
| Debug Print | Normal | `<leader>rp` | Add print statement |
| Cleanup Prints | Normal | `<leader>rc` | Remove all debug prints |
| Refactor Menu | Normal/Visual | `<leader>rs` | Show available refactorings |

---

## 💡 Completion (blink.cmp)

**Core Concept**: Smart, fast completion for code, paths, snippets, and more with LSP integration.

### Keybindings (Insert Mode)

**Show/Hide:**
- `<C-space>` - **Show** completion menu / show documentation
- `<C-e>` - **Hide** menu

**Navigation:**
- `<C-j>` - **Next** item (or `<C-n>` vim standard)
- `<C-k>` - **Previous** item (or `<C-p>` vim standard)

**Accept:**
- `<Tab>` - **Accept** selected item / advance snippet
- `<S-Tab>` - **Backward** in snippet

**Documentation:**
- `<C-f>` - **Scroll docs down**
- `<C-b>` - **Scroll docs up**

**Signature Help:**
- `<C-y>` - **Toggle** function signature help
- `<leader>K` - **Signature** help (LSP, manual trigger in normal mode)

### Features
- **Ghost Text**: Preview completion inline when item selected
- **Auto-brackets**: Functions auto-insert `()` → `print(|)`
- **LSP Sources**: Python (basedpyright, ruff), TypeScript (vtsls), Rust, Lua, etc.
- **Path Completion**: File paths as you type
- **Snippets**: Code templates from friendly-snippets
- **Copilot**: AI suggestions from GitHub Copilot
- **Smart Fuzzy**: Typo-resistant Rust-based matcher

### Completion Sources Priority
1. **Copilot** - AI suggestions (highest priority)
2. **LSP** - Language server completions
3. **Path** - File/directory paths
4. **Snippets** - Code templates
5. **Buffer** - Words from open buffers

### Tips
- Ghost text shows what will be inserted before you accept
- Auto-brackets work for functions: `print` → `print(|)` after Tab
- Documentation pops up automatically after 150ms
- Use `<C-y>` to see function signatures inline
- Copilot suggestions appear with lower priority to avoid interference

---

## 🔧 Legacy Git Actions

### Git
- `<leader>gg` - **Lazygit**
- `<leader>ga` - Git **amend** and push force with lease

---

## ⚡ Quick Tips

### Discovering Keybindings
- **Press `<leader>` and wait** - Which-key popup shows all available commands
- Groups are marked with "+" prefix (e.g., "+ Find", "+ Terminal")
- Icons help identify categories at a glance
- Use `<leader>sk` to search all keymaps

### Daily Workflow
1. Start your session: Mark 3-5 files with harpoon (`<leader>a`)
2. Switch between them instantly with `<C-1/2/3/4>`
3. Need a terminal? Press `<C-\>`
4. Searching for something? Use `<leader>/` (grep)
5. Need a file? Use `<leader><space>` (smart find)

### Muscle Memory Priority
Learn these first (highest impact):
1. `<leader>a` + `<C-1/2/3/4>` - Harpoon workflow
2. `<C-\>` - Quick terminal toggle
3. `<leader><space>` - Smart file finder
4. `<leader>/` - Grep search
5. `gd` - Go to definition

### Optimization Strategy
- **Harpoon** for files you're actively editing (80% of switches)
- **Fuzzy finder** for exploration and one-off file access (20%)
- **Terminal** for running tests, git commands, builds
- **LSP navigation** for understanding code

---

## 📚 Resources

- Harpoon: `:h harpoon`
- Toggleterm: `:h toggleterm`
- View all keymaps: `<leader>sk`
- Toggle harpoon menu: `<leader>e`
- See this file: `~/.copilot/session-state/.../files/CHEATSHEET.md`
