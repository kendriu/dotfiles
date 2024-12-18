return {
	"loctvl842/monokai-pro.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		require("monokai-pro").setup()
		vim.cmd([[colorscheme monokai-pro]])
	end,
}
