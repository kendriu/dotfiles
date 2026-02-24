return {
	"letieu/jira.nvim",
	cmd = { "Jira", "JiraOpen" }, -- Lazy load on these commands
	keys = {
		{ "<leader>J", "<cmd>Jira<cr>", desc = "Open Jira board" },
	},
	config = function()
		-- Read from mise environment variables
		require("jira").setup({
			jira = {
				base = os.getenv("JIRA_BASE_URL"),
				email = os.getenv("JIRA_EMAIL"),
				token = os.getenv("JIRA_TOKEN"),
				type = os.getenv("JIRA_AUTH_TYPE") or "basic",
				api_version = os.getenv("JIRA_API_VERSION") or "3",
				limit = 200,
			},
			-- Put "My Open Issues" first so it's the default
			queries = {
				["My Open Issues"] = "assignee = 'andrzej.skupien@vastdata.com' AND status NOT IN (Closed, Integrated, Debug) ORDER BY priority DESC",
			},
		})

		-- Override the create_window function to use current window instead of float
		local board_ui = require("jira.board.ui")
		local state = require("jira.board.state")
		local original_create_window = board_ui.create_window

		board_ui.create_window = function()
			-- Create buffer for jira board
			state.buf = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
			vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = state.buf })
			vim.api.nvim_set_option_value("modifiable", false, { buf = state.buf })
			vim.api.nvim_buf_set_name(state.buf, "Jira Board")

			-- Use current window instead of creating a float
			state.win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(state.win, state.buf)

			vim.api.nvim_win_set_hl_ns(state.win, state.ns)
			vim.api.nvim_set_option_value("cursorline", true, { win = state.win })

			-- No dim window needed for non-float
			state.dim_win = nil
		end

		-- Override issue view to open in split instead of float
		local issue_module = require("jira.issue")
		local original_issue_open = issue_module.open

		issue_module.open = function(issue_key, initial_tab)
			-- Create horizontal split below
			vim.cmd("belowright split")
			-- Call original open which will create the window
			-- We need to intercept the window creation
			local issue_state = require("jira.issue.state")
			local prev_win = vim.api.nvim_get_current_win()

			local util = require("jira.common.util")
			local common_ui = require("jira.common.ui")
			local jira_api = require("jira.jira-api.api")
			local render = require("jira.issue.render")

			util.setup_static_highlights()
			common_ui.start_loading("Fetching task " .. issue_key .. "...")

			issue_state.issue = nil
			issue_state.comments = {}
			issue_state.active_tab = initial_tab or "description"
			issue_state.buf = nil
			issue_state.win = nil
			issue_state.prev_win = prev_win

			jira_api.get_issue(issue_key, function(issue, err)
				if err then
					vim.schedule(function()
						common_ui.stop_loading()
						vim.notify("Error fetching issue: " .. err, vim.log.levels.ERROR)
					end)
					return
				end

				jira_api.get_comments(issue_key, function(comments, c_err)
					vim.schedule(function()
						common_ui.stop_loading()
						if c_err then
							vim.notify("Error fetching comments: " .. c_err, vim.log.levels.WARN)
						end

						issue_state.issue = issue
						issue_state.comments = comments or {}

						-- Create buffer in current split window instead of floating
						local buf = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
						vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
						vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
						vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
						vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
						vim.api.nvim_buf_set_name(buf, "Jira: " .. issue.key)

						-- Use current window (the split we created)
						local win = vim.api.nvim_get_current_win()
						vim.api.nvim_win_set_buf(win, buf)

						issue_state.buf = buf
						issue_state.win = win

						render.render_content()

						-- Setup all keymaps (from issue module)
						local opts = { noremap = true, silent = true, buffer = buf }
						
						-- Quit
						vim.keymap.set("n", "q", function()
							if issue_state.win and vim.api.nvim_win_is_valid(issue_state.win) then
								vim.api.nvim_win_close(issue_state.win, true)
								if issue_state.prev_win and vim.api.nvim_win_is_valid(issue_state.prev_win) then
									vim.api.nvim_set_current_win(issue_state.prev_win)
								end
							end
						end, opts)

						-- Switch Tabs
						vim.keymap.set("n", "<Tab>", function()
							local next_tab = { description = "comments", comments = "help", help = "description" }
							issue_state.active_tab = next_tab[issue_state.active_tab] or "description"
							render.render_content()
						end, opts)

						vim.keymap.set("n", "D", function()
							issue_state.active_tab = "description"
							render.render_content()
						end, opts)

						vim.keymap.set("n", "C", function()
							issue_state.active_tab = "comments"
							render.render_content()
						end, opts)

						vim.keymap.set("n", "H", function()
							issue_state.active_tab = "help"
							render.render_content()
						end, opts)

						-- Edit
						vim.keymap.set("n", "i", function()
							if issue_state.active_tab == "description" then
								require("jira.edit").open(issue_state.issue.key)
								return
							end
							vim.notify("Switch to Comments or Description tab", vim.log.levels.WARN)
						end, opts)

						-- Refresh
						vim.keymap.set("n", "r", function()
							require("jira.issue").refresh()
						end, opts)
					end)
				end)
			end)
		end

		-- Override the open function to use ORION as default and JQL view with "My Open Issues"
		local board = require("jira.board")
		local original_open = board.open

		board.open = function(project_key)
			-- Default to ORION project if not specified
			project_key = project_key or "ORION"

			-- Call original open to validate and setup
			local jc = require("jira.common.config").options.jira
			if not jc.base or jc.base == "" or not jc.email or jc.email == "" or not jc.token or jc.token == "" then
				vim.notify(
					"Jira configuration is missing. Please run setup() with base, email, and token.",
					vim.log.levels.ERROR
				)
				return
			end

			-- Set the current query to "My Open Issues" before loading
			state.current_query = "My Open Issues"
			local queries = require("jira.common.config").options.queries or {}
			state.custom_jql = queries["My Open Issues"]

			-- Load JQL view directly with "My Open Issues" query
			board.load_view(project_key, "JQL")
		end

		-- Create a command to easily open Jira with defaults
		vim.api.nvim_create_user_command("JiraOpen", function()
			require("jira.board").open()
		end, { desc = "Open Jira board with ORION project and My Open Issues query" })
	end,
}
