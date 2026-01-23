return {
	{
		"birenbaum/copilot.lua",
		dependencies = {
			"copilotlsp-nvim/copilot-lsp",
		},
		cmd = "Copilot",
		event = "InsertEnter",
		build = ":Copilot auth", -- run once to authenticate
		config = function()
			require("copilot").setup({
				nes = {
					enabled = true,
					keymap = {
						accept_and_goto = "<leader>q",
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
}
