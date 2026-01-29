# Hostname-Based Adapter Selection

## Feature
CodeCompanion automatically selects the AI adapter based on the hostname of your laptop!

## Configuration

### Current Setup

| Hostname | Primary Adapter | Fallback | Model |
|----------|----------------|----------|-------|
| `MB-928298.local` | **Copilot** ☁️ | **Ollama** 💻 (on rate limit) | GitHub Copilot → qwen2.5:14b-instruct |
| All others | **Ollama** 💻 | None | qwen2.5:14b-instruct |

### Automatic Fallback (This Laptop Only)

When Copilot hits rate limit on MB-928298.local:
1. ⚠️  Notification: "Copilot rate limit hit!"
2. 🔄 Automatic switch to Ollama
3. ℹ️  Prompt to retry your last command
4. ✅ Continue working with local AI

**No fallback on other laptops** - They already use Ollama by default.

## How It Works

### Detection Code
```lua
-- Determine adapter based on hostname
local hostname = vim.fn.hostname()
local adapter = "ollama" -- Default to ollama

if hostname == "MB-928298.local" then
    adapter = "copilot"
end

require("codecompanion").setup({
    strategies = {
        chat = { adapter = adapter },
        inline = { adapter = adapter },
        agent = { adapter = adapter },
    },
    adapters = {
        ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                schema = {
                    model = {
                        default = "qwen2.5:14b-instruct",
                    },
                },
            })
        end,
    },
})
```

## Usage

### On This Laptop (MB-928298.local)
```bash
# Uses GitHub Copilot
nvim crater/handler.py
<leader>Ac  # Opens chat with Copilot
<leader>AC  # Generates commit with Copilot
```

### On Other Laptops
```bash
# Uses Ollama with qwen2.5:14b-instruct
# First, make sure Ollama is running:
ollama serve

# Then use Neovim normally:
nvim crater/handler.py
<leader>Ac  # Opens chat with Ollama
<leader>AC  # Generates commit with Ollama
```

## Requirements

### This Laptop (Copilot)
- ✅ GitHub Copilot subscription
- ✅ Authenticated with GitHub
- ✅ Internet connection

### Other Laptops (Ollama)
- ✅ Ollama installed: `brew install ollama`
- ✅ Model downloaded: `ollama pull qwen2.5:14b-instruct`
- ✅ Ollama service running: `ollama serve`
- ✅ No internet needed (runs locally)

## Adding More Hostnames

To add more laptops that should use Copilot:

```lua
-- In ~/.config/nvim/lua/plugins/codecompanion.lua
local hostname = vim.fn.hostname()
local adapter = "ollama" -- Default

if hostname == "MB-928298.local" or 
   hostname == "work-laptop.local" or 
   hostname == "home-desktop" then
    adapter = "copilot"
end
```

## Changing Default Ollama Model

To use a different model:

```lua
adapters = {
    ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
            schema = {
                model = {
                    default = "llama3.1:8b",  -- Changed model
                },
            },
        })
    end,
},
```

Popular alternatives:
- `llama3.1:8b` - Smaller, faster
- `codellama:13b` - Code-focused
- `deepseek-coder-v2:16b` - Code specialist
- `qwen2.5-coder:7b` - Lightweight coder

## Verification

### Check Which Adapter Is Active

```lua
-- In Neovim command mode
:lua print(vim.fn.hostname())
-- Shows: MB-928298.local (this laptop uses Copilot)

:lua print(require("codecompanion").config.strategies.chat.adapter)
-- Shows: copilot (on this laptop)
-- Shows: ollama (on other laptops)
```

### Test It

**On this laptop:**
```
<leader>Ac
# Should open chat powered by GitHub Copilot
```

**On other laptop:**
```
# First time setup:
ollama pull qwen2.5:14b-instruct
ollama serve &

# Then:
<leader>Ac
# Should open chat powered by Ollama
```

## Troubleshooting

### Ollama Not Working?

**Check if Ollama is running:**
```bash
ps aux | grep ollama
curl http://localhost:11434
```

**Start Ollama if needed:**
```bash
ollama serve &
```

**Check model is downloaded:**
```bash
ollama list
# Should show: qwen2.5:14b-instruct
```

**Download model if missing:**
```bash
ollama pull qwen2.5:14b-instruct
```

### Copilot Not Working?

**Check authentication:**
```bash
gh auth status
```

**Login if needed:**
```bash
gh auth login
```

## Benefits

1. ✅ **Automatic switching** - No manual config per machine
2. ✅ **Use Copilot where available** - Best quality on work laptop
3. ✅ **Automatic fallback** - Switches to Ollama on rate limit
4. ✅ **Offline capable** - Ollama works without internet
5. ✅ **Cost effective** - Free local LLM on personal laptops
6. ✅ **Portable dotfiles** - Same config works everywhere
7. ✅ **Never blocked** - Always have AI available

## Related Documentation

- See `COPILOT-OLLAMA-FALLBACK.md` for details on automatic rate limit handling

## Files Modified

- `~/.config/nvim/lua/plugins/codecompanion.lua`
  - Added hostname detection (line 30-35)
  - Added conditional adapter selection
  - Added Ollama adapter configuration with qwen2.5:14b-instruct
  - All strategies use detected adapter

## Summary

**This laptop (MB-928298.local):**
- Adapter: GitHub Copilot ☁️ (with Ollama fallback 💻)
- Requires: Internet + Copilot subscription
- Fallback: Ollama when rate limited

**Other laptops:**
- Adapter: Ollama (local) 💻
- Model: qwen2.5:14b-instruct
- Requires: `ollama serve` running
- Fallback: None needed (already local)

**Same keybindings, same features, different backends!** 🎯
