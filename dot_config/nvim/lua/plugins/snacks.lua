return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>bd",
			function()
				Snacks.bufdelete.delete()
			end,
			desc = "Delete buffer",
		},
	},
	---@type snacks.Config
	opts = {
		bufdelete = { enabled = true },
	},
}
