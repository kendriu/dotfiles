return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects", -- Enhanced text objects
	},
	main = "nvim-treesitter.configs", -- Sets main module to use for opts
	-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
	opts = {
		ensure_installed = {
			"bash",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"python",
			"rust",
			"dockerfile",
			"gitignore",
			"yaml",
			"json",
			"json5",
			"just",
			"regex",
			"sql",
			"make",
			"cmake",
			"javascript",
			"typescript",
			"tsx",
			"vue",
			"css",
			"scss",
			"toml",
			"go",
		},
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },

		-- Incremental selection based on treesitter
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = "<C-s>",
				node_decremental = "<C-backspace>",
			},
		},

		-- Treesitter text objects configuration
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim

				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["al"] = "@loop.outer",
					["il"] = "@loop.inner",
					["ao"] = "@conditional.outer",
					["io"] = "@conditional.inner",
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					["a/"] = "@comment.outer",
					["i/"] = "@comment.outer",
				},
				-- You can choose the select mode (default is charwise 'v')
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "V", -- linewise
				},
			},

			swap = {
				enable = true,
				swap_next = {
					["<leader>xn"] = "@parameter.inner", -- swap parameters/argument with next
					["<leader>xm"] = "@function.outer", -- swap function with next
				},
				swap_previous = {
					["<leader>xp"] = "@parameter.inner", -- swap parameters/argument with prev
					["<leader>xM"] = "@function.outer", -- swap function with previous
				},
			},

			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
					["]a"] = "@parameter.inner",
					["]l"] = "@loop.outer",
					["]o"] = "@conditional.outer",
					["]b"] = "@block.outer",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]C"] = "@class.outer",
					["]A"] = "@parameter.inner",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[a"] = "@parameter.inner",
					["[l"] = "@loop.outer",
					["[o"] = "@conditional.outer",
					["[b"] = "@block.outer",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[C"] = "@class.outer",
					["[A"] = "@parameter.inner",
				},
			},

			lsp_interop = {
				enable = true,
				border = "rounded",
				floating_preview_opts = {},
				peek_definition_code = {
					["<leader>pf"] = "@function.outer",
					["<leader>pc"] = "@class.outer",
				},
			},
		},
	},
}
