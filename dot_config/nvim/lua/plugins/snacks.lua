return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		-- stylua: ignore start
		{ "<leader>bd", function() Snacks.bufdelete.delete() end, desc = "Delete buffer", },
		{ "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers", },
		-- picker
		{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Project Symbols" },
		{ "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines"},
		-- picker find
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
		-- picker zoom
		{ "<leader>z",  function() Snacks.zen.zoom() end, desc = "Toggle Zen Mode" },
		-- stylua: ignore stop
	},
	---@type snacks.Config
	opts = {
		bufdelete = { enabled = true },
		picker = { enabled = true },
	},
	vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "SpecialComment" }),
}
