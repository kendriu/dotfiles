# Global AI Adapter System with Automatic Fallback

## Overview

A centralized system that manages AI adapters across **all** Neovim plugins:
- **CodeCompanion** - Chat, inline, agents
- **Blink.cmp** - Code completions
- **Copilot** - LSP-based suggestions

When Copilot hits rate limit, **everything** automatically switches to Ollama!

## Architecture

### Centralized Module: `core/ai-adapter.lua`

Single source of truth for:
- Which adapter to use (Copilot vs Ollama)
- Hostname-based selection
- Fallback triggering
- State management

### Plugin Integration

All AI plugins query the central module:

```
┌─────────────────────────────────┐
│   core/ai-adapter.lua           │
│   (Centralized State)           │
│                                 │
│  - Hostname detection           │
│  - Adapter selection            │
│  - Fallback management          │
└─────────────────────────────────┘
          ↓        ↓        ↓
    ┌─────┴────┐  │  ┌─────┴─────┐
    │          │  │  │           │
┌───▼──┐  ┌───▼──▼──▼───┐  ┌────▼────┐
│Copilot│  │CodeCompanion│  │Blink.cmp│
│  LSP  │  │(Chat/Agent) │  │  (CMP)  │
└───────┘  └─────────────┘  └─────────┘
```

## How It Works

### 1. Startup - Hostname Detection

```lua
-- core/ai-adapter.lua initializes
hostname = "MB-928298.local"
    ↓
preferred_adapter = "copilot"
current_adapter = "copilot"
```

### 2. Normal Operation - All Use Copilot

```lua
-- Copilot plugin loads (cond = true)
-- Blink includes "copilot" source
-- CodeCompanion uses "copilot" adapter
```

### 3. Rate Limit Hit - Automatic Fallback

```lua
User: <leader>AC (commit message)
    ↓
CodeCompanion → Copilot API
    ↓
❌ Rate limit error detected
    ↓
ai_adapter.trigger_fallback()
    ↓
┌─────────────────────────────────┐
│ 1. Update state                 │
│    current_adapter = "ollama"   │
│                                 │
│ 2. Disable Copilot              │
│    vim.g.copilot_enabled = false│
│                                 │
│ 3. Update CodeCompanion         │
│    All strategies → "ollama"    │
│                                 │
│ 4. Notify user                  │
│    ⚠️  Rate limit!              │
│    ℹ️  Switched to Ollama       │
└─────────────────────────────────┘
```

### 4. Subsequent Operations - All Use Ollama

```lua
-- Copilot disabled (vim.g.copilot_enabled = false)
-- Blink no longer shows copilot completions
-- CodeCompanion uses Ollama
```

## Affected Features

### Before Rate Limit (Using Copilot)

| Feature | Source | Status |
|---------|--------|--------|
| Inline completions | Copilot + Blink | ✅ Active |
| Chat (`<leader>Ac`) | CodeCompanion + Copilot | ✅ Active |
| Commit (`<leader>AC`) | CodeCompanion + Copilot | ✅ Active |
| Review (`<leader>Av`) | CodeCompanion + Copilot | ✅ Active |

### After Rate Limit (Using Ollama)

| Feature | Source | Status |
|---------|--------|--------|
| Inline completions | LSP only (no Copilot) | ⚠️ Degraded |
| Chat (`<leader>Ac`) | CodeCompanion + Ollama | ✅ Active |
| Commit (`<leader>AC`) | CodeCompanion + Ollama | ✅ Active |
| Review (`<leader>Av`) | CodeCompanion + Ollama | ✅ Active |

**Note:** Inline completions degrade because Ollama doesn't provide completion suggestions like Copilot does. You still get LSP completions, just not AI-powered ones.

## Code Changes

### 1. New Central Module

**File:** `~/.config/nvim/lua/core/ai-adapter.lua`

```lua
-- Centralized AI adapter management
local M = {}

M.state = {
    hostname = vim.fn.hostname(),
    preferred_adapter = nil,
    current_adapter = nil,
    fallback_triggered = false,
}

function M.init()
    if hostname == "MB-928298.local" then
        M.state.preferred_adapter = "copilot"
    else
        M.state.preferred_adapter = "ollama"
    end
    M.state.current_adapter = M.state.preferred_adapter
    return M.state.current_adapter
end

function M.get_adapter()
    -- Returns current adapter
end

function M.trigger_fallback(reason)
    -- Switches everything to Ollama
    M.state.current_adapter = "ollama"
    vim.g.copilot_enabled = false
    -- Update CodeCompanion...
end

function M.is_rate_limit_error(err)
    -- Detects rate limit patterns
end

return M
```

### 2. Updated Copilot Plugin

**File:** `~/.config/nvim/lua/plugins/copilot.lua`

```lua
return {
    "zbirenbaum/copilot.lua",
    cond = function()
        -- Only load if should use Copilot
        local ai_adapter = require("core.ai-adapter")
        return ai_adapter.init() == "copilot"
    end,
    config = function()
        require("copilot").setup({ ... })
        vim.g.copilot_enabled = true
    end,
}
```

**Key:** `cond` prevents loading on non-Copilot laptops

### 3. Updated Blink Plugin

**File:** `~/.config/nvim/lua/plugins/blink.lua`

```lua
return {
    "saghen/blink.cmp",
    dependencies = function()
        local deps = { "rafamadriz/friendly-snippets" }
        local ai_adapter = require("core.ai-adapter")
        if ai_adapter.init() == "copilot" then
            table.insert(deps, "fang2hou/blink-copilot")
        end
        return deps
    end,
    opts = {
        sources = {
            default = function()
                local sources = { "lsp", "path", "snippets", "buffer" }
                local ai_adapter = require("core.ai-adapter")
                if ai_adapter.get_adapter() == "copilot" then
                    table.insert(sources, "copilot")
                end
                return sources
            end,
        },
    },
}
```

**Key:** Dynamically includes/excludes copilot source

### 4. Updated CodeCompanion Plugin

**File:** `~/.config/nvim/lua/plugins/codecompanion.lua`

```lua
config = function()
    local ai_adapter = require("core.ai-adapter")
    local adapter = ai_adapter.get_adapter()
    
    require("codecompanion").setup({
        strategies = {
            chat = { adapter = adapter },
            inline = { adapter = adapter },
            agent = { adapter = adapter },
        },
        adapters = {
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {
                    callbacks = {
                        on_error = function(err)
                            if ai_adapter.is_rate_limit_error(err) then
                                ai_adapter.trigger_fallback("Copilot rate limit!")
                            end
                        end,
                    },
                })
            end,
        },
    })
end
```

**Key:** Uses centralized adapter and triggers centralized fallback

### 5. New User Command

**File:** `~/.config/nvim/lua/core/autocmd.lua`

```lua
vim.api.nvim_create_user_command("AIStatus", function()
    local ai_adapter = require("core.ai-adapter")
    local status = ai_adapter.status()
    
    vim.notify(string.format(
        "AI Adapter Status:\n" ..
        "  Hostname: %s\n" ..
        "  Preferred: %s\n" ..
        "  Current: %s\n" ..
        "  Fallback triggered: %s",
        status.hostname,
        status.preferred,
        status.current,
        status.fallback_triggered and "YES" or "NO"
    ), vim.log.levels.INFO)
end, { desc = "Show AI adapter status" })
```

## Usage

### Check Current Status

```vim
:AIStatus
```

Output:
```
AI Adapter Status:
  Hostname: MB-928298.local
  Preferred: copilot
  Current: copilot
  Fallback triggered: NO
```

After rate limit:
```
AI Adapter Status:
  Hostname: MB-928298.local
  Preferred: copilot
  Current: ollama
  Fallback triggered: YES
```

### Observe Fallback

**Normal operation:**
```bash
# Type code, see Copilot suggestions inline
print(|)  # ← Copilot suggests completions

<leader>AC
# Uses Copilot for commit message
```

**After rate limit:**
```
<leader>AC

⚠️  AI: Copilot rate limit hit! - Switching to Ollama (qwen2.5:14b-instruct)
ℹ️  AI: Switched to Ollama. Restart your last command to use local AI.

# Retry
<leader>AC
# Now uses Ollama

# Type code - no more Copilot inline suggestions
print(|)  # ← Only LSP completions, no AI

:AIStatus
# Shows: Current: ollama, Fallback triggered: YES
```

## Benefits

1. ✅ **Global fallback** - All AI features switch together
2. ✅ **Consistent behavior** - Single source of truth
3. ✅ **Clean architecture** - Centralized state management
4. ✅ **Easy debugging** - `:AIStatus` command
5. ✅ **Automatic** - No manual intervention needed
6. ✅ **Smart loading** - Copilot only loads where needed

## Limitations

### Inline Completions Degrade

When fallen back to Ollama:
- ✅ CodeCompanion chat/commit/review work perfectly
- ⚠️ Inline completions stop (Ollama doesn't provide them)
- ✅ LSP completions still work (method names, types, etc.)

**Why?**
- Copilot provides real-time inline suggestions
- Ollama is designed for chat-based interactions
- No direct replacement for inline completion API

### One-Way Per Session

- Copilot → Ollama ✅ (automatic on rate limit)
- Ollama → Copilot ❌ (requires restart)

**Why?**
- Gives rate limit time to reset
- Prevents thrashing
- Simple, predictable behavior

## Testing

### Test on This Laptop (Copilot)

```vim
:AIStatus
" Should show: Preferred: copilot, Current: copilot

" Type code - should see Copilot suggestions
" Use <leader>AC - should use Copilot
```

### Test on Other Laptop (Ollama)

```vim
:AIStatus
" Should show: Preferred: ollama, Current: ollama

" No Copilot suggestions (plugin won't even load)
" Use <leader>AC - should use Ollama
```

### Simulate Fallback (Manual)

```vim
:lua require("core.ai-adapter").trigger_fallback("Testing!")

:AIStatus
" Should show: Current: ollama, Fallback triggered: YES

" Copilot inline suggestions should stop
" CodeCompanion commands should use Ollama
```

## Debugging

### Check Copilot Enabled Status

```vim
:lua print(vim.g.copilot_enabled)
" true = Copilot active
" false = Copilot disabled (fallback triggered)
```

### Check CodeCompanion Adapter

```vim
:lua print(require("codecompanion").config.strategies.chat.adapter)
" copilot = Using Copilot
" ollama = Using Ollama (may have fallen back)
```

### Check Blink Sources

```vim
:lua vim.print(require("blink.cmp").config.sources.default())
" Should include "copilot" if using Copilot
" Should NOT include "copilot" after fallback
```

## Files Modified

1. **Created:** `~/.config/nvim/lua/core/ai-adapter.lua` - Central state management
2. **Modified:** `~/.config/nvim/lua/plugins/copilot.lua` - Conditional loading
3. **Modified:** `~/.config/nvim/lua/plugins/blink.lua` - Dynamic source selection
4. **Modified:** `~/.config/nvim/lua/plugins/codecompanion.lua` - Uses central adapter
5. **Modified:** `~/.config/nvim/lua/core/autocmd.lua` - Added `:AIStatus` command

## Summary

**Single System, All Plugins:**
- One module controls everything
- All plugins query central state
- Rate limit triggers global fallback
- Status command for debugging

**Graceful Degradation:**
- CodeCompanion: Copilot → Ollama (works perfectly)
- Completions: Copilot → LSP only (still functional)
- All features continue working, just different backends

**Smart Loading:**
- Copilot only loads on MB-928298.local
- Other laptops skip Copilot entirely
- Same config, different behavior

**You're always covered!** ☁️ → 💻
