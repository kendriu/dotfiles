return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local default_format_options = {
			lsp_fallback = true,
			async = false,
			timeout = 500,
		}
		local format_hunks = function()
			local ignore_filetypes = { "lua" }
			if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
				vim.notify("range formatting for " .. vim.bo.filetype .. " not working properly.")
				return default_format_options
			end

			local hunks = require("gitsigns").get_hunks()
			if hunks == nil then
				return default_format_options
			end

			local format = require("conform").format

			local function format_range()
				if next(hunks) == nil then
					vim.notify("done formatting git hunks", "info", { title = "formatting" })
					return
				end
				local hunk = nil
				while next(hunks) ~= nil and (hunk == nil or hunk.type == "delete") do
					hunk = table.remove(hunks)
				end

				if hunk ~= nil and hunk.type ~= "delete" then
					local start = hunk.added.start
					local last = start + hunk.added.count - 1
					-- nvim_buf_get_lines uses zero-based indexing -> subtract from last
					local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
					local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
					format({ range = range, async = true, lsp_fallback = true }, function()
						vim.defer_fn(function()
							format_range()
						end, 1)
					end)
				end
			end

			format_range()
		end

		conform.setup({
			formatters_by_ft = {
				json = { "prettier" },
				just = { "just" },
				lua = { "stylua" },
				markdown = { "prettier" },
				python = { "ruff_format" },
				toml = { "taplo" },
				sh = { "shfmt" },
				yaml = { "prettier" },
			},
			format_on_save = function()
				return format_hunks()
			end,
		})
		conform.formatters.ruff_format = {
			args = { "format", "--force-exclude", "--line-length", "140", "--stdin-filename", "$FILENAME", "-" },
			range_args = function(self, ctx)
				return {
					"format",
					"--force-exclude",
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
		}
		conform.formatters.isort = {
			prepend_args = { "--line-length", "140" },
		}
	end,
}
