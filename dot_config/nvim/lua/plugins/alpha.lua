return {
	"goolord/alpha-nvim",
	-- dependencies = { 'echasnovski/mini.icons' },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local startify = require("alpha.themes.startify")

		-- Define a function to load the last session
		--- @param sc string
		--- @param txt string
		--- @param keybind string? optional
		--- @param keybind_opts table? optional
		--- @param hl_opts table? optional
		local function button(sc, txt, keybind, keybind_opts, hl_opts)
			local leader = "SPC"
			local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

			local opts = {
				position = "left",
				shortcut = "[" .. sc .. "] ",
				cursor = 1,
				-- width = 50,
				align_shortcut = "left",
				hl_shortcut = { { "Operator", 0, 1 }, { "Number", 1, #sc + 1 }, { "Operator", #sc + 1, #sc + 2 } },
				shrink_margin = false,
				hl = { hl_opts },
			}
			if keybind then
				keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
				opts.keymap = { "n", sc_, keybind, keybind_opts }
			end

			local function on_press()
				local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
				vim.api.nvim_feedkeys(key, "t", false)
			end

			return {
				type = "button",
				val = txt,
				on_press = on_press,
				opts = opts,
			}
		end

		local startify_config = startify.config
		table.insert(startify_config.layout, #startify_config.layout - 1, session_group)
		table.insert(startify_config.layout, #startify_config.layout - 1, { type = "padding", val = 1 })
		require("alpha").setup(startify.config)
	end,
}
