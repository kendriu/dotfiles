return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	build = "make",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},

	keys = {
		{ "<leader>Aa", "<cmd>AvanteAsk<CR>", desc = "Avante: Ask", mode = { "n", "v" } },
		{ "<leader>Ae", "<cmd>AvanteEdit<CR>", desc = "Avante: Edit", mode = "v" },
		{ "<leader>Ar", "<cmd>AvanteRefresh<CR>", desc = "Avante: Refresh" },
		{ "<leader>At", "<cmd>AvanteToggle<CR>", desc = "Avante: Toggle Sidebar" },
		{ "<leader>Af", "<cmd>AvanteFocus<CR>", desc = "Avante: Focus Sidebar" },
		{ "<leader>Az", "<cmd>lua require('avante.api').zen_mode()<CR>", desc = "Avante: Zen Mode" },
	},

	config = function()
		-- Get hostname-based adapter selection
		local ai_adapter = require("core.ai-adapter")
		local adapter = ai_adapter.get_adapter()

		-- Helper to read cursorfiles (same as CodeCompanion)
		local function read_cursorfile(filepath)
			local config_path = vim.fn.stdpath("config")
			local full_path = config_path .. "/cursor-rules/" .. filepath

			local f = io.open(full_path, "r")
			if not f then
				return "File not found: " .. full_path
			end

			local content = f:read("*all")
			f:close()

			-- Strip YAML frontmatter
			local stripped = content:gsub("^%-%-%-\n.-\n%-%-%-\n", "")
			return stripped
		end

		-- Build system prompt from cursorfiles
		local function build_system_prompt()
			local surgical = read_cursorfile("dev/rules/minimal-surgical-edits.mdc")
			local review = read_cursorfile("dev/rules/code-review-bug-patterns.mdc")
			local early_exit = read_cursorfile("dev/rules/prefer-early-exit.mdc")

			return [[You are an expert software engineer working on the ORION/Crater project.

## Team Coding Standards

### Minimal Surgical Edits
]] .. surgical .. [[

### Code Review Bug Patterns
]] .. review .. [[

### Early Exit Pattern
]] .. early_exit .. [[

## Important: JJ (Jujutsu) Version Control
This project uses JJ (Jujutsu) instead of Git. Key commands:
- `jj diff` - show uncommitted changes (no staging area)
- `jj diff --summary` - list changed files
- `jj log -r @ --no-graph -T 'bookmarks'` - show current bookmark (like git branch)
- `jj commit` - create a change
- JJ uses bookmarks instead of branches
- There is NO staging area - all changes are always visible until committed

When generating commit messages or reviewing changes, ALWAYS use JJ commands, not git.

## JJ Bookmark → Ticket Number Detection
**Ticket numbers are embedded in JJ bookmark names.**

Example bookmarks:
- `ORION-12345-fix-handler` → Ticket: ORION-12345
- `fix-ORION-12345` → Ticket: ORION-12345
- `crater/ORION-67890-refactor` → Ticket: ORION-67890

**Automatic detection workflow:**
1. Run: `jj log -r @ --no-graph -T 'bookmarks'` to get current bookmark
2. Extract ticket number pattern: `[A-Z]+-[0-9]+` (e.g., ORION-12345)
3. If ticket found, automatically check for Obsidian note: `~/Library/.../work/ORION-XXXXX.md`
4. If note exists, read it for context before suggesting changes

**When to auto-detect:**
- User asks for implementation suggestions
- User asks to review changes
- User asks to generate commit message
- User asks about current work/ticket

**Proactive usage:**
When user starts a request without mentioning a ticket, check the bookmark first.
If bookmark contains a ticket number, say: "I see you're working on ORION-XXXXX. Let me check your note for context..." then proceed.

## Obsidian Ticket Notes (Context Integration)
Ticket-related work is documented in Obsidian notes:
- **Location**: ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/work/
- **Format**: ORION-XXXXX.md (e.g., ORION-12345.md)
- **Tags**: Each note is tagged with the relevant project:
  - #crater - Crater backend issues
  - #autoscaler - Autoscaler infrastructure issues
  - #orion - ORION codebase issues
  - #comet - Comet testing framework issues
  
**When to check notes:**
- When a ticket number (ORION-XXXXX) is mentioned in the prompt
- When debugging complex issues (previous attempts may be documented)
- When implementing features (requirements and context may be in notes)
- When reviewing changes related to a specific ticket

**What notes contain:**
- Problem description and root cause analysis
- Previous debugging attempts and findings
- Implementation decisions and trade-offs
- Known issues and workarounds
- TODOs and follow-up tasks

**Proactive note usage:**
If working in ~/sources/crater and a ticket is mentioned, check for notes tagged with #crater.
If working in ~/sources/autoscaler and a ticket is mentioned, check for notes tagged with #autoscaler.

## Project Context
This is a multi-repo project with:
- autoscaler: Service scaling automation (GitLab runners)
- crater: Tornado REST API backend (GitLab integration)
- orion/comet: Testing framework (storage system testing)
- orion/pysrc: Python utilities and tooling

Always consider cross-repo impacts when making changes.]]
		end

		require("avante").setup({
			-- ✅ AGENTIC MODE (like Cursor/claude code)
			mode = "agentic", -- Autonomous coding with tools

			-- ✅ PROVIDER (hostname-based selection like CodeCompanion)
			provider = adapter, -- "copilot" or "ollama" based on hostname

			-- ✅ AUTO-SUGGESTIONS (disabled - too expensive)
			auto_suggestions_provider = "copilot", -- Keep on copilot only

			-- ✅ BEHAVIOUR
			behaviour = {
				auto_suggestions = false, -- Don't auto-suggest (expensive)
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false, -- Manual approval
				support_paste_from_clipboard = true, -- Image support
			},

			-- ✅ PROJECT INSTRUCTIONS FILE
			instructions_file = "avante.md", -- Auto-loaded per project

			-- ✅ PROVIDER CONFIGURATIONS
			providers = {
				-- Copilot (for work laptop: MB-928298.local)
				copilot = {
					endpoint = "https://api.githubcopilot.com",
					model = "claude-sonnet-4.5", -- Best available
					timeout = 30000,
					extra_request_body = {
						temperature = 0,
						max_tokens = 8192,
					},
				},

				-- Ollama (for personal machines / fallback)
				ollama = {
					endpoint = "127.0.0.1:11434/v1",
					model = "qwen2.5:14b-instruct", -- Same as CodeCompanion
					timeout = 30000,
					extra_request_body = {
						temperature = 0,
						max_tokens = 8192,
					},
				},
			},

			-- ✅ SYSTEM PROMPT (with team standards)
			system_prompt = build_system_prompt(),

			-- ✅ WINDOWS LAYOUT
			windows = {
				width = 35, -- Sidebar width (%)
				sidebar_header = {
					enabled = true,
					align = "center",
				},
				input = {
					prefix = "> ",
				},
				edit = {
					border = "rounded",
				},
			},

			-- ✅ HIGHLIGHTS
			highlights = {
				diff = {
					current = "DiffText",
					incoming = "DiffAdd",
				},
			},

			-- ✅ DIFF CONFIGURATION
			diff = {
				autojump = true, -- Auto jump to first diff
				list_opener = "copen", -- Use quickfix
			},

			-- ✅ VENDOR (disable for custom builds)
			vendor = false, -- We build from source

			-- ⚠️ REPOSITORY MAP (Avante feature CodeCompanion doesn't have!)
			-- This gives AI awareness of project structure
			repo_map = {
				enabled = true,
				-- Explicitly map the multi-repo workspace
				paths = {
					"~/sources/autoscaler",
					"~/sources/crater",
					"~/sources/orion/comet",
					"~/sources/orion/pysrc",
					-- Obsidian work vault (ticket notes)
					"~/Library/Mobile Documents/iCloud~md~obsidian/Documents/work",
				},
			},

			-- ✅ FILE SELECTOR
			file_selector = {
				provider = "native", -- Use Neovim's built-in picker
			},

			-- ✅ HINTS (inline suggestions)
			hints = {
				enabled = false, -- Don't show hints by default
			},

			-- ⚠️ TOOLS (Avante's agentic mode tools)
			-- These allow AI to autonomously access files/run commands
			tools = {
				-- Enable bash (for running jj commands, tests, etc.)
				bash = {
					enabled = true,
					-- Override git commands to use jj
					command_override = {
						["git diff"] = "jj diff",
						["git status"] = "jj status",
						["git log"] = "jj log",
						["git show"] = "jj show",
					},
				},

				-- Disable python (security risk if not needed)
				python = {
					enabled = false,
				},
			},

			-- ✅ KEYMAPS (use defaults + our customs above)
			mappings = {
				ask = "<leader>Aa",
				edit = "<leader>Ae",
				refresh = "<leader>Ar",
				toggle = {
					default = "<leader>At",
					debug = "<leader>Ad",
					hint = "<leader>Ah",
				},
				focus = "<leader>Af",
			},
		})

		-- ✅ SETUP FALLBACK HANDLING (like CodeCompanion)
		-- Monitor for Copilot errors and trigger fallback
		vim.api.nvim_create_autocmd("User", {
			pattern = "AvanteError",
			callback = function(event)
				local err = event.data and event.data.error
				if err and ai_adapter.is_fallback_error(err) then
					ai_adapter.trigger_fallback("Avante: Copilot unavailable")

					-- Update Avante provider
					vim.schedule(function()
						require("avante").config.provider = "ollama"
						vim.notify("Avante: Switched to Ollama. Please retry your request.", vim.log.levels.INFO)
					end)
				end
			end,
		})
	end,
}
