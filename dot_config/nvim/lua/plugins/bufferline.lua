return {
	"akinsho/bufferline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				themable = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		})
	end,
}
