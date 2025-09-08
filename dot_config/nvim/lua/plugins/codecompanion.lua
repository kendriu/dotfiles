return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim", -- use Snacks instead of Telescope
	},
	config = function()
		local cc = require("codecompanion")
		local num_ctx = 8200

		cc.setup({
			strategies = {
				chat = { adapter = "qwen" },
				inline = { adapter = "qwen" },
			},
			adapters = {
				http = {
					qwen = function()
						return require("codecompanion.adapters.http").extend("ollama", {
							name = "CodeQwen",
							endpoint = "http://localhost:11434",
							schema = {
								model = {
									default = "qwen2.5:14b-instruct",
								},
								num_ctx = {
									default = num_ctx,
								},
							},
						})
					end,
					codellama = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "CodeLlama",
							endpoint = "http://localhost:11434",
							schema = {
								model = {
									default = "codellama:13b-instruct",
								},
								num_ctx = {
									default = num_ctx,
								},
							},
						})
					end,
					deepseek = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "DeepSeek-coder",
							endpoint = "http://localhost:11434",
							schema = {
								model = {
									default = "deepseek-coder-v2:16b",
								},
								num_ctx = {
									default = num_ctx,
								},
							},
						})
					end,

					gpt_oss = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "gpt_oss_generic",
							endpoint = "http://localhost:11434",
							schema = {
								model = {
									default = "gpt-oss:20b",
								},
								num_ctx = {
									default = num_ctx,
								},
							},
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
			extensions = {
				vectorcode = {
					opts = {
						tool_group = {
							-- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
							enabled = true,
							-- a list of extra tools that you want to include in `@vectorcode_toolbox`.
							-- if you use @vectorcode_vectorise, it'll be very handy to include
							-- `file_search` here.
							extras = { "file_search" },
							collapse = false, -- whether the individual tools should be shown in the chat
						},
						tool_opts = {
							["*"] = {},
							ls = {},
							vectorise = {},
							query = {
								max_num = { chunk = -1, document = -1 },
								default_num = { chunk = 50, document = 10 },
								include_stderr = false,
								use_lsp = true,
								no_duplicate = true,
								chunk_mode = false,
								summarise = {
									enabled = false,
									adapter = nil,
									query_augmented = true,
								},
							},
							files_ls = {},
							files_rm = {},
						},
					},
				},
			},
		})

		-- Optional: keymaps for quick switching
		vim.keymap.set("n", "<leader>ml", function()
			cc.config.strategies.chat.adapter = "codellama"
			print("🔄 Switched to Code Llama for chat")
		end, { desc = "Use Code Llama" })

		vim.keymap.set("n", "<leader>md", function()
			cc.config.strategies.chat.adapter = "deepseek"
			print("🔄 Switched to DeepSeek for chat")
		end, { desc = "Use DeepSeek" })
	end,
}
