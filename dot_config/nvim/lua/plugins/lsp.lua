return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	priority = 900,
	event = { "BufReadPre", "BufNewFile", "VeryLazy" },
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{
			"williamboman/mason.nvim",
			config = true,
		}, -- NOTE: Must be loaded before dependants
		{
			"williamboman/mason-lspconfig.nvim",
		},

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		"saghen/blink.cmp",
		"neovim/nvim-lspconfig",
		"SmiteshP/nvim-navic",
	},
	config = function()
		-- Brief aside: **What is LSP?**
		--
		-- LSP is an initialism you've probably heard, but might not understand what it is.
		--
		-- LSP stands for Language Server Protocol. It's a protocol that helps editors
		-- and language tooling communicate in a standardized fashion.
		--
		-- In general, you have a "server" which is some tool built to understand a particular
		-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
		-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
		-- processes that communicate with some "client" - in this case, Neovim!
		--
		-- LSP provides Neovim with features like:
		--  - Go to definition
		--  - Find references
		--  - Autocompletion
		--  - Symbol Search
		--  - and more!
		--
		-- Thus, Language Servers are external tools that must be installed separately from
		-- Neovim. This is where `mason` and related plugins come into play.
		--
		-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
		-- and elegantly composed help section, `:help lsp-vs-treesitter`

		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Change diagnostic symbols in the sign column (gutter)
		local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
		local diagnostic_signs = {}
		for type, icon in pairs(signs) do
			diagnostic_signs[vim.diagnostic.severity[type]] = icon
		end
		vim.diagnostic.config({ signs = { text = diagnostic_signs } })

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		require("mason-lspconfig").setup({
			ensure_installed = {
				"bashls",
				"basedpyright",
				"ruff",
				"rust_analyzer",
				"lua_ls",
				"taplo",
				"prettier",
				"shellcheck",
				"shfmt",
				"stylua", -- Used to format Lua code
			},
			automatic_enable = true,
		})

		vim.lsp.config("basedpyright", {
			settings = {
				basedpyright = {
					analysis = {
						-- ignore = { "*" },
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						typeCheckingMode = "basic", -- Change to "strict" if needed
						diagnosticMode = "openFilesOnly",
						diagnosticSeverityOverrides = {
							reportArgumentType = "warning",
							reportAssignmentType = "warning",
							reportAttributeAccessIssue = false,
							reportCallIssue = "warning",
							reportGeneralTypeIssues = "warning",
							reportOptionalMemberAccess = false,
							reportOptionalSubscript = false,
							reportPrivateImportUsage = false,
							reportUndefinedVariable = false,
							reportUnusedImport = false,
							reportUnusedParameter = "warning",
							reportUnusedVariable = "warning",
						},
					},
				},
			},
		})

		vim.lsp.config("ruff", {
			-- Notes on code actions: https://github.com/astral-sh/ruff-lsp/issues/119#issuecomment-1595628355
			-- Get isort like behavior: https://github.com/astral-sh/ruff/issues/8926#issuecomment-1834048218
			commands = {
				RuffAutofix = {
					function()
						vim.lsp.buf.execute_command({
							command = "ruff.applyAutofix",
							arguments = {
								{ uri = vim.uri_from_bufnr(0) },
							},
						})
					end,
					description = "Ruff: Fix all auto-fixable problems",
				},
				RuffOrganizeImports = {
					function()
						vim.lsp.buf.execute_command({
							command = "ruff.applyOrganizeImports",
							arguments = {
								{ uri = vim.uri_from_bufnr(0) },
							},
						})
					end,
					description = "Ruff: Format imports",
				},
			},
			init_options = {
				settings = { lineLength = 140 },
			},
		})

		vim.lsp.config("lua_ls", {
			-- cmd = { ... },
			-- filetypes = { ... },
			-- capabilities = {},
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = {
						checkThirdParty = false,
						-- Tells lua_ls where to find all the Lua files that you have loaded
						-- for your neovim configuration.
						library = {
							"${3rd}/luv/library",
							unpack(vim.api.nvim_get_runtime_file("", true)),
						},
						-- If lua_ls is really slow on your computer, you can try this instead:
						-- library = { vim.env.VIMRUNTIME },
					},

					completion = {
						callSnippet = "Replace",
					},
					-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- diagnostics = { disable = { 'missing-fields' } },
				},
			},
		})

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require("mason").setup()

		local fish_lsp_server = {}
		fish_lsp_server.capabilities = require("blink.cmp").get_lsp_capabilities(fish_lsp_server.capabilities)
		require("lspconfig").fish_lsp.setup(fish_lsp_server)
		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	pattern = "fish",
		-- 	callback = function()
		-- 		Snacks.notify("sdfsdfsd")
		-- 		vim.lsp.start({
		-- 			name = "fish-lsp",
		-- 			cmd = { "fish-lsp", "start" },
		-- 			cmd_env = { fish_lsp_show_client_popups = true },
		-- 		})
		-- 	end,
		-- })

		local navic = require("nvim-navic")
		navic.setup({
			icons = {
				File = "󰈙 ",
				Module = " ",
				Namespace = "󰌗 ",
				Package = " ",
				Class = "󰌗 ",
				Method = "󰆧 ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = "󰕘",
				Interface = "󰕘",
				Function = "󰊕 ",
				Variable = "󰆧 ",
				Constant = "󰏿 ",
				String = "󰀬 ",
				Number = "󰎠 ",
				Boolean = "◩ ",
				Array = "󰅪 ",
				Object = "󰅩 ",
				Key = "󰌋 ",
				Null = "󰟢 ",
				EnumMember = " ",
				Struct = "󰌗 ",
				Event = " ",
				Operator = "󰆕 ",
				TypeParameter = "󰊄 ",
			},
			lsp = {
				auto_attach = true,
				preference = nil,
			},
			highlight = false,
			separator = " > ",
			depth_limit = 0,
			depth_limit_indicator = "..",
			safe_output = true,
			lazy_update_context = false,
			click = false,
			format_text = function(text)
				return text
			end,
		})
	end,
}
