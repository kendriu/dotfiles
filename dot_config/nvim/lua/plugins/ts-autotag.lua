return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	opts = {
		opts = {
			-- Enable closing tags for HTML, TSX, JSX, Vue, etc.
			enable_close = true,
			-- Enable renaming tags
			enable_rename = true,
			-- Enable auto-close on slash (</div>)
			enable_close_on_slash = true,
		},
		-- Override default filetypes
		per_filetype = {
			["html"] = { enable_close = true },
			["javascript"] = { enable_close = false },
			["typescript"] = { enable_close = false },
			["javascriptreact"] = { enable_close = true },
			["typescriptreact"] = { enable_close = true },
			["vue"] = { enable_close = true },
		},
	},
}
