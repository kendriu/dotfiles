return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			-- Size of terminal
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<C-\>]], -- Quick toggle with Ctrl+\
			hide_numbers = true, -- Hide line numbers in terminal
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true, -- Open mapping applies in insert mode
			terminal_mappings = true, -- Open mapping applies in terminal mode
			persist_size = true,
			persist_mode = true,
			direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
			close_on_exit = true,
			shell = vim.o.shell,
			auto_scroll = true,
			-- Float terminal settings
			float_opts = {
				border = "curved", -- 'single' | 'double' | 'shadow' | 'curved'
				width = math.floor(vim.o.columns * 0.9),
				height = math.floor(vim.o.lines * 0.9),
				winblend = 0,
			},
		})

		-- Toggle floating terminal (already have <C-\> from open_mapping)
		vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Terminal: Float" })

		-- Horizontal terminal
		vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal: Horizontal" })

		-- Vertical terminal
		vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal: Vertical" })

		-- Tab terminal
		vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=tab<CR>", { desc = "Terminal: Tab" })

		-- Terminal mode mappings (easier to escape terminal)
		function _G.set_terminal_keymaps()
			local topts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], topts) -- Easy escape
			vim.keymap.set("t", "jk", [[<C-\><C-n>]], topts) -- Alternative escape
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], topts) -- Navigate left
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], topts) -- Navigate down
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], topts) -- Navigate up
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], topts) -- Navigate right
			vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], topts) -- Window commands
		end

		-- Apply terminal keymaps when entering a terminal buffer
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		-- Specialized terminals (optional but useful)
		local Terminal = require("toggleterm.terminal").Terminal

		-- Lazygit integration (you already have snacks.lazygit, but this is an alternative)
		local lazygit = Terminal:new({
			cmd = "lazygit",
			direction = "float",
			hidden = true,
			float_opts = {
				border = "curved",
				width = math.floor(vim.o.columns * 0.95),
				height = math.floor(vim.o.lines * 0.95),
			},
		})

		function _LAZYGIT_TOGGLE()
			lazygit:toggle()
		end

		vim.keymap.set("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Terminal: Lazygit" })

		-- Python REPL
		local python = Terminal:new({
			cmd = "python3",
			direction = "float",
			hidden = true,
		})

		function _PYTHON_TOGGLE()
			python:toggle()
		end

		vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Terminal: Python REPL" })

		-- Node REPL
		local node = Terminal:new({
			cmd = "node",
			direction = "float",
			hidden = true,
		})

		function _NODE_TOGGLE()
			node:toggle()
		end

		vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", { desc = "Terminal: Node REPL" })
	end,
}
