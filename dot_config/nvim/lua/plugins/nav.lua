return {
	"neovim/nvim-lspconfig",
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		vim.keymap.set("n", "<leader>n", ":Navbuddy<CR>"),
		config = function() end,
	},
}
