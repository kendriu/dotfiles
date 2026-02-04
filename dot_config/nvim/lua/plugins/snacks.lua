return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.smart()" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
					{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
					{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = "󰏗 ", key = "m", desc = "Mason", action = ":Mason" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{
					section = "recent_files",
					cwd = true,
					limit = 8,
					icon = " ",
					title = "Recent Files (Current Project)",
					padding = 1,
				},
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
		explorer = { enabled = true, replace_netrw = true },
		input = { enabled = true },
		lazygit = { enabled = true },
		notifier = { enabled = true, timeout = 3000 },
		picker = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		toggle = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		-- stylua: ignore start
		-- Top pickers & Explorer
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader><Tab>", function() Snacks.explorer() end, desc = "File Explorer" },
		{ "\\", function() Snacks.explorer.reveal() end, desc = "File Explorer Reveal" },
		-- notifier
		{ "<leader>nh", function() Snacks.picker.notifications() end, desc = "Notification History" },
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		-- buffers
		{ "<leader>bd", function() Snacks.bufdelete.delete() end, desc = "Delete buffer", },
		{ "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers", },
		-- LSP
		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
		{ "gR", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
		{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
		{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
		{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Project Symbols" },
		-- find
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
		-- search
		{ "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
		{ "<leader>sb", function() Snacks.picker.lines({matcher={fuzzy=false}}) end, desc = "Buffer Lines" },
		{ "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
		{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
		{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
		{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },

		-- zen
		{ "<leader>z",  function() Snacks.zen.zoom() end, desc = "Toggle Zen Mode" },
		-- toggles
		{ "<leader>uw", function() Snacks.toggle.option("wrap", { name = "Wrap" }) end, desc = "Toggle Wrap" },
		{ "<leader>ur", function() Snacks.toggle.option("relativenumber", { name = "Relative Number" }) end, desc = "Toggle Relative Number" },
		{ "<leader>us", function() Snacks.toggle.option("spell", { name = "Spelling" }) end, desc = "Toggle Spelling" },
		{ "<leader>ul", function() Snacks.toggle.option("list", { name = "List Chars" }) end, desc = "Toggle List Chars" },
		-- other 
	    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
		-- words
		{ "]r",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
		{ "[r",         function() Snacks.words.jump(-vim.v.count1) end , desc = "Prev Reference", mode = { "n", "t" } },
		-- stylua: ignore stop
	},
}
