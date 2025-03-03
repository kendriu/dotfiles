return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
		"nvim-lua/plenary.nvim",
		"joechrisellis/lsp-format-modifications.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters
		-- list of formatters & linters for mason to install
		require("mason-null-ls").setup({
			ensure_installed = {
				"checkmake",
				"just",
				"shfmt",
				"stylua", -- lua formatter
				"ruff",
				"rustfmt",
			},
			automatic_installation = true,
		})

		local sources = {
			diagnostics.checkmake,
			formatting.just,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.stylua,
			require("none-ls.formatting.rustfmt"),
			require("none-ls.formatting.ruff_format"),
		}
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				vim.api.nvim_buf_create_user_command(bufnr, "FormatModifications", function()
					local lsp_format_modifications = require("lsp-format-modifications")
					lsp_format_modifications.format_modifications(client, bufnr)
				end, {})
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							local lsp_format_modifications = require("lsp-format-modifications")
							local result = lsp_format_modifications.format_modifications(client, bufnr)
							if result.success == false then
								-- not git repository - format entire file
								vim.lsp.buf.format({ async = false })
							end
						end,
					})
				end
			end,
		})
	end,
}
