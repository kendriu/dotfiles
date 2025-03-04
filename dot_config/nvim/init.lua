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
	require("plugins.alpha"),
	require("plugins.autocompletion"),
	require("plugins.autoformatting"),
	require("plugins.bufferline"),
	require("plugins.chezmoi"),
	require("plugins.colortheme"),
	require("plugins.delimiters"),
	require("plugins.diagnostics"),
	require("plugins.docs"),
	require("plugins.gitsigns"),
	require("plugins.ibl"),
	require("plugins.indent-object"),
	require("plugins.lsp"),
	require("plugins.lualine"),
	require("plugins.misc"),
	require("plugins.neotree"),
	require("plugins.telescope"),
	require("plugins.treesitter"),
	require("plugins.trouble"),
	require("plugins.todo"),
	require("plugins.flash"),
	require("plugins.hardtime"),
	require("plugins.signature"),
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- TODO:
--  Install:
--  * https://github.com/desdic/agrolens.nvim?tab=readme-ov-file
--  * https://github.com/sudormrfbin/cheatsheet.nvim
--  * https://github.com/klen/nvim-test
--  *https://github.com/RRethy/vim-illuminate
--  * https://github.com/nvim-neotest/neotest
--  * https://github.com/Bekaboo/deadcolumn.nvim
--  * https://dotfyle.com/plugins/zbirenbaum/copilot.lua
--  * https://dotfyle.com/plugins/zbirenbaum/copilot.lua
--  *  https://dotfyle.com/plugins/rafamadriz/friendly-snippets
--  * https://dotfyle.com/plugins/folke/todo-comments.nvim
--  Configure Trouble with Telescope
--
