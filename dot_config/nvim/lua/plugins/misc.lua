-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
		event = "VeryLazy",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
		event = "VeryLazy",
	},
	{
		-- Hints keybinds
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- win = {
			--   border = {
			--     { '?', 'FloatBorder' },
			--     { '?', 'FloatBorder' },
			--     { '?', 'FloatBorder' },
			--     { '?', 'FloatBorder' },
			--     { '?', 'FloatBorder' },
			--     { '?', 'FloatBorder' },
			--     { '?', 'FloatBorder' },
			--     { '?', 'FloatBorder' },
			--   },
			-- },
		},
	},
	{
		-- Autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufNewFile" },
	},
	-- {
	-- 	"jmbuhr/otter.nvim",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	opts = {},
	-- },
	{
		"sQVe/sort.nvim",
		cmd = "Sort",
	},
}
