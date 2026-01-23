return {
	{
		"birenbaum/copilot.lua",
		requires = {
			"copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
		},
		cmd = "Copilot",
		event = "InsertEnter",
		build = ":Copilot auth", -- run once to authenticate
		config = function()
			require("copilot").setup({
				nes = {
					enabled = true,
					keymap = {
						accept_and_goto = "<leader>p",
						accept = false,
						dismiss = "<Esc>",
					},
				},
				suggestion = {
					enabled = false, -- disabled because copilot-cmp will be the source
					auto_trigger = false,
					hide_during_completion = true,
				},
				panel = { enabled = false }, -- disable panel when using copilot-cmp
				copilot_node_command = "node", -- override if needed (path to node)
			})
		end,
	},

	-- make copilot a completion source
	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	-- blink compat layer (lets blink.cmp use nvim-cmp sources)
	{
		"saghen/blink.compat",
		lazy = true,
		opts = {},
	},
}
