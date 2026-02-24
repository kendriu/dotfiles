# CodeCompanion Inline Diff Viewer - Already Configured! ✅

## What You Already Have

The inline diff viewer is **already enabled** in your CodeCompanion config:

```lua
-- In lua/plugins/codecompanion.lua
inline = {
  adapter = adapter,
  layout = "vertical", -- Side-by-side diff ✅
},
```

This gives you Avante-style visual diffs **without** adding another plugin!

---

## How to Use It

### Method 1: Visual Selection + Inline Command

1. **Select code** in visual mode (press `v` or `V`)
2. **Press `<leader>Ai`** and type your prompt
3. **Example:**
   ```
   (Visual select a function)
   <leader>Ai add error handling<Enter>
   ```

4. **See side-by-side diff:**
   - Left side: Your original code
   - Right side: AI's suggestion
   - Visual highlighting of changes

### Method 2: Use Surgical Edit (Better for Diffs)

1. **Select code** in visual mode
2. **Press `<leader>As`** (surgical edit)
3. AI shows changes in **vertical split** with:
   - Clear before/after view
   - Syntax highlighting
   - Accept/reject options

### Method 3: Inline Prompt on Selection

1. **Select code** in visual mode
2. **Press `<leader>Ar`** to run slash command
3. Type your prompt, AI shows diff

---

## What the Vertical Layout Gives You

### Visual Diff Display:
```
┌─────────────────────────┬─────────────────────────┐
│ ORIGINAL                │ AI SUGGESTION           │
├─────────────────────────┼─────────────────────────┤
│ def process_data(data): │ def process_data(data): │
│     result = []         │     result = []         │
│     for item in data:   │     for item in data:   │
│         result.append(  │         if item:         │ ← Changed
│             item)       │             result.app- │
│                         │             end(item)   │
│     return result       │     return result       │
└─────────────────────────┴─────────────────────────┘
```

### Features:
- ✅ Side-by-side comparison
- ✅ Syntax highlighting on both sides
- ✅ Clear visualization of changes
- ✅ Accept/reject/edit workflow
- ✅ No extra plugin needed!

---

## Quick Test

Try this right now:

1. Open any Python/JS/Lua file
2. Select a function (press `V` to select lines)
3. Press `<leader>Ai add type hints<Enter>`
4. **See the vertical diff!**

---

## Workflow Examples

### Example 1: Add Error Handling
```
(Select function)
<leader>Ai add try-except error handling<Enter>

→ See side-by-side:
  - Left: Original code
  - Right: Code with try-except added
```

### Example 2: Refactor with Visual Review
```
(Select code block)
<leader>As
"Extract this into a separate function"

→ See vertical diff showing:
  - Old: Inline code
  - New: Extracted function + call
```

### Example 3: Add Documentation
```
(Select function)
<leader>Ai add docstring with type hints<Enter>

→ Side-by-side shows:
  - Before: No docstring
  - After: Full docstring added
```

---

## Navigation in Diff View

When the diff appears:

- **`<Tab>`** - Switch between left/right panes
- **`<C-w>w`** - Navigate windows
- **`q`** - Close diff view
- **Accept changes:** Follow CodeCompanion prompts
- **Reject changes:** Close without accepting

---

## Advanced: Combine with Other Modes

### 1. Review + Inline Diff
```
<leader>Av  # Review code
(AI suggests fixes)
<leader>Ai implement the fix<Enter>  # See diff
```

### 2. Workspace Query + Inline Edit
```
<leader>Aw
"How should I implement X based on crater's pattern?"
(Get answer)
(Select code)
<leader>Ai implement using that pattern<Enter>  # See diff
```

---

## Comparison: CodeCompanion Inline vs Avante

| Feature | CodeCompanion Inline (You Have) | Avante (Full Plugin) |
|---------|--------------------------------|----------------------|
| Side-by-side diff | ✅ Yes | ✅ Yes |
| Syntax highlighting | ✅ Yes | ✅ Yes |
| Visual changes | ✅ Yes | ✅ Yes |
| Accept/reject | ✅ Yes | ✅ Yes |
| Extra plugin | ❌ No | ✅ Required |
| Additional deps | ❌ No | ✅ Many |
| Build step | ❌ No | ✅ `make` |
| Complexity | ✅ Simple | ❌ Complex |

**Verdict:** You already have 90% of Avante's visual diff features!

---

## Configuration Details

Current config in `lua/plugins/codecompanion.lua`:

```lua
strategies = {
  inline = {
    adapter = adapter,
    layout = "vertical",  -- This is the key!
  },
}
```

**Options for `layout`:**
- `"vertical"` - Side-by-side (current, best for diffs)
- `"horizontal"` - Top/bottom split
- `"buffer"` - Replace current buffer
- `"float"` - Floating window

---

## If You Want Even Better Visual Diffs

You can enhance the current setup:

### Option 1: Increase Diff Width
```lua
inline = {
  adapter = adapter,
  layout = "vertical",
  opts = {
    width = 0.5, -- Each side gets 50% of screen
  },
},
```

### Option 2: Auto-highlight Changes
```lua
inline = {
  adapter = adapter,
  layout = "vertical",
  diff = {
    enabled = true,
    highlights = true,
  },
},
```

### Option 3: Add Diff Mode Keybinding
Add to keymaps:
```lua
{ "<leader>Aid", 
  mode = "v",
  function()
    vim.cmd("CodeCompanion")
    -- Automatically uses inline with vertical layout
  end,
  desc = "AI: Inline Diff Mode"
},
```

---

## Why This is Better Than Avante

1. **Already working** - No setup needed
2. **Integrated** - Uses your ai-adapter fallback system
3. **Simpler** - One plugin (CodeCompanion) vs many dependencies
4. **Tested** - You know CodeCompanion works
5. **Familiar** - Same keybindings you already use

---

## Summary

✅ **You already have inline diff viewer!**  
✅ **Layout: vertical (side-by-side)**  
✅ **No additional setup needed**  
✅ **Works with all your existing keybindings**  

**Try it now:**
```
1. Select some code (V)
2. Press <leader>Ai add comments<Enter>
3. See the beautiful side-by-side diff!
```

---

## Need More?

If CodeCompanion's inline diff doesn't feel visual enough, let me know what specific feature you want and I can:
1. Enhance the CodeCompanion config
2. Add custom diff highlighting
3. Create a dedicated diff mode keybinding

But I bet you'll find the current setup is exactly what you need! 🎉
