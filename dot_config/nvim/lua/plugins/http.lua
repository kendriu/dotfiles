return {
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>Xs", desc = "Send request" },
			{ "<leader>Xa", desc = "Send all requests" },
			{ "<leader>Xb", desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = false,
			global_keymaps_prefix = "<leader>X",
			kulala_keymaps_prefix = "",
		},
	},
}
