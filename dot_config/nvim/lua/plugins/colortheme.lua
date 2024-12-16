return {
    "xiantang/darcula-dark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
			-- setup must be called before loading
			require("darcula").setup({
			})
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
}
