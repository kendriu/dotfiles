return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			opts = { enable_autocmd = false },
		},
	},
	opts = {
		-- Add a space b/w comment and the line
		padding = true,
		-- Whether the cursor should stay at its position
		sticky = true,
		-- Lines to be ignored while (un)comment
		ignore = nil,
		-- LHS of toggle mappings in NORMAL mode
		toggler = {
			line = "gcc", -- Line-comment toggle keymap
			block = "gbc", -- Block-comment toggle keymap
		},
		-- LHS of operator-pending mappings in NORMAL and VISUAL mode
		opleader = {
			line = "gc", -- Line-comment keymap
			block = "gb", -- Block-comment keymap
		},
		-- LHS of extra mappings
		extra = {
			above = "gcO", -- Add comment on the line above
			below = "gco", -- Add comment on the line below
			eol = "gcA", -- Add comment at the end of line
		},
		-- Enable keybindings
		mappings = {
			basic = true, -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
			extra = true, -- Extra mapping; `gco`, `gcO`, `gcA`
		},
		-- Function to call before (un)comment
		pre_hook = function(ctx)
			-- Try ts_context_commentstring first (handles embedded languages like JSX/TSX)
			local ok, result = pcall(function()
				return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
			end)
			if ok and result and result ~= "" then
				return result
			end
			-- Fallback: use Comment.nvim's built-in filetype table directly (bypasses treesitter)
			local F = require("Comment.ft")
			local ft_cs = F.get(vim.bo.filetype, ctx.ctype)
			if ft_cs then
				return ft_cs
			end
			-- Last resort: native commentstring
			if vim.bo.commentstring ~= "" then
				return vim.bo.commentstring
			end
		end,
		-- Function to call after (un)comment
		post_hook = nil,
	},
}
