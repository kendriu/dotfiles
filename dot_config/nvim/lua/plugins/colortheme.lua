return {
	{
		"loctvl842/monokai-pro.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("monokai-pro").setup()
			-- vim.cmd([[colorscheme monokai-pro]])
			vim.api.nvim_set_hl(0, "NonText", { link = "SpecialComment" })
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup()
			vim.cmd([[colorscheme tokyonight]])
			-- vim.api.nvim_set_hl(0, "NonText", { link = "SpecialComment" })
		end,
	},
}
