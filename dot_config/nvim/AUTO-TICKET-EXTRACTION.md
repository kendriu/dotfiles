# Auto-Extract Ticket ID from Branch Name

## Feature
The `/team-commit` command now automatically extracts ticket IDs from your git branch name!

## How It Works

### Branch Name Pattern
Looks for pattern: `LETTERS-DIGITS` (e.g., ORION-12345)

### Examples

| Branch Name | Extracted Ticket | Result |
|-------------|------------------|---------|
| `feature/ORION-12345-fix-bug` | ORION-12345 | ✅ Auto-included in commit |
| `ORION-67890` | ORION-67890 | ✅ Auto-included in commit |
| `fix/something-ORION-11111` | ORION-11111 | ✅ Auto-included in commit |
| `JIRA-999-new-feature` | JIRA-999 | ✅ Works with any ticket system |
| `main` | (none) | ⚠️ Will prompt for ticket ID |
| `feature/add-stuff` | (none) | ⚠️ Will prompt for ticket ID |

## Usage

**Before:**
```bash
git checkout -b feature/fix-timeout
# ... make changes ...
git add .
<leader>AC

# AI: "What's the ticket ID?"
# You: "ORION-12345"
```

**Now:**
```bash
git checkout -b feature/ORION-12345-fix-timeout
# ... make changes ...
git add .
<leader>AC

# AI: "Found ticket ORION-12345 from branch!"
# AI: "comet/clients: fix ssh timeout (ORION-12345)"
# ✅ No manual typing needed
```

## What You See

**When ticket found:**
```
Generate a commit message for these changes:

**Ticket ID (from branch):** ORION-12345

Make sure to include (ORION-12345) at the end of the summary line.

```diff
+ timeout handling code
```
```

**When ticket NOT found:**
```
Generate a commit message for these changes:

**Note:** Could not find ticket ID in branch name 'main'.
Please include the ticket ID in the commit message if available.

```diff
+ your changes
```
```

## Code Implementation

```lua
-- Get current branch name
local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

-- Extract ticket number (ORION-XXXXX or similar pattern)
local ticket_id = branch:match("([A-Z]+%-[0-9]+)")

if ticket_id then
    prompt = prompt .. "**Ticket ID (from branch):** " .. ticket_id .. "\n\n"
    prompt = prompt .. "Make sure to include (" .. ticket_id .. ") at the end of the summary line.\n\n"
else
    prompt = prompt .. "**Note:** Could not find ticket ID in branch name..."
end
```

## Pattern Explanation

The regex `([A-Z]+%-[0-9]+)` matches:
- One or more uppercase letters: `A-Z`+
- A hyphen: `-`
- One or more digits: `0-9`+

**Matches:**
- ✅ ORION-12345
- ✅ JIRA-999
- ✅ TICKET-123
- ✅ ABC-1

**Doesn't match:**
- ❌ orion-123 (lowercase)
- ❌ ORION (no number)
- ❌ 12345 (no letters)
- ❌ ORION_12345 (underscore, not hyphen)

## Benefits

1. **No manual typing** - ticket ID extracted automatically
2. **Consistent format** - always includes ticket ID
3. **Works with any system** - ORION, JIRA, TICKET, etc.
4. **Graceful fallback** - prompts if not found
5. **Team workflow aligned** - matches branch naming conventions

## Best Practices

### Recommended Branch Naming

```bash
# Feature branches
git checkout -b feature/ORION-12345-short-description

# Bug fixes
git checkout -b fix/ORION-67890-bug-description

# Simple (just ticket)
git checkout -b ORION-12345

# Hotfix
git checkout -b hotfix/ORION-11111-critical-fix
```

### Avoid

```bash
# Bad: no ticket ID
git checkout -b feature/add-something

# Bad: lowercase
git checkout -b feature/orion-12345-fix

# Bad: underscore instead of hyphen
git checkout -b feature/ORION_12345_fix
```

## Testing

1. **With ticket in branch:**
```bash
git checkout -b feature/ORION-99999-test
# Make some changes
git add .
<leader>AC
# Should see: "Ticket ID (from branch): ORION-99999"
```

2. **Without ticket in branch:**
```bash
git checkout main
# Make some changes  
git add .
<leader>AC
# Should see: "Could not find ticket ID in branch name 'main'"
```

## Files Modified
- `~/.config/nvim/lua/plugins/codecompanion.lua`
  - Added branch name extraction
  - Added ticket ID pattern matching
  - Enhanced user prompt with ticket info

## Works With
- ORION (your team)
- JIRA
- Linear (LIN-123)
- GitHub Issues (if using ISSUE-123 format)
- Any system using LETTERS-DIGITS format
