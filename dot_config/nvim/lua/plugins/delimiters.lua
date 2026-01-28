return {
	"HiPhish/rainbow-delimiters.nvim",
	event = "VeryLazy",
	config = function()
		-- This module contains a number of default definitions
		local rainbow_delimiters = require("rainbow-delimiters")

		---@type rainbow_delimiters.config
		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = rainbow_delimiters.strategy["global"],
				vim = rainbow_delimiters.strategy["local"],
				python = rainbow_delimiters.strategy["local"],
				javascript = rainbow_delimiters.strategy["local"],
				typescript = rainbow_delimiters.strategy["local"],
				javascriptreact = rainbow_delimiters.strategy["local"],
				typescriptreact = rainbow_delimiters.strategy["local"],
				tsx = rainbow_delimiters.strategy["local"],
				rust = rainbow_delimiters.strategy["local"],
				go = rainbow_delimiters.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",
			},
			priority = {
				[""] = 110,
				lua = 210,
			},
			highlight = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		}
	end,
}
