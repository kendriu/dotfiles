return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim", -- use Snacks instead of Telescope
	},
	event = "VeryLazy",
	keys = {
		{ "<leader>Ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "AI: Toggle Chat" },
		{ "<leader>An", "<cmd>CodeCompanionChat<CR>", desc = "AI: New Chat" },
		{ "<leader>Aa", "<cmd>CodeCompanionActions<CR>", desc = "AI: Action Palette" },
		{ "<leader>Ai", "<cmd>CodeCompanion ", desc = "AI: Inline (type prompt)" }, -- user appends prompt
		{ "<leader>Am", "<cmd>CodeCompanionActions<CR>", desc = "AI: Model / Strategy" },
		{
			"<leader>Ar",
			mode = "v",
			"<cmd>'<,'>CodeCompanion /<CR>",
			desc = "AI: Run on selection (use / prompts)",
		},
		{ "gA", mode = "v", "<cmd>CodeCompanionChat Add<CR>", desc = "AI: Add selection to Chat" },
		-- Team workflow shortcuts
		{ "<leader>As", "<cmd>CodeCompanion /surgical<CR>", desc = "AI: Surgical Edit Mode" },
		{ "<leader>Ad", "<cmd>CodeCompanion /debug<CR>", desc = "AI: Debug ORION Ticket" },
		{ "<leader>Av", "<cmd>CodeCompanion /review<CR>", mode = { "n", "v" }, desc = "AI: Code Review (Selection)" },
		{ "<leader>AR", "<cmd>CodeCompanion /review-changes<CR>", desc = "AI: Review All Changes" },
		{ "<leader>AC", "<cmd>CodeCompanion /team-commit<CR>", desc = "AI: Team Commit Message" },
	},

	config = function()
		-- Helper function to read cursorfiles and extract content
		local function read_cursorfile(filepath)
			local config_path = vim.fn.stdpath("config")
			local full_path = config_path .. "/cursor-rules/" .. filepath
			
			-- Check if file exists
			local f = io.open(full_path, "r")
			if not f then
				return "File not found: " .. full_path
			end
			
			local content = f:read("*all")
			f:close()
			
			-- Strip YAML frontmatter (between --- ... ---)
			local stripped = content:gsub("^%-%-%-\n.-\n%-%-%-\n", "")
			
			return stripped
		end

		-- Use centralized AI adapter system
		local ai_adapter = require("core.ai-adapter")
		local adapter = ai_adapter.get_adapter()

		require("codecompanion").setup({
			strategies = {
				-- Chat strategy (chat buffer)
				chat = {
					adapter = adapter,
				},
				-- Inline completions (inline assistant)
				inline = {
					adapter = adapter,
				},
				-- Agents
				agent = {
					adapter = adapter,
				},
			},
			
			-- Adapter configuration
			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "qwen2.5:14b-instruct",
							},
						},
					})
				end,
				-- Custom Copilot adapter with Ollama fallback
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						callbacks = {
							on_error = function(err)
								-- Check if rate limit error using centralized function
								if ai_adapter.is_rate_limit_error(err) then
									ai_adapter.trigger_fallback("Copilot rate limit hit!")
								end
							end,
						},
					})
				end,
			},

			-- Display configuration (using Snacks picker)
			display = {
				action_palette = {
					opts = {
						show_preset_prompts = false, -- Hide built-in prompts (we have custom ones)
					},
				},
				chat = {
					provider = "snacks",
				},
				inline = {
					provider = "snacks",
				},
			},

			-- Logging configuration
			opts = {
				log_level = "INFO", -- Options: "TRACE", "DEBUG", "INFO", "WARN", "ERROR"
			},

			-- Custom prompts from team cursorfiles
			prompt_library = {
				["Surgical Edit"] = {
					strategy = "chat",
					description = "Make minimal, surgical code changes following team guidelines",
					opts = {
						modes = { "v" },
						is_slash_cmd = true,
						alias = "surgical",
						auto_submit = false,
					},
					prompts = {
						{
							role = "system",
							content = function()
								local rules = read_cursorfile("dev/rules/minimal-surgical-edits.mdc")
								return [[You are an expert code editor following strict surgical editing principles.

Follow these team rules from minimal-surgical-edits.mdc:

]] .. rules .. [[

Remember: Implement with surgical precision, not "improve" beyond request scope.]]
							end,
						},
						{
							role = "user",
							content = function(context)
								if context.selection then
									return "Please make the following change using surgical editing principles:\n\n"
										.. context.selection
								else
									return "Please make changes using surgical editing principles. What would you like to modify?"
								end
							end,
							opts = { contains_code = true },
						},
					},
				},

				["Debug ORION"] = {
					strategy = "chat",
					description = "Debug ORION/Comet test framework issues step-by-step",
					opts = {
						is_slash_cmd = true,
						alias = "debug",
						auto_submit = false,
					},
					prompts = {
						{
							role = "system",
							content = function()
								local workflow = read_cursorfile("infra/commands/debug-orion.md")
								return [[You are an expert at debugging VAST comet test framework issues.

Follow this team workflow from debug-orion.md:

]] .. workflow .. [[

Always follow the step-by-step process and ask for required information if missing.]]
							end,
						},
						{
							role = "user",
							content = "I need help debugging an ORION ticket. What information do you need from me?",
						},
					},
				},

				["Code Review"] = {
					strategy = "chat",
					description = "Review selected code for common bug patterns and issues",
					opts = {
						modes = { "v" },
						is_slash_cmd = true,
						alias = "review",
						auto_submit = true,
					},
					prompts = {
						{
							role = "system",
							content = function()
								local patterns = read_cursorfile("dev/rules/code-review-bug-patterns.mdc")
								return [[You are an expert code reviewer focusing on bug identification.

Use these team bug patterns from code-review-bug-patterns.mdc:

]] .. patterns .. [[

Provide actionable, specific feedback focused on bugs and correctness, not style.]]
							end,
						},
						{
							role = "user",
							content = function(context)
								if context.selection then
									return "Please review this code for bugs and issues:\n\n" .. context.selection
								else
									return "Please review code for bugs and issues. What code would you like me to review?"
								end
							end,
							opts = { contains_code = true },
						},
					},
				},

				["Review Changes"] = {
					strategy = "chat",
					description = "Review all changed files for common bug patterns and issues",
					opts = {
						is_slash_cmd = true,
						alias = "review-changes",
						auto_submit = false,
					},
					prompts = {
						{
							role = "system",
							content = function()
								local patterns = read_cursorfile("dev/rules/code-review-bug-patterns.mdc")
								return [[You are an expert code reviewer focusing on bug identification.

Use these team bug patterns from code-review-bug-patterns.mdc:

]] .. patterns .. [[

Review ALL changes in the diff comprehensively. For each file:
1. Identify specific bugs and issues
2. Point to exact line numbers
3. Explain why it's a problem
4. Suggest how to fix it

Focus on bugs and correctness, not style. Be thorough but concise.]]
							end,
						},
						{
							role = "user",
							content = function()
								-- Get staged diff
								local diff = vim.fn.system("git diff --staged")
								if diff == "" then
									-- If nothing staged, get unstaged diff
									diff = vim.fn.system("git diff")
								end
								if diff == "" then
									return "No changes detected. Please make some changes or stage them with `git add` first."
								end
								return "Please review all these changes for bugs and issues:\n\n```diff\n" .. diff .. "\n```"
							end,
						},
					},
				},

				["Early Exit Refactor"] = {
					strategy = "inline",
					description = "Refactor nested loops to use early exit pattern",
					opts = {
						modes = { "v" },
						is_slash_cmd = true,
						alias = "early-exit",
						auto_submit = true,
					},
					prompts = {
						{
							role = "system",
							content = function()
								local pattern = read_cursorfile("dev/rules/prefer-early-exit.mdc")
								return [[Refactor code to use early exit pattern for better readability.

Follow these team guidelines from prefer-early-exit.mdc:

]] .. pattern
							end,
						},
						{
							role = "user",
							content = function(context)
								if context.selection then
									return "Refactor to use early exit pattern:\n\n" .. context.selection
								else
									return "Refactor code to use early exit pattern. What code would you like to refactor?"
								end
							end,
							opts = { contains_code = true },
						},
					},
				},

				["Team Commit Message"] = {
					strategy = "chat",
					description = "Generate commit message following team standards",
					opts = {
						is_slash_cmd = true,
						alias = "team-commit",
						auto_submit = false,
					},
					prompts = {
						{
							role = "system",
							content = function()
								local standards = read_cursorfile("infra/commands/commit-changes.md")
								return [[You are an expert at writing high-quality git commit messages following strict team standards.

Follow these team commit standards from commit-changes.md:

]] .. standards .. [[

Generate a commit message that strictly follows ALL the rules above.]]
							end,
						},
						{
							role = "user",
							content = function()
								-- Get current branch name
								local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
								
								-- Extract ticket number (ORION-XXXXX or similar pattern)
								local ticket_id = branch:match("([A-Z]+%-[0-9]+)")
								
								-- Get staged diff
								local diff = vim.fn.system("git diff --staged")
								if diff == "" then
									diff = vim.fn.system("git diff")
								end
								if diff == "" then
									return "No changes detected. Please stage your changes with `git add` first."
								end
								
								-- Extract component/subsection from changed files
								-- Priority: scrubber > handler > other (skip __init__)
								local files = vim.fn.system("git diff --staged --name-only 2>/dev/null || git diff --name-only")
								local component_subsection = nil
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
								
								-- Select by priority
								component_subsection = scrubber_candidate or handler_candidate or other_candidate
								
								local prompt = "Generate a commit message for these changes:\n\n"
								
								if component_subsection then
									prompt = prompt .. "**Component/Subsection:** " .. component_subsection .. "\n\n"
									prompt = prompt .. "The commit message MUST start with: `" .. component_subsection .. ": `\n\n"
								end
								
								if ticket_id then
									prompt = prompt .. "**Ticket ID (from branch):** " .. ticket_id .. "\n\n"
									prompt = prompt .. "Make sure to include (" .. ticket_id .. ") at the end of the summary line.\n\n"
								else
									prompt = prompt .. "**Note:** Could not find ticket ID in branch name '" .. branch .. "'. "
									prompt = prompt .. "Please include the ticket ID in the commit message if available.\n\n"
								end
								
								prompt = prompt .. "```diff\n" .. diff .. "\n```"
								
								return prompt
							end,
						},
					},
				},
			},
		})

		-- Convenience: ":cc" expands to :CodeCompanion
		vim.cmd([[cabbrev cc CodeCompanion]])
	end,
}
