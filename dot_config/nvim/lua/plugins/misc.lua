-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
	},
	{
		-- Hints keybinds
		"folke/which-key.nvim",
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
		config = true,
		opts = {},
	},
	{
		-- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
		config = true,
	},
}
