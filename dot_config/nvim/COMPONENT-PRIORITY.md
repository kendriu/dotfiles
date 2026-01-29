# Component Extraction Priority System

## Priority Rules

When extracting component/subsection from changed files:

### 🥇 Priority 1: `scrubber.py` (HIGHEST)
**Always preferred** - Scrubber files represent the main data processing logic
```
crater/modules/cvms/scrubber.py     → cvms/scrubber
crater/scrubber.py                  → crater/scrubber
```

### 🥈 Priority 2: `handler.py` (MEDIUM)
**Used if no scrubber** - Handler files represent request/event processing
```
crater/modules/s3/handler.py        → s3/handler
crater/handler.py                   → crater/handler
```

### 🥉 Priority 3: Other `.py` files (LOW)
**Used if no scrubber or handler** - First other Python file found
```
crater/modules/gitmeta/branches.py  → gitmeta/branches
crater/settings.py                  → crater/settings
```

### ❌ Skipped: `__init__.py` (NEVER USED)
**Always ignored** - Not meaningful for commit messages
```
crater/modules/gitmeta/__init__.py  → (skipped)
crater/__init__.py                  → (skipped)
```

---

## Visual Priority Flow

```
Changed Files
    ↓
Scan all files
    ↓
┌─────────────────────────────────────┐
│ Found scrubber.py?                  │ → YES → Use it! ✅
└─────────────────────────────────────┘
    ↓ NO
┌─────────────────────────────────────┐
│ Found handler.py?                   │ → YES → Use it! ✅
└─────────────────────────────────────┘
    ↓ NO
┌─────────────────────────────────────┐
│ Found other .py file?               │ → YES → Use first one ✅
│ (excluding __init__.py)             │
└─────────────────────────────────────┘
    ↓ NO
No component extracted (generic format)
```

---

## Real Examples

### Example 1: Scrubber Beats All
```bash
# Changed files:
- crater/modules/gitmeta/scrubber.py   ← WINNER (scrubber)
- crater/modules/gitmeta/handler.py    (ignored - lower priority)
- crater/modules/gitmeta/branches.py   (ignored - lower priority)
- crater/modules/gitmeta/__init__.py   (ignored - always skipped)

# Component: gitmeta/scrubber
# Commit: "gitmeta/scrubber: improve branch metadata extraction (ORION-123)"
```

### Example 2: Handler When No Scrubber
```bash
# Changed files:
- crater/modules/s3/handler.py         ← WINNER (handler, no scrubber)
- crater/modules/s3/download.py        (ignored - lower priority)

# Component: s3/handler
# Commit: "s3/handler: add retry logic for s3 requests (ORION-456)"
```

### Example 3: Other File When No Scrubber/Handler
```bash
# Changed files:
- crater/modules/gitmeta/branches.py   ← WINNER (first other file)
- crater/settings.py                   (ignored - already have candidate)

# Component: gitmeta/branches
# Commit: "gitmeta/branches: fix branch listing bug (ORION-789)"
```

### Example 4: Skip __init__
```bash
# Changed files:
- crater/modules/cvms/__init__.py      (skipped - __init__)
- crater/modules/cvms/scrubber.py      ← WINNER (scrubber)

# Component: cvms/scrubber
# Commit: "cvms/scrubber: optimize cvm metadata scrubbing (ORION-999)"
```

### Example 5: Only __init__ (No Component)
```bash
# Changed files:
- crater/modules/tasks/__init__.py     (skipped - __init__)
- crater/__init__.py                   (skipped - __init__)

# Component: (none)
# Commit: "fix: update module initialization (ORION-111)"
```

---

## Why This Priority?

### Scrubber = Core Logic
- Scrubbers do the heavy lifting (data processing, ETL)
- Most important file in a module
- Changes here are usually the main feature/fix

### Handler = Interface Logic
- Handlers process requests/events
- Important but often just wiring
- Less critical than core processing

### Other Files = Supporting Code
- Utilities, helpers, configuration
- Can be important but less commonly changed
- Lower priority makes sense

### __init__ = Boilerplate
- Just imports and package setup
- Not meaningful for commit messages
- Should be part of larger changes

---

## Testing Matrix

| Files Changed | Expected Component | Reason |
|---------------|-------------------|--------|
| `scrubber.py + handler.py + other.py` | `scrubber` | Scrubber wins |
| `handler.py + other.py` | `handler` | Handler wins (no scrubber) |
| `other1.py + other2.py` | `other1` | First other file |
| `__init__.py + scrubber.py` | `scrubber` | Skip __init__ |
| `__init__.py + handler.py` | `handler` | Skip __init__ |
| `__init__.py + other.py` | `other` | Skip __init__ |
| `__init__.py only` | (none) | Skip __init__ |
| `scrubber.py (module1) + handler.py (module2)` | `module1/scrubber` | Scrubber even across modules |

---

## Code Summary

```lua
local scrubber_candidate = nil
local handler_candidate = nil
local other_candidate = nil

-- Scan all files
for file in files:gmatch("[^\r\n]+") do
    local module, filename = file:match("crater/modules/([^/]+)/([^/]+)%.py$")
    
    if module and filename and filename ~= "__init__" then
        if filename == "scrubber" then
            scrubber_candidate = module .. "/" .. filename
        elseif filename == "handler" then
            handler_candidate = module .. "/" .. filename
        elseif not other_candidate then
            other_candidate = module .. "/" .. filename
        end
    end
    -- (also check crater/ top-level files)
end

-- Priority selection
component = scrubber_candidate or handler_candidate or other_candidate
```

**Key: `or` operator implements priority!**
- If scrubber exists, use it (short-circuits)
- Else if handler exists, use it
- Else use other

---

## Quick Reference

```
Priority:  scrubber > handler > other > (skip __init__)
           🥇       🥈        🥉         ❌

Examples:
  ✅ gitmeta/scrubber   (best choice)
  ✅ s3/handler         (good choice)
  ✅ gitmeta/branches   (ok choice)
  ❌ gitmeta/__init__   (never used)
```

---

**Smart defaults for better commit messages!** 🎯
