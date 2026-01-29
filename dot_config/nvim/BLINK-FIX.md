# Fixed: Blink.lua Configuration Error

## Problem

```
Error in /Users/andrzej.skupien/.config/nvim/init.lua:
Failed to load `plugins.blink`

...lazy.nvim/lua/lazy/core/plugin.lua:96: attempt to get length of local 'spec' (a function value)
```

## Root Cause

Lazy.nvim's plugin specification doesn't support **functions** for the `dependencies` field. It expects a **table/array**.

**Bad (caused error):**
```lua
dependencies = function()
    local deps = { "rafamadriz/friendly-snippets" }
    -- ... logic ...
    return deps
end
```

**Good (works):**
```lua
local deps = { "rafamadriz/friendly-snippets" }
-- ... logic ...
dependencies = deps
```

## Solution

Evaluate the AI adapter logic **at module load time** (outside the plugin spec), not inside the spec.

### Before (Broken)

```lua
return {
    "saghen/blink.cmp",
    dependencies = function()  -- ❌ Functions not supported
        local ai_adapter = require("core.ai-adapter")
        local deps = { "rafamadriz/friendly-snippets" }
        if ai_adapter.init() == "copilot" then
            table.insert(deps, "fang2hou/blink-copilot")
        end
        return deps
    end,
    opts = {
        sources = {
            default = function()  -- ❌ May cause issues
                local sources = { "lsp", "path", "snippets", "buffer" }
                if ai_adapter.get_adapter() == "copilot" then
                    table.insert(sources, "copilot")
                end
                return sources
            end,
        },
    },
}
```

### After (Fixed)

```lua
-- Evaluate at module load time (before return statement)
local ai_adapter = require("core.ai-adapter")
local deps = { "rafamadriz/friendly-snippets" }
local default_sources = { "lsp", "path", "snippets", "buffer" }

if ai_adapter.init() == "copilot" then
    table.insert(deps, "fang2hou/blink-copilot")
    table.insert(default_sources, "copilot")
end

return {
    "saghen/blink.cmp",
    dependencies = deps,  -- ✅ Table value
    opts = {
        sources = {
            default = default_sources,  -- ✅ Table value
        },
    },
}
```

## Key Changes

1. **Moved logic outside** - Evaluate before `return` statement
2. **Variables instead of functions** - `deps` and `default_sources` are tables
3. **Conditional insertion** - Same logic, different structure

## Verification

### Test 1: This Laptop (MB-928298.local)

```bash
lua test script:
  Hostname: MB-928298.local
  Current: copilot

  Dependencies:
    1. rafamadriz/friendly-snippets
    2. fang2hou/blink-copilot  ✅

  Sources.default:
    1. lsp
    2. path
    3. snippets
    4. buffer
    5. copilot  ✅
```

### Test 2: Other Laptop (MacBook-Pro.local)

```bash
lua test script:
  Hostname: MacBook-Pro.local
  Current: ollama

  Dependencies:
    1. rafamadriz/friendly-snippets
    (no blink-copilot)  ✅

  Sources.default:
    1. lsp
    2. path
    3. snippets
    4. buffer
    (no copilot)  ✅
```

### Test 3: Neovim Loads Successfully

```bash
$ nvim --headless "+lua print('Testing config load')" +q
Testing config load
✅ No errors
```

## Why This Works

### Module Load Order

1. When Lazy loads `plugins/blink.lua`
2. The file is executed **top to bottom**
3. `local ai_adapter = require("core.ai-adapter")` runs first
4. `local deps = { ... }` evaluates with current hostname
5. `if ai_adapter.init() == "copilot"` checks hostname
6. `table.insert(deps, "blink-copilot")` conditionally adds dependency
7. `return { ... dependencies = deps }` returns **final table**

### Lazy.nvim Receives

```lua
{
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },
    -- On this laptop ^^^^^^^^^^^^^^^^^^^^^^^^^^^ included
    
    -- Or on other laptops:
    dependencies = { "rafamadriz/friendly-snippets" },
    -- Only base dependency ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
}
```

No functions - just plain tables!

## Benefits

1. ✅ **Works with Lazy.nvim** - No plugin spec errors
2. ✅ **Hostname-aware** - Different deps per laptop
3. ✅ **Evaluated once** - At module load, not runtime
4. ✅ **Clean structure** - Clear separation of logic
5. ✅ **Type-safe** - Lazy gets tables, not functions

## Related Files

**Modified:**
- `~/.config/nvim/lua/plugins/blink.lua`
  - Lines 1-8: Evaluate AI adapter at module load
  - Line 14: `dependencies = deps` (table, not function)
  - Line 147: `default = default_sources` (table, not function)

**Unchanged:**
- `~/.config/nvim/lua/core/ai-adapter.lua` - Still works as expected
- `~/.config/nvim/lua/plugins/copilot.lua` - Already uses `cond` correctly
- `~/.config/nvim/lua/plugins/codecompanion.lua` - Already evaluates at module load

## Lesson Learned

**Lazy.nvim Plugin Spec Rules:**
- `dependencies` must be a **table** (array of strings)
- `cond` can be a **function** (returns boolean)
- `config` can be a **function** (runs during setup)
- `opts` can contain **tables** (merged into plugin config)

**When in doubt:** Evaluate at module load time (before `return`), not inside the spec.

## Summary

**Problem:** Functions in `dependencies` field
**Solution:** Evaluate at module load time
**Result:** ✅ Config loads, hostname rules work, all plugins happy

**Neovim now starts without errors!** 🚀
