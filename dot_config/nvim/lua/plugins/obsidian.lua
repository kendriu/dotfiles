return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = false,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},
	keys = {
		-- CORE NAVIGATION
		{ "<leader>on", "<cmd>Obsidian new<CR>", desc = "New note" },
		{ "<leader>of", "<cmd>Obsidian quick_switch<CR>", desc = "Find note" },
		{ "<leader>os", "<cmd>Obsidian search<CR>", desc = "Search notes" },
		{ "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks" },
		{ "<leader>oo", "<cmd>Obsidian open<CR>", desc = "Open in App" },

		-- DAILY NOTES
		{ "<leader>od", "<cmd>Obsidian today<CR>", desc = "Daily note" },
		{ "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Yesterday note" },

		-- LINKING / STRUCTURE
		{ "<leader>ol", "<cmd>Obsidian links<CR>", desc = "Link selection" },
		{ "<leader>ot", "<cmd>Obsidian template<CR>", desc = "Insert template" },
		{ "<leader>or", "<cmd>Obsidian rename<CR>", desc = "Rename note" },
		{ "<leader>oL", "<cmd>Obsidian link<CR>", desc = "Link note" },

		-- TASKS
		{
			"<leader>oc",
			function()
				require("obsidian").actions.set_checkbox("x")
			end,
			desc = "Mark done",
		},
		-- Other
		{ "gf", "<cmd>Obsidian follow_link<CR>", desc = "Follow link" },
	},
	config = function()
		require("obsidian").setup({
			legacy_commands = false,
			ui = {
				enable = true,
				hl_groups = {
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianDone = { bold = true, fg = vim.api.nvim_get_hl(0, { name = "RenderMarkdownChecked" }).fg },
					ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
					ObsidianTilde = { bold = true, fg = "#ff5370" },
					ObsidianImportant = { bold = true, fg = "#d73128" },
					ObsidianBullet = { bold = true, fg = "#89ddff" },
					ObsidianRefText = { underline = true, fg = "#c792ea" },
					ObsidianExtLinkIcon = { fg = "#c792ea" },
					ObsidianTag = { italic = true, fg = "#89ddff" },
					ObsidianBlockID = { italic = true, fg = "#89ddff" },
					ObsidianHighlightText = { bg = "#75662e" },
				},
			},
			workspaces = {
				{
					name = "work",
					path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/work",
				},

				{
					name = "personal",
					path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal",
				},
			},
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
			end,
		})

		-- SMART ACTION keymap
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.keymap.set("n", "<CR>", function()
					require("obsidian").util.smart_action()
				end, { buffer = true, desc = "Obsidian smart action" })
			end,
		})
	end,
}
