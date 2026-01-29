# Auto-Extract Component/Subsection for Crater Commits

## Feature
The `/team-commit` command now automatically extracts the `component/subsection` prefix from changed file paths in the crater project!

## How It Works

### File Priority System

When multiple files are changed, the system uses this priority:

1. **🥇 Highest Priority: `scrubber.py`** - Always preferred
2. **🥈 Medium Priority: `handler.py`** - Used if no scrubber
3. **🥉 Low Priority: Other `.py` files** - Used if no scrubber/handler
4. **❌ Skipped: `__init__.py`** - Never used as component

### File Path Patterns

**Pattern 1: Module files**
```
crater/modules/modulename/filename.py → modulename/filename:
```

**Pattern 2: Top-level crater files**
```
crater/filename.py → crater/filename:
```

### Examples

| File Path | Extracted Component | Commit Starts With |
|-----------|---------------------|-------------------|
| `crater/modules/cvms/scrubber.py` | `cvms/scrubber` | `cvms/scrubber: ...` |
| `crater/modules/gitmeta/handler.py` | `gitmeta/handler` | `gitmeta/handler: ...` |
| `crater/modules/s3/download.py` | `s3/download` | `s3/download: ...` |
| `crater/scrubber.py` | `crater/scrubber` | `crater/scrubber: ...` |
| `crater/handler.py` | `crater/handler` | `crater/handler: ...` |
| `crater/settings.py` | `crater/settings` | `crater/settings: ...` |
| `crater/modules/gitmeta/__init__.py` | (skipped) | Uses other files |
| `tests/test_something.py` | (not matched) | Generic commit format |
| `README.md` | (not matched) | Generic commit format |

## Full Automation

Now `/team-commit` automatically extracts **both**:
1. **Component/subsection** from file path
2. **Ticket ID** from branch name

### Before (manual):
```bash
# You had to know:
# - Which component you're changing
# - Ticket number
# - Commit message format

git add crater/modules/gitmeta/handler.py
<leader>AC

# You type:
# "gitmeta/handler: fix branch deletion (ORION-12345)"
```

### Now (automatic):
```bash
git checkout -b feature/ORION-12345-fix-branches
git add crater/modules/gitmeta/handler.py
<leader>AC

# AI sees:
# - File: crater/modules/gitmeta/handler.py → Component: gitmeta/handler
# - Branch: feature/ORION-12345-fix-branches → Ticket: ORION-12345
#
# AI generates:
# "gitmeta/handler: fix branch deletion logic (ORION-12345)"
# ✅ Perfect format, zero manual input!
```

## What You'll See

**When component + ticket found:**
```
Generate a commit message for these changes:

**Component/Subsection:** gitmeta/handler

The commit message MUST start with: `gitmeta/handler: `

**Ticket ID (from branch):** ORION-12345

Make sure to include (ORION-12345) at the end of the summary line.

```diff
+ your changes to gitmeta/handler.py
```
```

**When only ticket found (non-Python files):**
```
Generate a commit message for these changes:

**Ticket ID (from branch):** ORION-12345

Make sure to include (ORION-12345) at the end of the summary line.

```diff
+ your changes to README.md
```
```

## Code Implementation

```lua
-- Get changed files and scan with priority
local files = vim.fn.system("git diff --staged --name-only 2>/dev/null || git diff --name-only")
local scrubber_candidate = nil
local handler_candidate = nil
local other_candidate = nil

for file in files:gmatch("[^\r\n]+") do
    -- Pattern 1: crater/modules/modulename/filename.py -> modulename/filename
    local module, filename = file:match("crater/modules/([^/]+)/([^/]+)%.py$")
    if module and filename and filename ~= "__init__" then
        local component = module .. "/" .. filename
        if filename == "scrubber" then
            scrubber_candidate = component
        elseif filename == "handler" then
            handler_candidate = component
        elseif not other_candidate then
            other_candidate = component
        end
    end
    
    -- Pattern 2: crater/filename.py -> crater/filename
    local filename2 = file:match("crater/([^/]+)%.py$")
    if filename2 and filename2 ~= "__init__" then
        local component = "crater/" .. filename2
        if filename2 == "scrubber" then
            scrubber_candidate = component
        elseif filename2 == "handler" then
            handler_candidate = component
        elseif not other_candidate then
            other_candidate = component
        end
    end
end

-- Select by priority: scrubber > handler > other
local component_subsection = scrubber_candidate or handler_candidate or other_candidate

if component_subsection then
    prompt = prompt .. "**Component/Subsection:** " .. component_subsection .. "\n\n"
    prompt = prompt .. "The commit message MUST start with: `" .. component_subsection .. ": `\n\n"
end
```

## Pattern Details

### Pattern 1: Module Files
```lua
local module, filename = file:match("crater/modules/([^/]+)/([^/]+)%.py$")
```

**Matches:**
- ✅ `crater/modules/gitmeta/handler.py` → module=`gitmeta`, filename=`handler`
- ✅ `crater/modules/s3/download.py` → module=`s3`, filename=`download`

**Doesn't match:**
- ❌ `crater/handler.py` (not in modules/)
- ❌ `crater/modules/gitmeta/__init__.py` (skipped - __init__)
- ❌ `tests/test_file.py` (wrong directory)

### Pattern 2: Top-level Crater Files
```lua
local filename2 = file:match("crater/([^/]+)%.py$")
```

**Matches:**
- ✅ `crater/handler.py` → filename=`handler`
- ✅ `crater/settings.py` → filename=`settings`

**Doesn't match:**
- ❌ `crater/modules/gitmeta/handler.py` (has subdirectory)
- ❌ `tests/test_file.py` (wrong directory)
- ❌ `README.md` (not .py)

## Real Examples

### Example 1: Module Change
```bash
# Branch with ticket
git checkout -b feature/ORION-12345-improve-s3-download

# Edit module file
vim crater/modules/s3/download.py

# Stage and commit
git add crater/modules/s3/download.py
<leader>AC

# AI generates:
# "s3/download: add retry logic for failed downloads (ORION-12345)"
```

### Example 2: Core Crater Change
```bash
# Branch with ticket
git checkout -b fix/ORION-67890-handler-timeout

# Edit core file
vim crater/handler.py

# Stage and commit
git add crater/handler.py
<leader>AC

# AI generates:
# "crater/handler: increase timeout for slow jobs (ORION-67890)"
```

### Example 3: Multiple Files (uses first match)
```bash
git checkout -b feature/ORION-11111-refactor

# Edit multiple files
git add crater/modules/gitmeta/handler.py
git add crater/settings.py
<leader>AC

# Uses first Python file found
# AI generates based on: gitmeta/handler
# "gitmeta/handler: refactor branch handling (ORION-11111)"
```

### Example 4: Non-Python Files (no component)
```bash
git checkout -b docs/ORION-22222-update-readme

# Edit non-Python
git add README.md
<leader>AC

# No component extracted
# AI generates generic format:
# "docs: update installation instructions (ORION-22222)"
```

## Benefits

1. ✅ **Zero manual typing** - component extracted from file path
2. ✅ **Smart priority** - scrubber > handler > other files
3. ✅ **Skips __init__** - avoids meaningless component names
4. ✅ **Consistent format** - always follows `component/subsection:` pattern
5. ✅ **Works with ticket extraction** - combined automation
6. ✅ **Crater-aware** - understands project structure and conventions

## Behavior Notes

**File Priority:**
- 🥇 `scrubber.py` always wins (highest priority)
- 🥈 `handler.py` wins if no scrubber
- 🥉 Other `.py` files win if no scrubber/handler
- ❌ `__init__.py` always ignored

**Multi-file commits:**
- Scans ALL files to find highest priority match
- One scrubber across multiple modules? Uses that scrubber
- Mix of scrubber + handler? Uses scrubber
- For very different changes, commit separately:
  ```bash
  # Separate commits for different modules
  git add crater/modules/gitmeta/scrubber.py
  git commit -m "$(get from AI)"
  
  git add crater/modules/s3/handler.py
  git commit -m "$(get from AI)"
  ```

**Non-Python changes:**
- Falls back to generic commit format
- Still includes ticket ID if found
- AI determines appropriate prefix

**Mixed Python + non-Python:**
- Python files take precedence
- Component extracted from Python file
- Non-Python files mentioned in description

## Testing

```bash
cd /Users/andrzej.skupien/sources/crater

# Test 1: Module file
git checkout -b test/ORION-99999-test
echo "# test" >> crater/modules/gitmeta/handler.py
git add crater/modules/gitmeta/handler.py
# In nvim: <leader>AC
# Should see: "Component/Subsection: gitmeta/handler"

# Test 2: Core file
echo "# test" >> crater/handler.py
git add crater/handler.py
# In nvim: <leader>AC
# Should see: "Component/Subsection: crater/handler"

# Test 3: Non-Python
echo "# test" >> README.md
git add README.md
# In nvim: <leader>AC
# Should see: No component/subsection mentioned
```

## Files Modified

- `~/.config/nvim/lua/plugins/codecompanion.lua`
  - Added component/subsection extraction (lines 308-327)
  - Parses git diff --name-only for file paths
  - Matches crater project structure patterns
  - Injects into commit prompt

## Complete Workflow Example

```bash
# 1. Create branch with ticket
git checkout -b feature/ORION-12345-add-retry-logic

# 2. Make changes
vim crater/modules/s3/download.py
# ... add retry logic ...

# 3. Stage changes
git add crater/modules/s3/download.py

# 4. Generate commit message
# In nvim: <leader>AC

# 5. AI sees:
#    - File: crater/modules/s3/download.py
#    - Component: s3/download
#    - Branch: feature/ORION-12345-add-retry-logic
#    - Ticket: ORION-12345

# 6. AI generates:
#    "s3/download: add exponential backoff for failed downloads (ORION-12345)"

# 7. Copy and commit:
git commit -m "s3/download: add exponential backoff for failed downloads (ORION-12345)"
```

## Summary

**You provide:**
- Branch name with ticket: `feature/ORION-12345-...`
- Staged changes: `git add crater/modules/...`

**AI extracts:**
- Component: `modulename/filename` from file path
- Ticket: `ORION-12345` from branch name

**AI generates:**
- Perfect commit: `modulename/filename: description (ORION-12345)`

**Zero manual typing for commit format!** 🎉

## Priority Examples

### Scenario 1: Multiple Files with Scrubber (Scrubber Wins)
```bash
git add crater/modules/gitmeta/scrubber.py
git add crater/modules/gitmeta/handler.py
git add crater/modules/gitmeta/branches.py
<leader>AC

# Component selected: gitmeta/scrubber
# Why: Scrubber has highest priority
```

### Scenario 2: Handler + Other (Handler Wins)
```bash
git add crater/modules/s3/handler.py
git add crater/modules/s3/download.py
<leader>AC

# Component selected: s3/handler
# Why: Handler has priority over other files
```

### Scenario 3: Only Regular Files (First Wins)
```bash
git add crater/modules/gitmeta/branches.py
git add crater/settings.py
<leader>AC

# Component selected: gitmeta/branches
# Why: First non-priority file found
```

### Scenario 4: With __init__ (Skipped)
```bash
git add crater/modules/gitmeta/__init__.py
git add crater/modules/gitmeta/branches.py
<leader>AC

# Component selected: gitmeta/branches
# Why: __init__.py is always skipped
```

### Scenario 5: Core Crater with Priority
```bash
git add crater/scrubber.py
git add crater/handler.py
git add crater/settings.py
<leader>AC

# Component selected: crater/scrubber
# Why: Scrubber preferred even at top level
```

