return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- Setup harpoon with default settings
		harpoon:setup({
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		})

		-- Core harpoon keybindings
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })

		vim.keymap.set("n", "<leader>e", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle menu" })

		-- Quick file switches using number keys (no conflict with <C-h/j/k/l>)
		vim.keymap.set("n", "<C-1>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 1" })

		vim.keymap.set("n", "<C-2>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 2" })

		vim.keymap.set("n", "<C-3>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 3" })

		vim.keymap.set("n", "<C-4>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 4" })

		-- Navigate through harpoon list sequentially
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Prev file" })

		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Next file" })
	end,
}
