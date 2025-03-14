require("core.options")
require("core.keymaps")

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = false }, -- automatically check for plugin updates
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = false, -- get a notification when changes are found
	},
	install = {
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "catppuccin" },
	},
})

-- TODO:
--  NEOVIM:
--  * https://dotfyle.com/plugins/rafamadriz/friendly-snippets - learn how to use them
--  * https://dotfyle.com/plugins/zbirenbaum/copilot.lua - copilot
--  * https://github.com/Bekaboo/deadcolumn.nvim - Deadcolumn
--  * https://github.com/RRethy/vim-illuminate - highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
--  * https://github.com/klen/nvim-test - tests from nvim
--  * https://github.com/ms-jpq/chadtree?tab=readme-ov-file - replacement for neotree
--  * https://github.com/nvim-neotest/neotest - tests from nvim
--  * https://github.com/nvim-pack/nvim-spectre - sophisticated find & replace
--  * https://github.com/nvim-treesitter/nvim-treesitter-textobjects - Tree-sitter text-objects
--  * https://www.reddit.com/r/neovim/comments/14f0t0n/your_favourite_neovim_plugins/ - set of favorite plugins
--  * https://github.com/ThePrimeagen/harpoon/tree/harpoon2 - HARPOON
--  * https://github.com/akinsho/toggleterm.nvim - A neovim plugin to persist and toggle multiple terminals during an editing session
--  * https://github.com/rgroli/other.nvim - Alternative line for the current buffer
--  * https://github.com/jinh0/eyeliner.nvim - Move faster with unique f/F indicators for each word on the line
--  * https://github.com/mg979/vim-visual-multi - Mutli cursor for nvim
--  * https://github.com/utilyre/barbecue.nvim?tab=readme-ov-file better breadcrumbs
--  * https://github.com/rebelot/heirline.nvim -DYI  rendering statusline/winbar/tabline/statuscolumn (lot of WORK!)
--  * https://github.com/tris203/hawtkeys.nvim - suggests keys for keymaps
--  * https://github.com/aaronik/treewalker.nvim - Move around your code in a syntax tree aware manner.
--  * https://github.com/anuvyklack/hydra.nvim - Once you summon the Hydra through the prefixed binding (the body + any one head), all heads can be called in succession with only a short extension
--  * https://github.com/kevinhwang91/nvim-bqf - better quickfix list
--  * https://github.com/mistweaverco/kulala.nvim - great http client for nvim
--  * https://github.com/MagicDuck/grug-far.nvim - find & replace with ast-grep support			
--  * https://github.com/meznaric/key-analyzer.nvim - Ever wondered which mappings are free to be mapped?
--  * https://github.com/mikavilpas/blink-ripgrep.nvim - Ripgrep project as a source for blink
--  WEZTERM:
--  * https://github.com/michaelbrusegard/tabline.wez - Tabline for Wezterm
--  * https://github.com/xarvex/presentation.wez - presentation Mode
--  xxh:
--  * https://github.com/xxh/xxh - copy your shell to remote machine
