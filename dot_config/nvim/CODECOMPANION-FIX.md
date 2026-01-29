# CodeCompanion Custom Prompts Fix

## Problem
`<leader>AC` was using CodeCompanion's built-in `/commit` prompt instead of our custom team commit prompt.

## Root Cause
CodeCompanion has built-in prompts in:
- `/Users/andrzej.skupien/.local/share/nvim/lazy/codecompanion.nvim/lua/codecompanion/actions/builtins/commit.md`
- Uses `alias: commit` and `is_slash_cmd: true`

Our custom prompt was using `slash_cmd: "commit"` which didn't override the built-in.

## Solution

### 1. Changed from `slash_cmd` to `alias` + `is_slash_cmd`
**Before:**
```lua
opts = {
  slash_cmd = "commit",
}
```

**After:**
```lua
opts = {
  is_slash_cmd = true,
  alias = "team-commit",  -- Different name to avoid conflict
}
```

### 2. Disabled built-in prompts
Added to display configuration:
```lua
display = {
  action_palette = {
    opts = {
      show_preset_prompts = false,  -- Hide built-in prompts
    },
  },
}
```

### 3. Updated all custom prompts
- `/surgical` → uses `is_slash_cmd: true, alias: "surgical"`
- `/debug` → uses `is_slash_cmd: true, alias: "debug"`
- `/review` → uses `is_slash_cmd: true, alias: "review"`
- `/early-exit` → uses `is_slash_cmd: true, alias: "early-exit"`
- `/team-commit` → uses `is_slash_cmd: true, alias: "team-commit"` (renamed from `/commit`)

### 4. Updated keybinding
Changed `<leader>AC` from `/commit` to `/team-commit`

## New Commands

| Keybinding | Slash Command | Description |
|------------|---------------|-------------|
| `<leader>As` | `/surgical` | Surgical code edits |
| `<leader>Ad` | `/debug` | Debug ORION tickets |
| `<leader>Av` | `/review` | Code review |
| `<leader>AC` | `/team-commit` | Team commit message ⭐ |

## Testing

1. Restart Neovim: `:qa` then reopen
2. Stage some changes: `git add .`
3. Press `<leader>AC`
4. Should see team commit prompt (reads from `infra/commands/commit-changes.md`)
5. Verify it follows team standards (component prefix, ticket ID, etc.)

## Files Modified
- `~/.config/nvim/lua/plugins/codecompanion.lua`
  - Changed all `slash_cmd` to `alias` + `is_slash_cmd`
  - Added `show_preset_prompts = false`
  - Renamed "Commit Message" to "Team Commit Message"
  - Updated keybinding to `/team-commit`

## Verification

Built-in prompts that are now hidden:
- `/commit` (generic conventional commits)
- `/explain`
- `/fix`
- Others...

Our custom prompts now work:
- ✅ `/surgical` - loads `dev/rules/minimal-surgical-edits.mdc`
- ✅ `/debug` - loads `infra/commands/debug-orion.md`
- ✅ `/review` - loads `dev/rules/code-review-bug-patterns.mdc`
- ✅ `/team-commit` - loads `infra/commands/commit-changes.md`
- ✅ `/early-exit` - loads `dev/rules/prefer-early-exit.mdc`
