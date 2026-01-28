print("Advent of neovim")

vim.keymap.set("n", "<space><space>X", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>X", ":.lua<CR>")
vim.keymap.set("v", "<space>X", ":lua<CR>")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
