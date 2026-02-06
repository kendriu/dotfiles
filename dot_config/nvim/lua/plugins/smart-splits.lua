return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		build = "./kitty/install-kittens.bash",
		keys = {
		-- stylua: ignore start
	    -- resizing splits
	    { "<Left>", function() require('smart-splits').resize_left() end, desc = "Resize split left" },
	    { "<Down>", function() require('smart-splits').resize_down() end, desc = "Resize split down" },
	    { "<Up>", function() require('smart-splits').resize_up() end, desc = "Resize split up" },
	    { "<Right>", function() require('smart-splits').resize_right() end, desc = "Resize split right" },
	    -- moving between splits
	    { "<C-h>", function() require('smart-splits').move_cursor_left() end, desc = "Move to left split" },
	    { "<C-j>", function() require('smart-splits').move_cursor_down() end, desc = "Move to below split" },
	    { "<C-k>", function() require('smart-splits').move_cursor_up() end, desc = "Move to above split" },
	    { "<C-l>", function() require('smart-splits').move_cursor_right() end, desc = "Move to right split" },
	    { "<C-\\>", function() require('smart-splits').move_cursor_previous() end, desc = "Move to previous split" },
	    -- swapping buffers between windows
	    { "<leader>wh", function() require('smart-splits').swap_buf_left() end, desc = "Swap buffer left" },
	    { "<leader>wj", function() require('smart-splits').swap_buf_down() end, desc = "Swap buffer down" },
	    { "<leader>wk", function() require('smart-splits').swap_buf_up() end, desc = "Swap buffer up" },
	    { "<leader>wl", function() require('smart-splits').swap_buf_right() end, desc = "Swap buffer right" },
			-- stylua: ignore end
		},
		config = function()
			require("smart-splits").setup({})
		end,
	},
}
