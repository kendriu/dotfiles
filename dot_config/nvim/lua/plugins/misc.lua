-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
		event = "VeryLazy",
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
		opts = {
			fast_wrap = {},
		},
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
	},
	-- {
	-- 	"jmbuhr/otter.nvim",
	--
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	opts = {},
	-- },
	{
		"sQVe/sort.nvim",
		cmd = "Sort",
	},
	{
		-- https://github.com/Pocco81/auto-save.nvim
		"okuuva/auto-save.nvim",
		event = "BufEnter",
		keys = { { "<leader>a", "<cmd>ASToggle<CR>", desc = "Toogle auto-save" } },
		config = function()
			require("auto-save").setup({
				execution_message = {
					message = function()
						return ""
					end,
				},
			})
		end,
	},
}
