-- https://github.com/m4xshen/hardtime.nvim
return {
	"m4xshen/hardtime.nvim",
	event = { "VeryLazy", "BufEnter" },
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		disabled_keys = {},
		["<Up>"] = {},
		["<Down>"] = {},
		["<Left>"] = {},
		["<Right>"] = {},
	},
}
