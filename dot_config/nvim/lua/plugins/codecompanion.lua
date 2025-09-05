return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim", -- use Snacks instead of Telescope
	},
	config = function()
		local cc = require("codecompanion")

		cc.setup({
			strategies = {
				chat = { adapter = "codellama" }, -- default = Code Llama
				inline = { adapter = "deepseek" }, -- default = DeepSeek for completions
			},
			adapters = {
				http = {

					codellama = function()
						return require("codecompanion.adapter").extend("ollama", {
							name = "CodeLlama",
							endpoint = "http://localhost:11434",
							model = "codellama:7b-instruct",
						})
					end,
					deepseek = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "DeepSeek",
							endpoint = "http://localhost:11434",
							model = "deepseek-coder:6.7b",
						})
					end,
				},
			},

			-- 👇 Replace telescope with snacks as the picker
			display = {
				chat = {
					provider = "snacks",
				},
				inline = {
					provider = "snacks",
				},
			},
		})
		-- -- Optional: keymaps for quick switching
		-- vim.keymap.set("n", "<leader>ml", function()
		-- 	cc.config.strategies.chat.adapter = "codellama"
		-- 	print("🔄 Switched to Code Llama for chat")
		-- end, { desc = "Use Code Llama" })
		--
		-- vim.keymap.set("n", "<leader>md", function()
		-- 	cc.config.strategies.chat.adapter = "deepseek"
		-- 	print("🔄 Switched to DeepSeek for chat")
		-- end, { desc = "Use DeepSeek" })
	end,
}
