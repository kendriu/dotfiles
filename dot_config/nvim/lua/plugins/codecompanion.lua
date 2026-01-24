return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim", -- use Snacks instead of Telescope
	},
	event = "VeryLazy",
	keys = {
		{ "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", desc = "CodeCompanion: Toggle Chat" },
		{ "<leader>cn", "<cmd>CodeCompanionChat<CR>", desc = "CodeCompanion: New Chat" },
		{ "<leader>ca", "<cmd>CodeCompanionActions<CR>", desc = "CodeCompanion: Action Palette" },
		{ "<leader>ci", "<cmd>CodeCompanion ", desc = "CodeCompanion: Inline (type prompt)" }, -- user appends prompt
		{ "<leader>cm", "<cmd>CodeCompanionActions<CR>", desc = "CodeCompanion: Model / Strategy" },
		{
			"<leader>cr",
			mode = "v",
			"<cmd>'<,'>CodeCompanion /<CR>",
			desc = "CodeCompanion: Run on selection (use / prompts)",
		},
		{ "gA", mode = "v", "<cmd>CodeCompanionChat Add<CR>", desc = "CodeCompanion: Add selection to Chat" },
	},

	config = function()
		local cc = require("codecompanion")
		local num_ctx = 8200

		cc.setup({
			strategies = {
				-- chat strategy (chat buffer)
				chat = {
					adapter = "copilot", -- was "ollama"
					-- optional adapter-specific options:
					adapter_opts = {
						-- streaming is supported; set to true if you want incremental responses
						stream = true,
						-- If you want to select a specific Copilot model, set `model` here
						-- model = "gpt-4o"    -- example; change as needed
						-- other adapter-specific params may be accepted
					},
				},

				-- inline completions (inline assistant)
				inline = {
					adapter = "copilot",
					adapter_opts = {
						stream = true,
					},
				},

				-- agents (if you were using Ollama for agents)
				agent = {
					adapter = "copilot",
					adapter_opts = {
						stream = true,
					},
				},
				-- chat = { adapter = "qwen" },
				-- inline = { adapter = "qwen" },
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
		})

		-- convenience: add a small command-line abbreviation so ":cc" expands to :CodeCompanion
		vim.cmd([[cabbrev cc CodeCompanion]])
	end,
}
