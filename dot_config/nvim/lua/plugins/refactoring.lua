-- Advanced refactoring operations (extract, inline, etc.)
return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	event = "VeryLazy",
	keys = {
		-- Extract function/variable
		{
			"<leader>re",
			function()
				require("refactoring").refactor("Extract Function")
			end,
			mode = "x",
			desc = "Extract Function",
		},
		{
			"<leader>rf",
			function()
				require("refactoring").refactor("Extract Function To File")
			end,
			mode = "x",
			desc = "Extract Function to File",
		},
		{
			"<leader>rv",
			function()
				require("refactoring").refactor("Extract Variable")
			end,
			mode = "x",
			desc = "Extract Variable",
		},
		-- Inline
		{
			"<leader>ri",
			function()
				require("refactoring").refactor("Inline Variable")
			end,
			mode = { "n", "x" },
			desc = "Inline Variable",
		},
		-- Extract block
		{
			"<leader>rb",
			function()
				require("refactoring").refactor("Extract Block")
			end,
			mode = { "n", "x" },
			desc = "Extract Block",
		},
		{
			"<leader>rbf",
			function()
				require("refactoring").refactor("Extract Block To File")
			end,
			mode = { "n", "x" },
			desc = "Extract Block to File",
		},
		-- Debug helpers
		{
			"<leader>rp",
			function()
				require("refactoring").debug.printf({ below = false })
			end,
			mode = "n",
			desc = "Debug Print",
		},
		{
			"<leader>rc",
			function()
				require("refactoring").debug.cleanup({})
			end,
			mode = "n",
			desc = "Cleanup Debug Prints",
		},
		-- Refactoring selection menu
		{
			"<leader>rs",
			function()
				require("refactoring").select_refactor()
			end,
			mode = { "n", "x" },
			desc = "Refactor Menu",
		},
	},
	config = function()
		require("refactoring").setup({
			-- Prompt for return type on Extract Function
			prompt_func_return_type = {
				go = true,
				java = true,
				cpp = true,
				c = true,
				h = true,
				hpp = true,
				cxx = true,
			},
			-- Prompt for function parameters on Extract Function
			prompt_func_param_type = {
				go = true,
				java = true,
				cpp = true,
				c = true,
				h = true,
				hpp = true,
				cxx = true,
			},
			-- Printf statement formats for debug helpers
			printf_statements = {},
			-- Print var statement formats for debug helpers
			print_var_statements = {},
		})
	end,
}
