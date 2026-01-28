return {
	"folke/trouble.nvim",
	opts = {
		auto_close = false, -- Don't auto-close when jumping
		auto_preview = true, -- Show preview automatically
		auto_refresh = true, -- Auto-refresh list
		focus = true, -- Focus trouble window when opened
		restore = true, -- Restore last trouble window
		follow = true, -- Follow cursor in source
		modes = {
			diagnostics = {
				auto_open = false, -- Don't auto-open on diagnostics
			},
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>DD",
			"<cmd>Trouble diagnostics toggle focus=true win.position=right win.size=0.4<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>Dd",
			"<cmd>Trouble diagnostics toggle focus=true filter.buf=0 win.position=right win.size=0.4<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=true win.position=right win.size=0.4<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>Dl",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>Dq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},

		{
			"<leader>Dt",
			"<cmd>Trouble todo toggle focus=true filter={tag = {TODO,FIX,FIXME}} win.position=right win.size=0.4<cr>",
			desc = "TODO (Trouble)",
		},
	},
}
