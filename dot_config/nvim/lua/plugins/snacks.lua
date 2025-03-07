return {
	-- https://github.com/folke/snacks.nvim
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
	},
	keys = {
		-- stylua: ignore start
		-- notifier
		{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		-- buffers
		{ "<leader>bd", function() Snacks.bufdelete.delete() end, desc = "Delete buffer", },
		{ "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers", },
		-- picker
		{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Project Symbols" },
		{ "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines"},
		-- find
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
		-- zen
		{ "<leader>z",  function() Snacks.zen.zoom() end, desc = "Toggle Zen Mode" },
		-- other 
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		-- stylua: ignore stop
	},
}
-- TODO: https://www.reddit.com/r/neovim/comments/1iljttg/people_who_use_snacksnivm_how_do_you_modularize/
