-- Open URLs under cursor with gx
return {
	"sontungexpt/url-open",
	event = "VeryLazy",
	keys = {
		{ "gx", "<esc><cmd>URLOpenUnderCursor<cr>", desc = "Open URL under cursor" },
	},
	config = function()
		require("url-open").setup({
			highlight_url = {
				cursor_move = {
					enabled = true,
					fg = "text",
					bg = nil,
					underline = true,
				},
			},
		})
	end,
}
