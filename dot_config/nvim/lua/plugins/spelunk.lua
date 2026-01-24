return {
	{
		"EvWilson/spelunk.nvim",
		dependencies = {
			"folke/snacks.nvim", -- Optional: for enhanced fuzzy search capabilities
			"nvim-treesitter/nvim-treesitter", -- Optional: for showing grammar context
			"nvim-lualine/lualine.nvim", -- Optional: for statusline display integration
		},
		config = function()
			local spelunk = require("spelunk")

			spelunk.setup({
				enable_persist = true,
				fuzzy_search_provider = "snacks",
			})
			spelunk.display_function = function(bookmark)
				local ctx = require("spelunk.util").get_treesitter_context(bookmark)
				ctx = (ctx == "" and ctx) or (" - " .. ctx)
				local filename = spelunk.filename_formatter(bookmark.file)
				return string.format("%s:%d%s", filename, bookmark.line, ctx)
			end
		end,
	},
}
