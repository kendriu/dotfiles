# Avante Configuration Refactoring Summary

## ✅ Completed Refactoring

Separated **common knowledge** (centralized) from **project-specific knowledge** (per-project).

---

## 📍 Central Configuration (`avante.lua`)

**Location**: `/Users/andrzej.skupien/.config/nvim/lua/plugins/avante.lua`

**Contains (applies to ALL projects)**:

### 1. Team Coding Standards
- Minimal surgical edits (from cursor-rules)
- Code review bug patterns (from cursor-rules)
- Early exit patterns (from cursor-rules)

### 2. JJ Version Control Knowledge
- All JJ commands and how they work
- "No staging area" concept
- "Bookmarks instead of branches" concept
- When to use JJ commands vs git

### 3. JJ Bookmark → Ticket Detection
- Pattern extraction: `[A-Z]+-[0-9]+`
- Example bookmark formats
- Automatic detection workflow
- When to auto-detect tickets
- Proactive "I see you're working on X" behavior

### 4. Obsidian Integration Mechanics
- File location: `~/Library/Mobile Documents/.../work/`
- File format: `ORION-XXXXX.md`
- Available tags: `#crater`, `#autoscaler`, `#orion`, `#comet`
- When to check notes (generic rules)
- What notes contain (generic content types)
- Proactive note usage rules

### 5. Multi-Repo Context
- High-level overview of all projects
- Cross-repo impact awareness

---

## 📁 Per-Project Configuration (`avante.md`)

**Locations**: 
- `~/sources/autoscaler/avante.md` (116 lines, was 142)
- `~/sources/crater/avante.md` (186 lines, was 203)
- `~/sources/orion/avante.md` (118 lines, was 139)

**Contains (project-specific only)**:

### 1. Your Role
- Domain expertise for this specific project
- Unique per project (DevOps vs Backend vs Systems Engineer)

### 2. Your Mission
- Project-specific goals and focus areas
- Technology-specific requirements

### 3. Project Context
- What this project does (unique purpose)
- Key architectural concepts
- Monitoring/deployment specifics

### 4. Technology Stack
- Languages, frameworks, libraries specific to this project
- No overlap between projects

### 5. Architecture Guidelines
- Project-specific patterns
- API integration details (e.g., how autoscaler calls crater)
- Database usage patterns
- External integrations unique to this project

### 6. Testing Requirements
- Project-specific testing tools and approaches
- Coverage requirements
- Mock strategies

### 7. Cross-Service Dependencies
- How THIS project relates to others
- Unique relationships per project

### 8. Common Patterns
- Code examples specific to this project's stack
- Best practices for this technology

### 9. Debugging Checklist
- Project-specific debugging steps
- Tools and metrics specific to this project

### 10. Obsidian Notes
- **ONLY the project tag**: `#autoscaler`, `#crater`, `#orion`/`#comet`/`#pysrc`
- No duplication of location, format, or mechanics (in central config)

---

## 📊 Reduction in Duplication

| File | Before | After | Reduction |
|------|--------|-------|-----------|
| `autoscaler/avante.md` | 142 lines | 116 lines | -26 lines (-18%) |
| `crater/avante.md` | 203 lines | 186 lines | -17 lines (-8%) |
| `orion/avante.md` | 139 lines | 118 lines | -21 lines (-15%) |

**Total**: Removed ~64 lines of duplicated content

---

## 🎯 What This Achieves

### ✅ **Single Source of Truth**
- JJ knowledge: Only in `avante.lua`
- Obsidian mechanics: Only in `avante.lua`
- Ticket detection: Only in `avante.lua`

### ✅ **Easier Maintenance**
- Update JJ commands once → applies everywhere
- Update Obsidian path once → applies everywhere
- Update ticket detection logic once → applies everywhere

### ✅ **Cleaner Project Files**
- Focus only on project-specific technical details
- No redundant "how JJ works" explanations
- Shorter, more focused instructions

### ✅ **Better AI Understanding**
- Central config loaded first (always available)
- Project config adds specific context on top
- No conflicting information

---

## 🔄 Information Flow

```
User opens project → Avante loads:

1. Central config (avante.lua):
   ├─ Team coding standards
   ├─ JJ knowledge
   ├─ Ticket detection rules
   └─ Obsidian integration

2. Project config (avante.md):
   ├─ Role/mission for THIS project
   ├─ Tech stack for THIS project
   ├─ Architecture for THIS project
   ├─ Testing for THIS project
   └─ Obsidian tag: #thisproject

Result: AI knows both general rules AND project specifics
```

---

## 📝 Example: How It Works

### Before (Duplicated):
```
avante.lua:
  - JJ commands explanation
  - Obsidian location

autoscaler/avante.md:
  - JJ commands explanation ← DUPLICATE
  - Obsidian location ← DUPLICATE
  - autoscaler tech stack

crater/avante.md:
  - JJ commands explanation ← DUPLICATE
  - Obsidian location ← DUPLICATE
  - crater tech stack
```

### After (Centralized):
```
avante.lua:
  - JJ commands explanation ✅
  - Obsidian location ✅
  - Ticket detection ✅

autoscaler/avante.md:
  - autoscaler tech stack only
  - #autoscaler tag

crater/avante.md:
  - crater tech stack only
  - #crater tag
```

---

## ✅ Verification

Test that Avante still knows common knowledge in each project:

```bash
cd ~/sources/crater
nvim
<leader>Aa
"What JJ command shows uncommitted changes?"
# Should answer: jj diff

"Where are my Obsidian ticket notes?"
# Should answer: ~/Library/Mobile Documents/.../work/

"How does Crater relate to Autoscaler?"
# Should answer: Crater serves API, Autoscaler consumes it
```

---

## 🎓 Key Principle

**Central config = HOW things work**  
**Project config = WHAT this project does**

- HOW to detect tickets → Central
- HOW to use JJ → Central
- HOW to read Obsidian notes → Central
- WHAT this project's tech stack is → Project
- WHAT this project's API does → Project
- WHAT this project's architecture is → Project
