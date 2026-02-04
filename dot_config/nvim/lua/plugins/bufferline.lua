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
				separator_style = "thin", -- "slant" | "slope" | "thick" | "thin"
				indicator = {
					style = "underline", -- "icon" | "underline" | "none"
				},
				-- Enable buffer picking mode
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				left_trunc_marker = "",
				right_trunc_marker = "",
				-- Show diagnostics in bufferline
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
				-- Offsets for file explorer
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
					},
				},
				-- Custom filter to hide certain buffers
				custom_filter = function(buf_number)
					-- Filter out filetypes
					local filetype = vim.bo[buf_number].filetype
					if filetype == "qf" or filetype == "help" then
						return false
					end
					return true
				end,
			},
		})

		-- Buffer management keybindings
		local opts = { noremap = true, silent = true }

		-- Navigate buffers (Tab/S-Tab already set in keymaps.lua)
		vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin Buffer" })
		vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Close Unpinned Buffers" })

		-- Close buffers
		vim.keymap.set("n", "<leader>bc", function()
			-- Close all buffers except current and pinned
			local current = vim.api.nvim_get_current_buf()
			local buffers = vim.api.nvim_list_bufs()
			for _, buf in ipairs(buffers) do
				if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
					-- Check if buffer is not pinned (bufferline doesn't expose pin state easily)
					-- So we just close others
					vim.api.nvim_buf_delete(buf, { force = false })
				end
			end
		end, { desc = "Close Other Buffers" })

		vim.keymap.set("n", "<leader>bC", function()
			-- Close all buffers to the right
			local current = vim.api.nvim_get_current_buf()
			local found_current = false
			local buffers = vim.api.nvim_list_bufs()
			for _, buf in ipairs(buffers) do
				if buf == current then
					found_current = true
				elseif found_current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
					vim.api.nvim_buf_delete(buf, { force = false })
				end
			end
		end, { desc = "Close Buffers to Right" })

		-- Navigate to specific buffer positions
		vim.keymap.set("n", "<leader>b1", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to Buffer 1" })
		vim.keymap.set("n", "<leader>b2", "<cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to Buffer 2" })
		vim.keymap.set("n", "<leader>b3", "<cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to Buffer 3" })
		vim.keymap.set("n", "<leader>b4", "<cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to Buffer 4" })
		vim.keymap.set("n", "<leader>b5", "<cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to Buffer 5" })

		-- Navigate to first/last buffer
		vim.keymap.set("n", "<leader>bf", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "First Buffer" })
		vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineGoToBuffer -1<CR>", { desc = "Last Buffer" })

		-- Move current buffer
		vim.keymap.set("n", "<leader>bm>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move Buffer Right" })
		vim.keymap.set("n", "<leader>bm<", "<cmd>BufferLineMovePrev<CR>", { desc = "Move Buffer Left" })

		-- Pick buffer (interactive)
		vim.keymap.set("n", "<leader>bj", "<cmd>BufferLinePick<CR>", { desc = "Pick Buffer (Jump)" })

		-- Sort buffers
		vim.keymap.set("n", "<leader>bs", "<cmd>BufferLineSortByDirectory<CR>", { desc = "Sort by Directory" })
		vim.keymap.set("n", "<leader>bS", "<cmd>BufferLineSortByExtension<CR>", { desc = "Sort by Extension" })
	end,
}
