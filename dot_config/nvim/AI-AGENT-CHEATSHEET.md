# 🤖 AI Agent Cheatsheet - Complete Guide

Your AI assistant has multiple specialized modes. This guide teaches you how to use each one effectively.

---

## 📋 Quick Reference

| Keybinding | Mode | Best For | Example |
|------------|------|----------|---------|
| `<leader>Ac` | Toggle Chat | General AI conversation | "Explain this function" |
| `<leader>Aw` | Workspace | Cross-repo + notes queries | "Find ORION-1234 implementation" |
| `<leader>As` | Surgical Edit | Minimal code changes | Fix a specific bug |
| `<leader>Ad` | Debug ORION | Step-by-step debugging | Debug failing test |
| `<leader>Av` | Code Review | Review selection | Check code for bugs |
| `<leader>AR` | Review Changes | Review all jj changes | Pre-commit review |
| `<leader>AC` | Team Commit | Generate commit message | Auto-generate commit |
| `<leader>Ae` | Explain Error | Debug LSP errors | "Why this error?" |
| `<leader>Ai` | Inline Prompt | Quick inline edits | "Add type hints" |

---

## 🎯 Core Modes Explained

### 1. **Toggle Chat** (`<leader>Ac`)

**What it does:** Opens/closes persistent AI chat for general questions.

**Best for:**
- General code questions
- Explaining concepts
- Brainstorming solutions
- Multi-turn conversations

**Example usage:**
```
<leader>Ac
"Explain how async/await works in Python"
<Enter>

(AI responds)

"Show me an example with error handling"
<Enter>
```

**Tips:**
- Chat persists - you can continue conversations
- Use `gA` in visual mode to add code to chat
- Press `<leader>Ac` again to hide chat

---

### 2. **🌟 Workspace Agent** (`<leader>Aw`)

**What it does:** Searches across ALL your projects AND Obsidian notes simultaneously.

**Has access to:**
- ✅ Autoscaler codebase (~1.1GB)
- ✅ Crater codebase (~713MB)
- ✅ ORION comet testing framework (~18MB)
- ✅ ORION pysrc subsystems (~252MB)
- ✅ **Your Obsidian work vault** (ticket notes!)

**Best for:**
- Finding implementations across repos
- Connecting tickets to code
- Cross-repo architecture questions
- Accessing your ticket investigation notes

**Example queries:**

**Code + Documentation:**
```
<leader>Aw
"What did I document about ORION-1234 and where is it implemented?"
```

**Cross-repo:**
```
<leader>Aw
"How does autoscaler notify crater about scaling events?"
```

**Find in notes:**
```
<leader>Aw
"Show my investigation notes on the storage timeout issue"
```

**Architecture:**
```
<leader>Aw
"Explain the relationship between autoscaler's ScalingPolicy and crater's StorageController"
```

**Debugging:**
```
<leader>Aw
"Find where comet tests mock crater's scrubber module"
```

**Ticket context:**
```
<leader>Aw
"What was the decision behind the caching strategy? Check my notes"
```

**First-time use:** 
- First query takes 30-60s (builds index)
- Subsequent queries are fast
- Index is cached per Neovim session

---

### 3. **Surgical Edit** (`<leader>As`)

**What it does:** Makes minimal, precise code changes following team guidelines.

**Best for:**
- Fixing specific bugs
- Adding single features
- Refactoring small sections
- Following "minimal surgical edits" philosophy

**How to use:**
1. Select code in visual mode (optional)
2. Press `<leader>As`
3. Describe what to change
4. AI makes minimal changes only

**Example:**
```
(Visual select a function)
<leader>As
"Add error handling for None values"
```

**Philosophy:**
- Changes ONLY what you ask
- Doesn't "improve" beyond scope
- Follows team rules from cursor-rules

---

### 4. **Debug ORION** (`<leader>Ad`)

**What it does:** Step-by-step debugging workflow for ORION/comet test failures.

**Best for:**
- Failing comet tests
- ORION ticket debugging
- Test framework issues

**Example:**
```
<leader>Ad
"ORION-1234 test is failing with AssertionError"
```

**AI will ask for:**
- Ticket number
- Error message
- Test file path
- Then guide you through debugging

---

### 5. **Code Review** (`<leader>Av`)

**What it does:** Reviews selected code for bugs (not style).

**Best for:**
- Pre-commit review
- Checking specific functions
- Finding logic errors

**How to use:**
1. Select code in visual mode
2. Press `<leader>Av`
3. AI reviews and reports issues

**Focus:**
- ✅ Bugs and correctness
- ✅ Logic errors
- ✅ Edge cases
- ❌ NOT style/formatting

---

### 6. **Review All Changes** (`<leader>AR`)

**What it does:** Reviews all uncommitted changes in working copy (jj diff).

**Best for:**
- Pre-commit review
- Checking entire change set
- Finding cross-file issues

**Example:**
```
(Make changes to multiple files)
<leader>AR
```

**AI reviews:**
- All files in jj diff
- Cross-file impacts
- Common bug patterns

---

### 7. **Team Commit Message** (`<leader>AC`)

**What it does:** Generates commit message following team standards.

**Best for:**
- Creating standardized commits
- Auto-extracting component from files
- Including ticket IDs

**How it works:**
1. Make changes
2. Press `<leader>AC`
3. AI reads jj diff + bookmark
4. Generates commit following team rules

**Auto-detects:**
- Component/subsection (e.g., "crater/scrubber")
- Ticket ID from bookmark name (e.g., ORION-1234)
- Changed files priority (scrubber > handler > other)

**Output format:**
```
crater/scrubber: Fix null pointer in data validation (ORION-1234)

- Add null check in Scrubber.validate_data()
- Update tests to cover null case
- Handle edge case when input is empty
```

---

### 8. **Explain Error** (`<leader>Ae`)

**What it does:** Explains LSP error at cursor position.

**Best for:**
- Understanding compiler errors
- Debugging type errors
- Getting fix suggestions

**How to use:**
1. Move cursor to line with error/warning
2. Press `<leader>Ae`
3. AI explains error + suggests fix

**Shows:**
- Error message and severity
- Code context (5 lines)
- Why it's happening
- How to fix it

---

### 9. **Inline Prompt** (`<leader>Ai`)

**What it does:** Quick inline AI command (you type the prompt).

**Best for:**
- One-off quick edits
- Custom prompts
- Rapid iterations

**Example:**
```
(Visual select code)
<leader>Ai add type hints<Enter>
```

**Difference from surgical edit:**
- More flexible (any prompt)
- Less team-rule enforcement
- Faster for simple tasks

---

## 🎓 Learning Path

### Week 1: Master the Basics
1. **Day 1-2:** Get comfortable with `<leader>Ac` (toggle chat)
   - Ask general questions
   - Explain code snippets
   - Practice multi-turn conversations

2. **Day 3-4:** Learn `<leader>Aw` (workspace agent)
   - Try code queries: "Where is X implemented?"
   - Try doc queries: "What did I write about ORION-1234?"
   - Combine both: "Connect ticket to code"

3. **Day 5-7:** Practice editing modes
   - `<leader>As` - Surgical edits
   - `<leader>Ae` - Explain errors
   - `<leader>Av` - Review code

### Week 2: Advanced Workflows
1. **Use before commits:**
   - `<leader>AR` - Review all changes
   - `<leader>AC` - Generate commit message

2. **Use during debugging:**
   - `<leader>Ad` - Debug ORION workflow
   - `<leader>Ae` - Explain errors
   - `<leader>Aw` - Find related code + notes

3. **Build habits:**
   - Always review before commit (`<leader>AR`)
   - Use workspace agent for cross-repo questions
   - Let AI generate commit messages

---

## 💡 Pro Tips

### Workspace Agent Power User Tips

**1. Be specific about what you want:**
❌ "Tell me about autoscaler"
✅ "Where is ScalingPolicy.evaluate() implemented in autoscaler?"

**2. Combine code + documentation:**
✅ "What was my investigation for ORION-1234 and what code changed?"
✅ "Show my notes on caching + the implementation"

**3. Use for architecture questions:**
✅ "How does data flow from autoscaler to crater?"
✅ "What are all the integration points between these systems?"

**4. Reference your notes:**
✅ "Based on my notes, what was the root cause of the timeout issue?"
✅ "What decisions did I document about the retry logic?"

**5. Cross-reference:**
✅ "Find all comet tests related to ORION-1234"
✅ "Show code mentioned in my ORION-1234 notes"

### General AI Tips

**1. Use visual selection:**
- Select code before calling AI
- More context = better results

**2. Be conversational:**
- Multi-turn chats are fine
- Ask follow-up questions
- Refine your request

**3. Verify AI suggestions:**
- Always review generated code
- Test changes thoroughly
- AI can be wrong!

**4. Use the right tool:**
- Small fix → Surgical edit
- Big question → Workspace agent
- Quick edit → Inline prompt

---

## 🔍 Troubleshooting

### "Workspace agent is slow"
- **First query:** 30-60s is normal (building index)
- **Still slow:** Check workspace size (currently ~2GB)
- **Solution:** Add more ignore patterns if needed

### "AI doesn't find my notes"
- **Check path:** Obsidian vault must be at:
  `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/work`
- **Restart Neovim** after config changes
- **Try specific:** "Find note titled ORION-1234"

### "Commit message missing ticket ID"
- AI extracts from jj bookmark name
- Bookmark must contain pattern: `ORION-1234`
- Example bookmark: `ORION-1234-fix-cache`

### "Surgical edit changed too much"
- Use more specific prompt
- Select exact code section first
- Try: "Only change the error handling, nothing else"

---

## 🎯 Common Workflows

### 1. Starting a new ticket
```
# Open your ticket note
<leader>of
(find ORION-1234 note)

# Query workspace for context
<leader>Aw
"What code is related to ORION-1234? Check my notes and codebase"

# Start coding...
```

### 2. Debugging a test failure
```
# Debug workflow
<leader>Ad
"ORION-1234 test failing: AssertionError in test_scrubber.py"

# Find test implementation
<leader>Aw
"Where is test_scrubber.py and what does my investigation note say?"

# Fix and review
(make changes)
<leader>AR
```

### 3. Pre-commit workflow
```
# Review all changes
<leader>AR
(AI checks for bugs)

# Generate commit message
<leader>AC
(AI creates standardized message)

# Commit
:!jj commit -m "<paste AI message>"
```

### 4. Cross-repo investigation
```
<leader>Aw
"How does autoscaler's timeout handler interact with crater's retry logic?"

(AI searches both repos + your notes)

# Add findings to your Obsidian note
<leader>od  # Open daily note
(document findings)
```

---

## 📊 Cheat Sheet Summary

### By Frequency (Most Used First)

1. **`<leader>Aw`** - Workspace agent (use constantly!)
2. **`<leader>Ac`** - Toggle chat (daily)
3. **`<leader>Ae`** - Explain errors (when stuck)
4. **`<leader>AR`** - Review changes (before commit)
5. **`<leader>AC`** - Commit message (every commit)
6. **`<leader>As`** - Surgical edit (targeted fixes)
7. **`<leader>Av`** - Review selection (code review)
8. **`<leader>Ad`** - Debug ORION (ticket debugging)
9. **`<leader>Ai`** - Inline prompt (quick edits)

### By Use Case

**Learning codebase:**
- `<leader>Aw` - "Where is X?"
- `<leader>Aw` - "How does Y work?"
- `<leader>Aw` - "Show architecture of Z"

**Writing code:**
- `<leader>As` - Surgical edits
- `<leader>Ai` - Quick changes
- `<leader>Ae` - Fix errors

**Before commit:**
- `<leader>AR` - Review changes
- `<leader>AC` - Commit message

**Debugging:**
- `<leader>Ad` - ORION workflow
- `<leader>Aw` - Find related code
- `<leader>Ae` - Explain errors

**Documentation:**
- `<leader>Aw` - Query notes
- `<leader>Aw` - Connect tickets to code

---

## 🚀 Next Steps

1. **Restart Neovim** to load new config
2. **Try workspace agent first:** `<leader>Aw` → "What projects do you have access to?"
3. **Query your notes:** `<leader>Aw` → "List recent ORION tickets in my notes"
4. **Practice daily:** Use workspace agent for every cross-repo question

**Remember:** The AI has access to ALL your code AND your Obsidian notes. Use it!

---

## 📚 Related Docs

- `WORKSPACE-AGENT-2026-02-24.md` - Detailed workspace config
- `AI-IMPROVEMENTS-2026-02-24.md` - Recent improvements changelog
- `JJ-INTEGRATION-2026-02-24.md` - Jujutsu integration details
- `CHEATSHEET.md` - General Neovim cheatsheet

---

## 💎 Inline Diff Viewer (Already Enabled!)

Your CodeCompanion has **side-by-side visual diffs** built-in!

### How to Use:
```
1. Select code in visual mode (V)
2. Press <leader>Ai your prompt<Enter>
3. See side-by-side diff:
   ┌─────────────┬─────────────┐
   │ ORIGINAL    │ AI CHANGE   │
   └─────────────┴─────────────┘
```

### Quick Test:
```
(Select a function)
<leader>Ai add error handling<Enter>
→ See beautiful vertical diff!
```

**Layout:** Vertical (side-by-side)  
**Config:** Already in `codecompanion.lua` as `layout = "vertical"`

See `INLINE-DIFF-VIEWER.md` for complete guide.
