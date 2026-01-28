require("core.options")
require("core.keymaps")
require("core.autocmd")

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
--  * https://github.com/klen/nvim-test - tests from nvim
--  * https://github.com/nvim-neotest/neotest - tests from nvim
--  * ✅ https://github.com/nvim-treesitter/nvim-treesitter-textobjects - Treesitter text objects (Installed: af/if=function, ac/ic=class, aa/ia=param, ]f/[f=jump)
--  * https://www.reddit.com/r/neovim/comments/14f0t0n/your_favourite_neovim_plugins/ - set of favorite plugins
--  * ✅ https://github.com/ThePrimeagen/harpoon/tree/harpoon2 - HARPOON (Installed: <leader>a=add, <leader>e=menu, <C-1/2/3/4>=quick switch)
--  * ✅ https://github.com/akinsho/toggleterm.nvim - Terminal integration (Installed: <C-\>=toggle, <leader>t[fhvt]=float/horiz/vert/tab, <leader>t[gpn]=lazygit/python/node)
--  * https://github.com/rgroli/other.nvim - Alternative file for the current buffer
--  * https://github.com/jinh0/eyeliner.nvim - Move faster with unique f/F indicators for each word on the line
--  * https://github.com/mg979/vim-visual-multi - Mutli cursor for nvim
--  * https://github.com/utilyre/barbecue.nvim -  better breadcrumbs
--  * https://github.com/aaronik/treewalker.nvim - Move around your code in a syntax tree aware manner.
--  * https://github.com/anuvyklack/hydra.nvim - Once you summon the Hydra through the prefixed binding (the body + any one head), all heads can be called in succession with only a short extension
--  * ✅ https://github.com/kevinhwang91/nvim-bqf - Better quickfix list (Installed: <leader>qq=toggle, Tab/S-Tab=navigate, p=preview)
--  * https://github.com/mistweaverco/kulala.nvim - great http client for nvim
--  * https://github.com/rest-nvim/rest.nvim - rest client
--  * https://github.com/mikavilpas/blink-ripgrep.nvim - Ripgrep project as a source for blink
--  * https://nvimdev.github.io/lspsaga/outline/ - better lsp experience
--  WEZTERM:
--  * https://github.com/michaelbrusegard/tabline.wez - Tabline for Wezterm
--  * https://github.com/xarvex/presentation.wez - presentation Mode
--  xxh:
--  * https://github.com/xxh/xxh - copy your shell to remote machine
