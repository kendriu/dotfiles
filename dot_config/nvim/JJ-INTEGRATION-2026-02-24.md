# Jujutsu (jj) Integration - 2026-02-24

## Changes Made

Updated all git commands to use jj (Jujutsu) instead:

### 1. Review Changes Prompt
**Before:**
```lua
local diff = vim.fn.system("git diff --staged")
if diff == "" then
  diff = vim.fn.system("git diff")
end
```

**After:**
```lua
local diff = vim.fn.system("jj diff")
-- jj doesn't have staging, just shows current working copy changes
```

---

### 2. Team Commit Message Prompt

**Branch/Bookmark Detection:**
- **Before:** `git rev-parse --abbrev-ref HEAD`
- **After:** `jj log -r @ --no-graph -T 'bookmarks'`

**Changed Files List:**
- **Before:** `git diff --staged --name-only || git diff --name-only`
- **After:** `jj diff --summary | awk '{print $NF}'`

**Error Messages:**
- Changed from "stage your changes with `git add`" 
- To "make some changes first" (jj doesn't have staging)

---

### 3. Context Provider
The CodeCompanion "git" context provider is **VCS-agnostic** and works with jj automatically.
No changes needed - it detects the VCS being used.

---

## JJ Command Reference

For your reference, here are the jj equivalents used:

| Git Command | JJ Equivalent | Purpose |
|------------|---------------|---------|
| `git diff --staged` | `jj diff` | Show uncommitted changes |
| `git diff` | `jj diff` | Show uncommitted changes |
| `git rev-parse --abbrev-ref HEAD` | `jj log -r @ --no-graph -T 'bookmarks'` | Get current bookmark |
| `git diff --name-only` | `jj diff --summary \| awk '{print $NF}'` | List changed files |
| `git status` | `jj status` | Show working copy status |

---

## How It Works

### Commit Message Flow (jj version):
1. Press `<leader>AC`
2. AI reads current bookmark name (e.g., `ORION-1234-fix-bug`)
3. Extracts ticket ID: `ORION-1234`
4. Gets diff with: `jj diff`
5. Analyzes changed files from: `jj diff --summary`
6. Auto-detects component (scrubber/handler priority)
7. Generates commit message following team standards

### Review Changes Flow (jj version):
1. Make changes in working copy
2. Press `<leader>AR`
3. AI gets diff with: `jj diff`
4. Reviews all changes for bugs

No staging required! 🎉

---

## Testing

1. **Test commit message:**
   ```bash
   # Make some changes
   echo "test" >> README.md
   
   # In Neovim:
   <leader>AC
   # Should see your changes from jj diff
   ```

2. **Test review changes:**
   ```bash
   # Make some changes
   <leader>AR
   # Should see AI review your jj diff
   ```

3. **Test bookmark detection:**
   ```bash
   # Create bookmark with ticket ID
   jj bookmark create ORION-1234-feature
   
   # Make changes and generate commit message
   <leader>AC
   # Should detect ORION-1234 from bookmark
   ```

---

## Files Modified

- `~/.config/nvim/lua/plugins/codecompanion.lua`
  - Changed "Review Changes" prompt to use `jj diff`
  - Changed "Team Commit Message" prompt to use `jj log`, `jj diff --summary`
  - Updated error messages (removed git staging references)
  - Added clarifying comment for git context provider (works with jj)

---

## Notes

- **No staging area:** JJ has a different model - changes are always visible until committed
- **Bookmarks vs branches:** JJ uses bookmarks (like git branches but different semantics)
- **Context provider:** The "git" context provider name is misleading but works with jj
- **Backward compatible:** If you ever use git repos, commands will need to be conditional

---

## Future Enhancement (Optional)

If you want to auto-detect git vs jj:

```lua
local function get_vcs_diff()
  -- Check if jj repo
  local is_jj = vim.fn.system("jj status 2>&1"):find("Error: There is no jj repo") == nil
  
  if is_jj then
    return vim.fn.system("jj diff")
  else
    -- Fallback to git
    local diff = vim.fn.system("git diff --staged")
    if diff == "" then
      diff = vim.fn.system("git diff")
    end
    return diff
  end
end
```

But since you only use jj, the current implementation is simpler and better.
