return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"SmiteshP/nvim-navbuddy",
			dependencies = {
				"SmiteshP/nvim-navic",
				"MunifTanjim/nui.nvim",
			},
			lazy = false,
			opts = { lsp = { auto_attach = true } },
			config = function() end,
		},
	},
}
