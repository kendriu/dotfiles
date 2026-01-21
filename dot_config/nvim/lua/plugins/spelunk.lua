return {
	{
		"EvWilson/spelunk.nvim",
		dependencies = {
			"folke/snacks.nvim", -- Optional: for enhanced fuzzy search capabilities
			"nvim-treesitter/nvim-treesitter", -- Optional: for showing grammar context
			"nvim-lualine/lualine.nvim", -- Optional: for statusline display integration
		},
		config = function()
			require("spelunk").setup({
				enable_persist = true,
				fuzzy_search_provider = "snacks",
			})
		end,
	},
}
