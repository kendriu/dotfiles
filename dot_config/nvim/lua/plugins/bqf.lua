return {
	"kevinhwang91/nvim-bqf",
	ft = "qf", -- Only load for quickfix filetype
	dependencies = {
		{
			"junegunn/fzf",
			lazy = false,
			build = function()
				vim.fn["fzf#install"]()
			end,
		},
	},
	opts = {
		auto_enable = true,
		auto_resize_height = true, -- Highly recommended enable
		preview = {
			win_height = 12,
			win_vheight = 12,
			delay_syntax = 80,
			border = "rounded",
			show_title = true,
			should_preview_cb = function(bufnr, qwinid)
				local ret = true
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				local fsize = vim.fn.getfsize(bufname)
				if fsize > 100 * 1024 then
					-- Skip preview for files > 100kb
					ret = false
				elseif bufname:match("^fugitive://") then
					-- Skip fugitive buffer
					ret = false
				end
				return ret
			end,
		},
		-- Make `drop` and `tab drop` to become preferred
		func_map = {
			drop = "o",
			openc = "O",
			split = "<C-s>",
			vsplit = "<C-v>",
			tab = "t",
			tabb = "T",
			tabc = "<C-t>",
			tabdrop = "",
			ptogglemode = "z,",
			ptoggleitem = "p",
			ptoggleauto = "P",
			pscrollup = "<C-u>",
			pscrolldown = "<C-d>",
			pscrollorig = "zo",
			prevfile = "<C-p>",
			nextfile = "<C-n>",
			prevhist = "<",
			nexthist = ">",
			lastleave = [['"]],
			stoggleup = "<S-Tab>",
			stoggledown = "<Tab>",
			stogglevm = "<Tab>",
			stogglebuf = [['<Tab>]],
			sclear = "z<Tab>",
			filter = "zn",
			filterr = "zN",
			fzffilter = "zf",
		},
		filter = {
			fzf = {
				action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
				extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
			},
		},
	},
	config = function(_, opts)
		require("bqf").setup(opts)

		-- Keybindings for quickfix navigation (using <leader>l for "list")
		vim.keymap.set("n", "<leader>lo", ":copen<CR>", { desc = "Open Quickfix", silent = true })
		vim.keymap.set("n", "<leader>lc", ":cclose<CR>", { desc = "Close Quickfix", silent = true })
		vim.keymap.set("n", "<leader>ll", function()
			local qf_exists = false
			for _, win in pairs(vim.fn.getwininfo()) do
				if win["quickfix"] == 1 then
					qf_exists = true
				end
			end
			if qf_exists == true then
				vim.cmd("cclose")
			else
				vim.cmd("copen")
			end
		end, { desc = "Toggle Quickfix", silent = true })

		-- Location list (similar to quickfix but local to window)
		vim.keymap.set("n", "<leader>lL", ":lopen<CR>", { desc = "Open Location List", silent = true })

		-- Integration with diagnostic
		vim.keymap.set("n", "<leader>ld", vim.diagnostic.setqflist, { desc = "Diagnostics to Quickfix" })
	end,
}
