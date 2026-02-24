# Avante.nvim Cheatsheet

**Quick Reference Guide for AI-Powered Coding in Neovim**

---

## 🎯 What is Avante?

Avante is a **Cursor-like AI assistant** for Neovim with:
- **Agentic Mode**: AI can autonomously read/write files and run commands
- **Sidebar UI**: Cursor-style diff viewer
- **Multi-Repo Awareness**: Understands your project structure
- **Project Context**: Auto-loads `avante.md` instructions per project

---

## ⌨️ Keybindings

| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `<leader>Aa` | n, v | `:AvanteAsk` | Ask AI a question (with optional selection) |
| `<leader>Ae` | v | `:AvanteEdit` | Edit selected code with AI |
| `<leader>At` | n | `:AvanteToggle` | Toggle sidebar on/off |
| `<leader>Af` | n | `:AvanteFocus` | Focus on sidebar input |
| `<leader>Ar` | n | `:AvanteRefresh` | Refresh AI response |
| `<leader>Az` | n | Zen Mode | Launch CLI-style agent interface |

### Sidebar Navigation
| Key | Action |
|-----|--------|
| `<Tab>` | Jump to next diff |
| `<S-Tab>` | Jump to previous diff |
| `co` | Accept current suggestion |
| `ca` | Accept all suggestions |
| `cr` | Reject current suggestion |
| `q` | Close sidebar |

---

## 🚀 Common Workflows

### 1. **Ask a Question**
```
<leader>Aa
"How does the cluster_config endpoint work?"
```
AI searches your codebase and explains.

### 2. **Edit Code with Context**
```vim
" Visual select the code you want to change
V5j
<leader>Ae
"Refactor this to use early exit pattern"
```

### 3. **Multi-File Analysis**
```
<leader>Aa
"Find all places where autoscaler calls crater API"
```
Avante searches across repos automatically.

### 4. **Debug with Ticket Context**
```
cd ~/sources/crater
nvim handler.py
<leader>Aa
"I'm debugging ORION-12345. Check my Obsidian note and suggest a fix."
```
Avante reads `ORION-12345.md` (tagged with `#crater`) and uses that context.

### 5. **Review Changes**
```
<leader>Aa
"Review my uncommitted changes for bugs"
```
Avante runs `jj diff` and analyzes changes.

### 6. **Generate Commit Message**
```
<leader>Aa
"Generate a commit message for my changes following team standards"
```
Uses team commit format from cursor-rules.

---

## 🎨 Sidebar Workflow

### Step-by-Step:
1. **Ask or Edit**: `<leader>Aa` or `<leader>Ae`
2. **Review**: Sidebar opens with AI suggestions
3. **Navigate**: Use `<Tab>` to jump between diffs
4. **Apply**:
   - `co` - Accept current suggestion
   - `ca` - Accept all suggestions
   - `cr` - Reject current suggestion
5. **Close**: Press `q` when done

### Visual Indicators:
- **Green highlight**: Incoming AI suggestion
- **Red highlight**: Current code being replaced
- **Quickfix list**: Jump to all changes with `:copen`

---

## 🤖 Agentic Mode Features

Avante can **autonomously**:
- ✅ Read files across your repos
- ✅ Run shell commands (e.g., `jj diff`, `pytest`)
- ✅ Search for patterns in code
- ✅ Check Obsidian notes for ticket context
- ✅ Navigate between related files

### Example Prompts:
```
"Find the bug causing test_handler to fail"
→ Avante will: read test file, run test, analyze error, suggest fix

"How does autoscaler scale up instances?"
→ Avante will: search autoscaler code, trace execution, explain flow

"Implement the feature from ORION-12345"
→ Avante will: read Obsidian note, understand requirements, suggest implementation
```

---

## 📁 Project-Specific Features

### Auto-Loaded Context

When you open a project, Avante automatically loads `avante.md`:

```bash
cd ~/sources/crater
nvim
# Avante now knows:
# - Crater is a Tornado REST API
# - It serves autoscaler endpoints
# - Team coding standards
# - JJ commands (not git)
```

### Projects Configured:
- `~/sources/autoscaler/avante.md` - GitLab runner autoscaling
- `~/sources/crater/avante.md` - Tornado REST API backend
- `~/sources/orion/avante.md` - VAST infrastructure

### Obsidian Notes Integration

Avante knows about your ticket notes:

**Location**: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/work/`

**Format**: `ORION-XXXXX.md`

**Tags**:
- `#autoscaler` - Autoscaler issues
- `#crater` - Crater issues
- `#orion` - ORION codebase issues
- `#comet` - Comet testing issues

**Usage**:
```
<leader>Aa
"I'm working on ORION-12345. Read my note and suggest next steps."
```

Avante will:
1. Find `ORION-12345.md`
2. Check tag matches current project
3. Read previous debugging attempts
4. Suggest solution based on note context

---

## 💡 Pro Tips

### Tip 1: Be Specific with Context
```
❌ "Fix this"
✅ "Refactor this handler to use early exit pattern and add error handling"
```

### Tip 2: Reference Ticket Numbers
```
"Working on ORION-12345"
→ Avante automatically checks for Obsidian note
```

### Tip 3: Use Multi-Repo Queries
```
"Show me how autoscaler calls crater's cluster_config endpoint"
→ Avante searches both repos and traces the API call
```

### Tip 4: Ask for Test Assistance
```
"Write pytest tests for this function with edge cases"
→ Avante generates comprehensive tests
```

### Tip 5: Review Before Applying
```
Always review AI suggestions carefully:
- Press <Tab> to navigate all changes
- Check each diff before accepting
- Use `co` for individual changes, `ca` for all
```

### Tip 6: Use Zen Mode for Fresh Projects
```bash
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

cd ~/sources/new-project
avante
# CLI-like interface - great for exploration
```

---

## 🔄 Provider System

### Automatic Selection (Hostname-Based)
- **Work laptop** (MB-928298.local): Uses **Copilot** (Claude Sonnet 4.5)
- **Other machines**: Uses **Ollama** (qwen2.5:14b-instruct)

### Fallback System
If Copilot fails (rate limit, timeout):
1. Automatically switches to Ollama
2. Shows notification
3. Attempts to reconnect after 10 minutes

### Check Current Provider
```vim
:lua print(require("avante").config.provider)
```

---

## 🛠️ Advanced Usage

### Custom Prompts
```
<leader>Aa
"You are an expert at [X]. Review this code for [Y] issues."
```

### Multi-Step Tasks
```
<leader>Aa
"Step 1: Find all handler functions
Step 2: Check which ones lack error handling
Step 3: Suggest fixes for each"
```

### Cross-File Refactoring
```
<leader>Aa
"Rename the 'process_event' function to 'handle_webhook_event' everywhere in this project"
```

### Code Explanation
```
Visual select complex code
<leader>Aa
"Explain this code step-by-step with examples"
```

---

## 🐛 Troubleshooting

### Sidebar Won't Open
```vim
:AvanteToggle
# If still broken:
:messages  " Check for errors
```

### AI Not Responding
1. Check provider: `:lua print(require("avante").config.provider)`
2. Check logs: `:messages`
3. Try fallback: `:lua require("avante").config.provider = "ollama"`

### Suggestions Not Applying
1. Ensure you're in normal mode
2. Try `<leader>Ar` to refresh
3. Check diff highlights (green = incoming, red = current)

### Obsidian Notes Not Found
```
<leader>Aa
"List all ORION ticket notes in my Obsidian vault"
# Verify path is correct
```

### Agentic Mode Too Slow
```lua
-- Disable some tools in avante.lua:
tools = {
    bash = { enabled = false },  -- Disable shell commands
}
```

---

## 🎓 Learning Path

### Beginner
1. ✅ Learn basic keybindings (`<leader>Aa`, `<leader>Ae`)
2. ✅ Practice accepting/rejecting suggestions (`co`, `cr`)
3. ✅ Ask simple questions about code

### Intermediate
1. ✅ Use visual selection with `<leader>Ae`
2. ✅ Reference ticket numbers in prompts
3. ✅ Navigate sidebar diffs efficiently

### Advanced
1. ✅ Use agentic mode for multi-file tasks
2. ✅ Combine Obsidian notes with code context
3. ✅ Create custom workflows with multi-step prompts
4. ✅ Use Zen mode for exploration

---

## 📚 Example Sessions

### Session 1: Fix a Bug
```
cd ~/sources/crater
nvim handler.py

# 1. Get context
<leader>Aa
"Explain what this handler does"

# 2. Find the bug
<leader>Aa
"I'm debugging ORION-12345 where requests timeout. Check my note and suggest where the bug might be."

# 3. Implement fix
Visual select problematic code
<leader>Ae
"Add timeout handling with exponential backoff"

# 4. Test
<leader>Aa
"Generate pytest tests for this timeout handling"
```

### Session 2: Implement Feature
```
cd ~/sources/autoscaler
nvim scaling.py

# 1. Read requirements
<leader>Aa
"Read ORION-12567 note and summarize the requirements"

# 2. Plan implementation
<leader>Aa
"Suggest how to implement this feature. What files need changes?"

# 3. Implement
<leader>Ae
"Implement the scaling policy from ORION-12567"

# 4. Commit
<leader>Aa
"Generate commit message following team standards"
```

### Session 3: Code Review
```
# After making changes
<leader>Aa
"Review my uncommitted changes (jj diff) for:
1. Bug patterns from team guidelines
2. Missing error handling
3. Performance issues"
```

---

## 🔗 Related Tools

**CodeCompanion** (also installed):
- Simpler, chat-based AI
- Custom prompts: `<leader>As` (surgical), `<leader>Ad` (debug), etc.
- Good for: quick edits, specific prompts
- Use when: Avante feels too heavy

**When to use what?**
- **Avante**: Multi-file work, exploration, complex debugging
- **CodeCompanion**: Quick edits, custom prompts, simple chat

---

## 📖 Quick Reference Card

```
ESSENTIAL COMMANDS:
<leader>Aa  Ask question
<leader>Ae  Edit selection
<leader>At  Toggle sidebar

SIDEBAR NAVIGATION:
<Tab>       Next diff
co          Accept current
ca          Accept all
cr          Reject current
q           Close sidebar

PRO TIPS:
- Mention ticket numbers → Avante checks Obsidian notes
- Visual select before <leader>Ae → Better context
- Use <Tab> to review all changes before accepting
- Be specific in prompts → Better suggestions

MULTI-REPO AWARENESS:
Avante knows about:
- ~/sources/autoscaler (GitLab autoscaling)
- ~/sources/crater (REST API backend)
- ~/sources/orion (VAST infrastructure)
- Obsidian work vault (ticket notes)

JJ INTEGRATION:
Avante uses JJ commands (not git):
- jj diff → show changes
- jj status → show status
- jj commit → commit changes
```

---

## 🎯 Summary

**Avante = AI Pair Programmer**

✅ Understands your entire workspace  
✅ Reads your ticket notes automatically  
✅ Follows your team standards  
✅ Uses JJ (not git)  
✅ Autonomous file access (agentic mode)  

**Start simple:**
1. `<leader>Aa` - Ask questions
2. `<leader>Ae` - Edit code
3. Review suggestions in sidebar
4. Accept with `co` or `ca`

**Level up:**
- Reference ticket numbers
- Use multi-repo queries
- Try Zen mode
- Combine with Obsidian notes

---

**Need help?** Check AVANTE-SETUP.md for configuration details.
