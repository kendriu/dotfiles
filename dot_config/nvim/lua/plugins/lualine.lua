return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		-- Custom functions for statusline indicators
		local function macro_recording()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end
			return string.format("󰒲 @%s", reg)
		end

		local function search_count()
			if vim.v.hlsearch == 0 then
				return ""
			end
			local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
			if not ok or result.current == 0 then
				return ""
			end
			return string.format(" %d/%d", result.current, result.total)
		end

		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return ""
			end
			local client_names = {}
			for _, client in ipairs(clients) do
				table.insert(client_names, client.name)
			end
			return "  " .. table.concat(client_names, ", ")
		end

		local function lazy_updates()
			local ok, lazy = pcall(require, "lazy.status")
			if not ok then
				return ""
			end
			return lazy.updates()
		end

		local function has_lazy_updates()
			local ok, lazy = pcall(require, "lazy.status")
			return ok and lazy.has_updates()
		end

		local opts = {
			options = {
				icons_enabled = true,
				theme = "catppuccin",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = true, -- Modern: single statusline for all windows
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"diff",
					{
						"diagnostics",
						sources = { "nvim_diagnostic", "nvim_lsp" },
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = " ",
						},
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						symbols = {
							modified = "●",
							readonly = "",
							unnamed = "[No Name]",
							newfile = "",
						},
					},
				},
				lualine_x = {
					{ macro_recording, color = { fg = "#ff9e64" } },
					{ search_count, color = { fg = "#7dcfff" } },
					{ lazy_updates, cond = has_lazy_updates, color = { fg = "#ff9e64" } },
					{ lsp_clients, color = { fg = "#7aa2f7" } },
					{ "encoding", cond = function()
						return vim.bo.fenc ~= "" and vim.bo.fenc ~= "utf-8"
					end },
					{ "fileformat", cond = function()
						return vim.bo.fileformat ~= "unix"
					end },
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = { "lazy", "toggleterm", "trouble" },
		}
		require("lualine").setup(opts)
	end,
}
