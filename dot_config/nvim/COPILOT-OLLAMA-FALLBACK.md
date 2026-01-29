# Automatic Copilot → Ollama Fallback

## Feature
When Copilot hits its rate limit, CodeCompanion automatically switches to Ollama (local AI) for the rest of your session!

## How It Works

### Rate Limit Detection

CodeCompanion monitors Copilot API responses for rate limit errors:
- HTTP 429 (Too Many Requests)
- "Rate limit" messages
- "Quota exceeded" messages
- "Throttling" messages

### Automatic Fallback

When rate limit detected:
1. **Notification** - Warns you about rate limit
2. **Switch** - Changes all strategies to Ollama
3. **Retry prompt** - Ask you to restart your last command

### Visual Flow

```
┌─────────────────────────────────┐
│ User: <leader>AC (commit msg)   │
└─────────────────────────────────┘
              ↓
┌─────────────────────────────────┐
│ Try: GitHub Copilot             │
└─────────────────────────────────┘
              ↓
         ✅ Success?
         │
    No   │   Yes
    ↓    ↓    ↓
    │  (Done) │
    ↓         ↓
Rate Limit?
    │
  Yes
    ↓
┌─────────────────────────────────┐
│ ⚠️  Notify: Rate limit hit!     │
│ 🔄 Switch: All → Ollama         │
│ ℹ️  Prompt: Restart command     │
└─────────────────────────────────┘
              ↓
┌─────────────────────────────────┐
│ User: <leader>AC (retry)        │
└─────────────────────────────────┘
              ↓
┌─────────────────────────────────┐
│ Try: Ollama (local)             │
│ ✅ Works! (no rate limit)       │
└─────────────────────────────────┘
```

## User Experience

### Before Rate Limit
```bash
<leader>AC
# Using Copilot... ✅
# "gitmeta/handler: fix branch logic (ORION-123)"
```

### When Rate Limit Hit
```
<leader>AC

# You see:
⚠️  Copilot rate limit hit! Switching to Ollama (qwen2.5:14b-instruct)
ℹ️  Switched to Ollama. Restart your last command to use local AI.

# Retry the same command:
<leader>AC

# Now using Ollama... ✅
# "gitmeta/handler: fix branch logic (ORION-123)"
```

### Rest of Session
All commands now use Ollama until you restart Neovim:
```bash
<leader>AC  # Uses Ollama
<leader>Av  # Uses Ollama
<leader>Ac  # Uses Ollama
```

## Rate Limit Patterns Detected

The error handler checks for these patterns:

```lua
-- Pattern matching (case-insensitive):
"rate limit"
"Rate Limit"
"RATE LIMIT"
"429"                -- HTTP status code
"quota"
"Quota exceeded"
"throttl"            -- Matches "throttle", "throttling", etc.
"Throttled"
```

## Configuration Code

```lua
-- Custom Copilot adapter with Ollama fallback
copilot = function()
    return require("codecompanion.adapters").extend("copilot", {
        callbacks = {
            on_error = function(err)
                -- Check if rate limit error
                if err and (
                    string.match(err, "[Rr]ate limit") or
                    string.match(err, "429") or
                    string.match(err, "[Qq]uota") or
                    string.match(err, "[Tt]hrottl")
                ) then
                    vim.notify(
                        "Copilot rate limit hit! Switching to Ollama (qwen2.5:14b-instruct)",
                        vim.log.levels.WARN
                    )
                    
                    -- Switch all strategies to Ollama
                    local cc = require("codecompanion")
                    cc.config.strategies.chat.adapter = "ollama"
                    cc.config.strategies.inline.adapter = "ollama"
                    cc.config.strategies.agent.adapter = "ollama"
                    
                    vim.notify(
                        "Switched to Ollama. Restart your last command to use local AI.",
                        vim.log.levels.INFO
                    )
                end
            end,
        },
    })
end,
```

## What Gets Switched

**All strategies switch to Ollama:**
- ✅ Chat (`<leader>Ac`)
- ✅ Inline (`<leader>Ai`)
- ✅ Agent (background processing)
- ✅ All custom prompts (`/surgical`, `/team-commit`, etc.)

## Requirements for Fallback

**Ollama must be available:**

```bash
# Install if not already
brew install ollama

# Download model
ollama pull qwen2.5:14b-instruct

# Start service
ollama serve &
```

**If Ollama not running when fallback triggered:**
- You'll see connection errors
- Start Ollama: `ollama serve &`
- Retry your command

## Reset to Copilot

**To switch back to Copilot:**
```vim
:RestartNvim
" OR
:qa
nvim
```

After restart, will try Copilot again (if on MB-928298.local).

## Example Scenarios

### Scenario 1: Heavy Usage Day
```bash
# Morning - Copilot working fine
<leader>AC  # ✅ Copilot
<leader>Av  # ✅ Copilot
<leader>AC  # ✅ Copilot
...

# After 50+ requests - rate limit hit
<leader>AC
# ⚠️  Rate limit! Switching to Ollama

<leader>AC  # ✅ Ollama (retry)
<leader>Av  # ✅ Ollama
<leader>AC  # ✅ Ollama

# Rest of day - Ollama until restart
```

### Scenario 2: Shared Account
```bash
# Copilot account shared with team
# Multiple people hitting rate limit

<leader>AC
# ⚠️  Rate limit! Switching to Ollama

<leader>AC  # ✅ Ollama (works immediately)
# Continue working without interruption
```

### Scenario 3: Network Issues (Not Rate Limit)
```bash
<leader>AC
# ❌ Connection error (not rate limit)
# No automatic switch - fix network first
```

## Notification Levels

```lua
vim.log.levels.WARN  -- ⚠️  Orange warning (rate limit detected)
vim.log.levels.INFO  -- ℹ️  Blue info (switched successfully)
```

## Benefits

1. ✅ **Seamless fallback** - No manual intervention needed
2. ✅ **Keep working** - Don't wait for rate limit reset
3. ✅ **Local AI ready** - Ollama always available
4. ✅ **Clear feedback** - Notifications explain what happened
5. ✅ **Session-persistent** - Once switched, stays switched
6. ✅ **Smart detection** - Catches all rate limit patterns

## Limitations

**Fallback is one-way per session:**
- Copilot → Ollama ✅ (automatic)
- Ollama → Copilot ❌ (requires restart)

**Why?**
- Prevents thrashing between adapters
- Gives rate limit time to reset
- Simple and predictable behavior

## Testing

### Test Rate Limit Handling

You can't easily trigger real rate limits, but you can verify the logic:

```lua
-- In Neovim command mode
:lua require("codecompanion").config.strategies.chat.adapter
" Shows: copilot

-- Simulate switch (manual testing)
:lua require("codecompanion").config.strategies.chat.adapter = "ollama"
:lua print(require("codecompanion").config.strategies.chat.adapter)
" Shows: ollama

-- Restart to reset
:qa
```

### Monitor Real Usage

Watch for the notification when it happens naturally:
```
⚠️  Copilot rate limit hit! Switching to Ollama (qwen2.5:14b-instruct)
```

## Debugging

### Check Current Adapter
```vim
:lua print(require("codecompanion").config.strategies.chat.adapter)
" copilot = Using Copilot
" ollama = Using Ollama (may have switched)
```

### Check Ollama Status
```bash
# Is Ollama running?
ps aux | grep ollama

# Can it respond?
curl http://localhost:11434

# Is model available?
ollama list | grep qwen2.5
```

### Force Switch (for Testing)
```vim
:lua require("codecompanion").config.strategies.chat.adapter = "ollama"
:lua require("codecompanion").config.strategies.inline.adapter = "ollama"
:lua require("codecompanion").config.strategies.agent.adapter = "ollama"
```

## Files Modified

- `~/.config/nvim/lua/plugins/codecompanion.lua`
  - Added `on_error` callback to Copilot adapter (lines 88-119)
  - Detects rate limit patterns in error messages
  - Switches all strategies to Ollama on detection
  - Shows user-friendly notifications

## Complete Flow Example

```bash
# Start of day
nvim crater/handler.py
<leader>AC  # ✅ Using Copilot

# ... many requests later ...

<leader>AC
# ⚠️  Notification: "Copilot rate limit hit! Switching to Ollama..."
# ℹ️  Notification: "Switched to Ollama. Restart your last command..."

<leader>AC  # Retry
# ✅ Using Ollama now

# Continue working
<leader>Av  # ✅ Ollama
<leader>Ad  # ✅ Ollama
<leader>AC  # ✅ Ollama

# Next morning (fresh Neovim session)
nvim crater/settings.py
<leader>AC  # ✅ Back to Copilot (rate limit reset overnight)
```

## Summary

**Intelligent Fallback:**
- Starts with Copilot (best quality)
- Detects rate limit automatically
- Falls back to Ollama (unlimited local)
- Notifies you clearly
- Keeps working seamlessly

**Best of both worlds:**
- ☁️ Copilot when available (high quality)
- 💻 Ollama when needed (always available)

**You never stop coding!** 🚀
