vim.opt.number = true -- Make line numbers default
vim.opt.relativenumber = true -- Set relative numbered lines
vim.opt.signcolumn = "yes" -- Always show signcolumn
-- vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim
vim.opt.wrap = false -- Display lines as one long line
vim.opt.linebreak = true -- Companion to wrap don't split words
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.autoindent = true -- Copy indent from current line when starting new line
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.opt.smartcase = true -- Smart case
vim.opt.scrolloff = 10 -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
vim.opt.tabstop = 4 -- insert n spaces for a tab
vim.opt.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.cursorline = true -- highlight the current line
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.undofile = true -- Save undo history
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.shortmess:append("S") -- Don't show search count in command line (shown in statusline instead)
vim.opt.textwidth = 140

-- Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Don't fold by default on file open
vim.opt.foldlevel = 99 -- High fold level so folds aren't closed by default

vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"

vim.g.python3_host_prog = "/Users/andrzej.skupien/neovim_python/.venv/bin/python"

local group = vim.api.nvim_create_augroup("", { clear = true })

vim.api.nvim_create_autocmd("filetype", {
	pattern = "conf",
	callback = function()
		vim.bo.filetype = "yaml"
	end,
	group = group,
})
