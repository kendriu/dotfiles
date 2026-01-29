# Cursorfiles Integration with CodeCompanion

Your team's Cursor rules are now **dynamically loaded** into Neovim via CodeCompanion!

## 📁 Location

**Symlink:** `~/.config/nvim/cursor-rules/` → `~/sources/cursorfiles/packs/`

Contains your team's:
- **dev** pack - 25 rules, 6 skills (coding patterns, debugging)
- **infra** pack - 5 rules, 3 commands (infrastructure, VM debugging)
- **qa** pack - 2 rules, 1 command (testing guidelines)

## 🔄 Dynamic Loading

**Prompts are loaded from files at runtime** - no hardcoded content!

When you use a command, CodeCompanion reads the actual file:
- `/surgical` → reads `dev/rules/minimal-surgical-edits.mdc`
- `/debug` → reads `infra/commands/debug-orion.md`
- `/review` → reads `dev/rules/code-review-bug-patterns.mdc`
- `/commit` → reads `infra/commands/commit-changes.md`
- `/early-exit` → reads `dev/rules/prefer-early-exit.mdc`

**Benefits:**
✅ Team updates rules → instantly available in Neovim  
✅ No need to edit Neovim config  
✅ Single source of truth (cursorfiles repo)  
✅ Automatic YAML frontmatter stripping  

## 🎯 Quick Start

### New Keybindings

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>As` | `/surgical` | Surgical Edit Mode (minimal changes) |
| `<leader>Ad` | `/debug` | Debug ORION Ticket (step-by-step workflow) |
| `<leader>Av` | `/review` | Code Review (bug patterns) |
| `<leader>AC` | `/commit` | Generate Commit Message (team standards) |

### Slash Commands

In CodeCompanion chat (`<leader>Ac`), type:
- `/surgical` - Apply surgical editing principles
- `/debug` - Debug ORION tickets step-by-step
- `/review` - Review selected code for bugs
- `/review-changes` - Review all changed files (git diff)
- `/commit` - Generate commit message (team standards)
- `/early-exit` - Refactor nested loops

## 📚 Available Prompts

### 1. Surgical Edit (`<leader>As` or `/surgical`)

**Use when:** Making code changes

**What it does:**
- Enforces minimal, surgical changes
- Prevents scope creep
- Uses existing infrastructure first
- Questions every addition

**Example usage:**
```
1. Select code in visual mode
2. Press <leader>As
3. Describe the change needed
4. AI follows strict surgical editing rules
```

### 2. Debug ORION (`<leader>Ad` or `/debug`)

**Use when:** Investigating ORION tickets

**What it does:**
- Step-by-step debugging workflow
- Asks for required info (ticket #, job dir, crater server)
- Guides log examination
- Root cause analysis
- Proposes minimal fixes

**Example usage:**
```
1. Press <leader>Ad
2. Provide: ORION-123456, job directory, failure time
3. Follow guided debugging steps
4. Get root cause + proposed fix
```

### 3. Code Review (`<leader>Av` or `/review`)

**Use when:** Reviewing selected code

**What it does:**
- Checks for common bug patterns
- Missing error handling
- Resource initialization issues
- Logic validation
- Memory management problems
- Suggests early exit refactoring

**Example usage:**
```
1. Select code in visual mode
2. Press <leader>Av
3. Get actionable bug-focused feedback
```

### 3.5. Review All Changes (`<leader>AR` or `/review-changes`)

**Use when:** Want to review all your changes before committing

**What it does:**
- Reviews entire git diff (staged or unstaged)
- Checks ALL changed files comprehensively
- Points to specific line numbers
- Explains why each issue matters
- Suggests fixes

**Example usage:**
```
1. Make changes to multiple files
2. Press <leader>AR (or stage with git add)
3. AI reviews all changes at once
4. Get comprehensive feedback
5. Fix issues, then press <leader>AC for commit
```

### 5. Commit Message (`<leader>AC` or `/commit`)

**Use when:** Ready to commit changes

**What it does:**
- Analyzes staged git diff
- Generates commit message following team standards
- Uses component prefixes (e.g., `comet/clients:`)
- Imperative mood, lowercase, no period
- Includes ticket ID in parentheses
- Explains WHY, not just what

**Example usage:**
```
1. Stage your changes: git add .
2. Press <leader>AC
3. AI analyzes diff and generates:
   "comet/clients: fix ssh timeout handling (ORION-12345)"
4. Copy and use: git commit -m "..."
```

**Use when:** Code has nested loops/conditions

**What it does:**
- Refactors nested logic to use early exits
- Reduces indentation
- Improves readability

**Example usage:**
```
1. Select nested loop code
2. Type /early-exit in chat
3. Get refactored version with early exits
```

## 🔄 Workflow Examples

### Making a Code Change

```
1. Read JIRA ticket
2. Open relevant file in Neovim
3. Select code that needs changing (visual mode)
4. Press <leader>As (Surgical Edit)
5. Describe change: "Add null check before dereferencing stream"
6. AI proposes minimal surgical change
7. Review and apply
```

### Debugging ORION Ticket

```
1. Press <leader>Ad (Debug ORION)
2. AI asks: "What's the ORION ticket number?"
3. Provide: "ORION-123456"
4. AI asks: "What's the job directory?"
5. Provide: "/file_server/jenkins/generic_test_1011835/"
6. AI walks through:
   - Log examination commands
   - Issue categorization
   - Root cause analysis
   - Proposed fix
```

### Code Review Before Commit

**Option 1: Review specific code**
```
1. Select code you changed (visual mode)
2. Press <leader>Av (Code Review)
3. Fix issues
```

**Option 2: Review all changes**
```
1. Make changes to multiple files
2. Press <leader>AR (Review All Changes)
3. AI reviews entire git diff
4. Fix all issues
5. Press <leader>AC for commit message
```

**Complete workflow:**
```
1. Work on feature
2. Press <leader>AR to review all changes
3. Fix bugs identified by AI
4. Stage: git add .
5. Press <leader>AC for commit message
6. Commit: git commit -m "..."
```

## 🎨 Integration with Existing Workflow

### With Which-Key

Press `<leader>A` to see all AI commands:
```
 AI/Assistant
  c → Toggle Chat
  n → New Chat
  a → Action Palette
  s → Surgical Edit Mode    ← NEW
  d → Debug ORION Ticket    ← NEW
  v → Code Review           ← NEW
```

### With Action Palette

Press `<leader>Aa` to see all available prompts:
- Surgical Edit
- Debug ORION
- Code Review
- Early Exit Refactor
- (plus default CodeCompanion actions)

## 📖 Team Rules Reference

Your team's full rules are always available:

```bash
# View all rules
ls ~/.config/nvim/cursor-rules/

# Read a specific rule
nvim ~/.config/nvim/cursor-rules/dev/rules/minimal-surgical-edits.mdc

# Update rules (in cursorfiles repo)
cd ~/sources/cursorfiles
git pull
# Changes automatically reflected in Neovim via symlink
```

## 🔧 Customization

### Add New Prompts

Edit `~/.config/nvim/lua/plugins/codecompanion.lua`:

```lua
["Your New Prompt"] = {
  strategy = "chat",
  description = "What it does",
  opts = {
    slash_cmd = "yourcommand",
  },
  prompts = {
    {
      role = "system",
      content = function()
        local content = read_cursorfile("dev/rules/your-rule.mdc")
        return "You are an expert...\n\n" .. content
      end,
    },
    {
      role = "user",
      content = "User prompt",
    },
  },
},
```

### Add Keybinding

In the same file, add to `keys = {}`:

```lua
{ "<leader>Ax", "<cmd>CodeCompanion /yourcommand<CR>", desc = "AI: Your Command" },
```

### Add New Rule File

Just add it to cursorfiles repo:
```bash
cd ~/sources/cursorfiles
# Add new rule
vim packs/dev/rules/my-new-rule.mdc
git add packs/dev/rules/my-new-rule.mdc
git commit -m "dev: add new coding rule"
git push

# Then reference it in codecompanion.lua
```

## 💡 Tips

1. **Start with `/surgical`** for any code change - keeps changes minimal
2. **Use `/debug`** as your ORION ticket entry point - structured workflow
3. **Run `/review`** before committing - catch bugs early
4. **Reference original rules** - symlinked to `~/.config/nvim/cursor-rules/`
5. **Share improvements** - commit to cursorfiles repo for team

## 🐛 Troubleshooting

**Prompts not showing up?**
```bash
# Reload Neovim config
:Lazy reload codecompanion.nvim
```

**Can't find rules?**
```bash
# Check symlink
ls -la ~/.config/nvim/cursor-rules
# Should point to ~/sources/cursorfiles/packs

# Test file reading
ls ~/.config/nvim/cursor-rules/dev/rules/minimal-surgical-edits.mdc
```

**Update team rules?**
```bash
cd ~/sources/cursorfiles
git pull
# Rules immediately available - no reload needed!
```

**Rule not loading?**
```bash
# Check file exists
ls ~/.config/nvim/cursor-rules/dev/rules/your-rule.mdc

# Check Neovim can read it
:lua print(vim.fn.stdpath("config") .. "/cursor-rules/dev/rules/your-rule.mdc")
```

## 🎉 You're All Set!

Your team's Cursor rules are now powering your Neovim AI assistant. Use them to maintain code quality and follow team conventions!

## 
For automatic ticket extraction in commit messages:

**Good branch names:**
- `feature/ORION-12345-add-timeout-handling`
- `ORION-12345` (simple)
- `fix/ORION-67890-memory-leak`
- `bugfix/ORION-11111-ssh-error`

**Pattern recognized:** `ANYTEXT-DIGITS` (e.g., ORION-12345, JIRA-999, TICKET-123)

**Benefits:**
- `/team-commit` automatically includes ticket ID
- No need to remember or type ticket number
- Consistent with team workflow
- Works with any ticketing system (ORION, JIRA, etc.)

