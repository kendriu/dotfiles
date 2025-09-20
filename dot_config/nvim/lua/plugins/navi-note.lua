return {
	"you-n-g/navigate-note.nvim",
	event = "VeryLazy",
	opts = {
		filename = "nav.md", -- The filename of the markdown.
		width = 0.6, -- The width of the popup window when jumping in the file with <tab>.
		keymaps = {
			nav_mode = {
				-- Navigation & Jumping
				next = "<tab>",
				prev = "<s-tab>",
				open = "<m-o>",
				switch_back = "<m-h>", -- Switch back to the previous file from `nav.md`.
				-- Editing
				append_link = "<m-p>", -- (P)aste will more align with the meaning.
				-- Mode switching
				jump_mode = "<m-l>", -- When we jump to a file, jump to the file only or jump to the exact file:line.
			},
			add = "<localleader>na",
			open_nav = "<m-h>", -- Switch to `nav.md`.
		},
		link_surround = { -- sometime you may want to change the link format in case of conflict with other formatting conversion.
			left = "[[", -- The left delimiter for links.
			right = "]]", -- The right delimiter for links.
		},
		context_line_count = { -- It would be a total of `2 * context_line_count - 1` lines.
			tab = 8,
			vline = 2,
		},
		enable_block = false, -- enable block navigation; block navigation indicates only the block under the cursor will display the peeking window; mark the block with --- or ***
	},
}
