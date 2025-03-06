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
		{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
		-- stylua: ignore stop
	},
	---@type snacks.Config
	opts = {
		bufdelete = { enabled = true },
		picker = { enabled = true },
	},
}
