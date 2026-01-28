return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "VeryLazy",
	opts = {
		max_lines = 3, -- How many lines the context should show
		min_window_height = 20, -- Minimum window height to show context
		line_numbers = true,
		multiline_threshold = 1,
		trim_scope = "outer",
		mode = "cursor", -- Line used to calculate context (cursor or topline)
	},
}
