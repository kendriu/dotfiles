return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bufdelete = { enabled = true },
		notifier = { enabled = true, timeout = 5000 },
		lazygit = { enabled = true },
		picker = { enabled = true },
		statuscolumn = { enabled = true },
		scroll = { enabled = true },
	},
	keys = {
		-- stylua: ignore start
		-- Top pickers & Explorer
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
		-- notifier
		{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		-- buffers
		{ "<leader>bd", function() Snacks.bufdelete.delete() end, desc = "Delete buffer", },
		{ "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers", },
		-- symvols
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
		-- grep
		{ "<leader>sb", function() Snacks.picker.lines({matcher={fuzzy=false}}) end, desc = "Buffer Lines" },
		{ "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
		{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
		-- zen
		{ "<leader>z",  function() Snacks.zen.zoom() end, desc = "Toggle Zen Mode" },
		-- other 
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		-- stylua: ignore stop
	},
}
-- TODO: https://www.reddit.com/r/neovim/comments/1iljttg/people_who_use_snacksnivm_how_do_you_modularize/
