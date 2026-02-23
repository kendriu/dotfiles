return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		-- As of v4, kejj
		-- Using default keymaps: ys, yss, yS, ySS, S, gS, ds, cs, cS, <C-g>s, <C-g>S
		-- See :h nvim-surround.migrating.v3_to_v4
		require("nvim-surround").setup({
			-- Configuration options go here (not keymaps)
		})
	end,
}
