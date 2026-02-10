return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	enabled = false,

	ft = { "markdown", "codecompanion" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		checkbox = {
			enabled = true,
			bullet = false,
			right_pad = 4,
			unchecked = {
				-- Replaces '[ ]' of 'task_list_marker_unchecked'.
				icon = "󰄱  ",
				-- Highlight for the unchecked icon.
				highlight = "obisidiantodo",
				-- Highlight for item associated with unchecked checkbox.
				scope_highlight = nil,
			},
			checked = {
				-- Replaces '[x]' of 'task_list_marker_checked'.
				icon = "  ",
				-- Highlight for the checked icon.
				highlight = "RenderMarkdownChecked",
				-- Highlight for item associated with checked checkbox.
				scope_highlight = nil,
			},
			-- Define custom checkbox states, more involved, not part of the markdown grammar.
			-- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks.
			-- The key is for healthcheck and to allow users to change its values, value type below.
			-- | raw             | matched against the raw text of a 'shortcut_link'           |
			-- | rendered        | replaces the 'raw' value when rendering                     |
			-- | highlight       | highlight for the 'rendered' icon                           |
			-- | scope_highlight | optional highlight for item associated with custom checkbox |
			-- stylua: ignore
			custom = {
				tilde = { raw = '[~]', rendered = '󰰱', highlight = 'obsidiantilde', scope_highlight = nil },
				important = { raw = '[!]', rendered = '', highlight = 'obsidianimportant', scope_highlight = nil },
				obsidianrightarrow = { raw = '[>]', rendered = '', highlight = 'obsidianrightarrow', scope_highlight = nil },
			},
		},
		bullet = {
			enabled = true,
			right_pad = 3,
		},
		-- indent = {
		-- 	enabled = false,
		-- },
	},
}
