return {
	"stevearc/conform.nvim",
	event = { "BufWritePre", "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
	dependencies = {
		{
			"williamboman/mason.nvim",
			config = true,
		},
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "never" })
			end,
			mode = { "n", "v" },
			desc = "Code: Format buffer",
		},
		{
			"<leader>uf",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				local status = vim.g.disable_autoformat and "disabled" or "enabled"
				vim.notify("Format on save " .. status, vim.log.levels.INFO)
			end,
			desc = "Toggle: Format on save",
		},
	},

	config = function()
		-- Setup mason-tool-installer for formatters (and linters)
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- Formatters
				"stylua", -- Lua
				"prettier", -- Web (JS/TS/Vue/HTML/CSS/JSON/YAML/Markdown)
				"biome", -- Web (JS/TS/JSON) - faster alternative
				"shfmt", -- Shell
				"taplo", -- TOML
				"rustfmt", -- Rust (usually comes with rust toolchain)

				-- Linters (keep shellcheck here)
				"shellcheck", -- Shell script linter
			},
			auto_update = true,
			run_on_start = true,
		})

		local conform = require("conform")

		-- Smart git hunks formatting (only format changed lines)
		local format_hunks = function(bufnr)
			-- Respect global/buffer disable flags
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			-- Skip certain filetypes where range formatting doesn't work well
			local ignore_filetypes = { "lua" } -- Python NOT in list - we want hunks!
			if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				-- Full file format for ignored filetypes
				return { timeout_ms = 500, lsp_format = "never" }
			end

			-- Check if gitsigns is available and has hunks
			local ok, gitsigns = pcall(require, "gitsigns")
			if not ok then
				-- No gitsigns, do full file format
				return { timeout_ms = 500, lsp_format = "never" }
			end

			local hunks = gitsigns.get_hunks(bufnr)
			if hunks == nil or #hunks == 0 then
				-- No hunks (untracked or no changes), do full file format
				return { timeout_ms = 500, lsp_format = "never" }
			end

			-- Format each hunk
			local function format_range()
				if next(hunks) == nil then
					return
				end

				local hunk = nil
				while next(hunks) ~= nil and (hunk == nil or hunk.type == "delete") do
					hunk = table.remove(hunks)
				end

				if hunk ~= nil and hunk.type ~= "delete" then
					local start = hunk.added.start
					local last = start + hunk.added.count
					local last_hunk_line = vim.api.nvim_buf_get_lines(bufnr, last - 2, last - 1, true)[1]
					local range = {
						start = { start, 0 },
						["end"] = { last - 1, last_hunk_line:len() },
					}
					conform.format({
						bufnr = bufnr,
						range = range,
						async = true,
						lsp_format = "never", -- KEY: Never use LSP!
					}, function()
						vim.defer_fn(format_range, 1)
					end)
				end
			end

			format_range()
		end

		conform.setup({
			formatters_by_ft = {
				-- Web development
				javascript = { "biome", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettier", stop_after_first = true },
				typescript = { "biome", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettier", stop_after_first = true },
				vue = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },

				-- Data formats
				json = { "biome", "prettier", stop_after_first = true },
				jsonc = { "biome", "prettier", stop_after_first = true },
				yaml = { "prettier" },
				toml = { "taplo" },

				-- Documentation
				markdown = { "prettier" },

				-- Programming languages
				python = { "ruff_format" },
				lua = { "stylua" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				fish = { "fish_indent" },

				-- Build/config
				just = { "just" },
			},

			-- Custom formatter configurations
			formatters = {
				-- Ruff for Python with HARD-CODED 140 char line length
				ruff_format = {
					command = "ruff",
					args = {
						"format",
						"--line-length",
						"140",
						"--stdin-filename",
						"$FILENAME",
						"-",
					},
					range_args = function(ctx)
						return {
							"format",
							"--line-length",
							"140",
							"--range",
							string.format(
								"%d:%d-%d:%d",
								ctx.range.start[1],
								ctx.range.start[2] + 1,
								ctx.range["end"][1],
								ctx.range["end"][2] + 1
							),
							"--stdin-filename",
							"$FILENAME",
							"-",
						}
					end,
				},

				-- Biome with project config detection
				biome = {
					require_cwd = true, -- Only use if biome.json exists
				},

				-- Prettier
				prettier = {
					require_cwd = false,
					prepend_args = { "--prose-wrap", "always" },
				},
			},

			-- Format on save - git hunks (smart format only changed lines)
			format_on_save = function(bufnr)
				return format_hunks(bufnr)
			end,

			-- Notify on formatter errors
			notify_on_error = true,
		})
	end,
}
