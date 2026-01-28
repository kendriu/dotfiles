return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim", -- use Snacks instead of Telescope
	},
	event = "VeryLazy",
	keys = {
		{ "<leader>Ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "AI: Toggle Chat" },
		{ "<leader>An", "<cmd>CodeCompanionChat<CR>", desc = "AI: New Chat" },
		{ "<leader>Aa", "<cmd>CodeCompanionActions<CR>", desc = "AI: Action Palette" },
		{ "<leader>Ai", "<cmd>CodeCompanion ", desc = "AI: Inline (type prompt)" }, -- user appends prompt
		{ "<leader>Am", "<cmd>CodeCompanionActions<CR>", desc = "AI: Model / Strategy" },
		{
			"<leader>Ar",
			mode = "v",
			"<cmd>'<,'>CodeCompanion /<CR>",
			desc = "AI: Run on selection (use / prompts)",
		},
		{ "gA", mode = "v", "<cmd>CodeCompanionChat Add<CR>", desc = "AI: Add selection to Chat" },
	},

	config = function()
		require("codecompanion").setup({
			strategies = {
				-- Chat strategy (chat buffer)
				chat = {
					adapter = "copilot",
				},
				-- Inline completions (inline assistant)
				inline = {
					adapter = "copilot",
				},
				-- Agents
				agent = {
					adapter = "copilot",
				},
			},

			-- Display configuration (using Snacks picker)
			display = {
				chat = {
					provider = "snacks",
				},
				inline = {
					provider = "snacks",
				},
			},

			-- Logging configuration
			opts = {
				log_level = "INFO", -- Options: "TRACE", "DEBUG", "INFO", "WARN", "ERROR"
			},
		})

		-- Convenience: ":cc" expands to :CodeCompanion
		vim.cmd([[cabbrev cc CodeCompanion]])
	end,
}
