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
		"williamboman/mason-lspconfig.nvim",
		{
			"owallb/mason-auto-install.nvim",
			opts = {
				packages = {
					-- LSP servers (Mason registry names)
					-- Keep in sync with lsp_servers list below
					"bash-language-server",
					"fish-lsp",
					"basedpyright",
					"ruff",
					"rust-analyzer",
					"lua-language-server",
					"taplo",
					"vtsls",
					"vue-language-server",
					"html-lsp",
				},
			},
		},

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		"saghen/blink.cmp",
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

		-- Get shared LSP capabilities from blink.cmp (configured in blink.lua)
		-- blink.lua exports capabilities globally after setup
		local capabilities = _G.blink_capabilities

		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- Get the LSP client
				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Hover Documentation
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				-- Signature Help
				map("<leader>K", vim.lsp.buf.signature_help, "Signature Help")

				-- Code Actions
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

				-- Rename symbol
				map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

				-- Format document
				map("<leader>cf", function()
					vim.lsp.buf.format({ async = true })
				end, "Format Document")

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("gD", vim.lsp.buf.declaration, "Go to Declaration")

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>uh", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "Toggle Inlay Hints")
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

		-- Note: Formatter installation moved to conform.lua
		-- mason-tool-installer is now configured there

		require("mason-lspconfig").setup({
			ensure_installed = {
				"bashls",
				"fish_lsp",
				"basedpyright",
				"ruff",
				"rust_analyzer",
				"lua_ls",
				"taplo",
				"vtsls",
				"vue_ls",
				"html",
			},
			automatic_enable = {
				exclude = { "vue_ls" },
			},
		})

		vim.lsp.config("html", {
			filetypes = { "html", "htmldjango" },
			capabilities = capabilities,
		})
		vim.lsp.config("basedpyright", {
			capabilities = capabilities,
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
			capabilities = (function()
				local caps = vim.deepcopy(capabilities)
				-- Disable ruff LSP formatting - use conform.nvim instead
				caps.textDocument.formatting = nil
				caps.textDocument.rangeFormatting = nil
				return caps
			end)(),
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
			capabilities = capabilities,
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
		local vue_ls_config = { capabilities = capabilities }
		vim.lsp.config("vue_ls", vue_ls_config)

		local vue_language_server_path = vim.fn.expand("$MASON/packages")
			.. "/vue-language-server"
			.. "/node_modules/@vue/language-server"
		local vue_plugin = {
			name = "@vue/typescript-plugin",
			location = vue_language_server_path,
			languages = { "vue" },
			configNamespace = "typescript",
			enableForWorkspaceTypeScriptVersions = true,
		}

		vim.lsp.config("vtsls", {
			capabilities = capabilities,
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							vue_plugin,
						},
					},
				},
			},
			on_attach = function()
				vim.lsp.enable("vue_ls")
			end,
			root_dir = function(bufnr, on_dir)
				-- The project root is where the LSP can be started from
				-- As stated in the documentation above, this LSP supports monorepos and simple projects.
				-- We select then from the project root, which is identified by the presence of a package
				-- manager lock file.
				local root_markers =
					{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", "deno.lock", ".git" }
				-- Give the root markers equal priority by wrapping them in a table
				root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers } or root_markers
				local project_root = vim.fs.root(bufnr, root_markers)
				if not project_root then
					return
				end
				on_dir(project_root)
			end,
		})

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require("mason").setup()

		-- Fish LSP with blink capabilities
		local fish_lsp_config = { capabilities = capabilities }
		vim.lsp.config("fish_lsp", fish_lsp_config)
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
		--
		-- Define a function to start NuShell LSP
		local function start_nu_lsp()
			-- Check if the client is already running
			for _, client in ipairs(vim.lsp.get_active_clients()) do
				if client.name == "nu_lsp" then
					return client
				end
			end

			-- Start the client
			return vim.lsp.start({
				name = "nu_lsp",
				cmd = { "nu", "--lsp" }, -- Nushell binary in LSP mode
				filetypes = { "nu" },
				root_dir = function(fname)
					local path = vim.fs.find({ "Nu.toml", ".git" }, { upward = true })[1]
					if path then
						return vim.fs.dirname(path)
					else
						return vim.loop.cwd()
					end
				end,
			})
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "nu",
			callback = function()
				start_nu_lsp()
			end,
		})
	end,
}
