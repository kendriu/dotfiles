return {
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>Fs", desc = "Send request" },
			{ "<leader>Fa", desc = "Send all requests" },
			{ "<leader>Fb", desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = false,
			global_keymaps_prefix = "<leader>F",
			kulala_keymaps_prefix = "",
		},
	},
}
