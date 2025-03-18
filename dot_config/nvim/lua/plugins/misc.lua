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
		opts = {},
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
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"sQVe/sort.nvim",
		cmd = "Sort",
	},
	{
		"sontungexpt/url-open",
		event = "VeryLazy",
		keys = { { "gx", "<esc><cmd>URLOpenUnderCursor<cr>", desc = "Open under cursor" } },
		config = function()
			local status_ok, url_open = pcall(require, "url-open")
			if not status_ok then
				return
			end
			url_open.setup({
				highlight_url = {
					cursor_move = {
						enabled = true,
						fg = "text", -- "text" or "#rrggbb"
						-- fg = "text", -- text will set underline same color with text
						bg = nil, -- nil or "#rrggbb"
						underline = true,
					},
				},
			})
		end,
	},
	{
		"okuuva/auto-save.nvim",
		event = "VeryLazy",
		keys = { { "<leader>a", "<cmd>ASToggle<CR>", desc = "Toogle auto-save" } },
		config = function()
			require("auto-save").setup({})
		end,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"wintermute-cell/gitignore.nvim",
		cmd = "Gitignore",
		config = function()
			require("gitignore")
		end,
	},
	{ "Async10/nvim-keepcase", cmd = { "Replace", "R" } },
}
