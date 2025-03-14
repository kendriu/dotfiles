-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- clear highlights
vim.keymap.set("n", "<Esc>", ":noh<CR>", opts)

-- save file without auto-formatting
vim.keymap.set("n", "<leader>wn", "<cmd>noautocmd w <CR>", opts)

-- save all and quit
vim.keymap.set("n", "<C-q>", "<cmd> wqa <CR>", opts)

-- Delete without copying into register
vim.keymap.set("n", "x", '"_d', opts)
vim.keymap.set("n", "X", '"_D', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzz", opts)
vim.keymap.set("n", "N", "Nzz", opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>bb", "<cmd> enew <CR>", opts) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set("n", "]dzz", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "[dzz", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })

-- Quick fix list
vim.keymap.set("n", "]q", ":cnext<CR>zz", { desc = "Go to next on quickfix list" })
vim.keymap.set("n", "[q", ":cprev<CR>zz", { desc = "Go to previous on quickfix list" })

-- System clipboard iteraction
-- Map <Leader>++ to copy the last yanked text into the system clipboard
vim.keymap.set("n", "<Leader>++", function()
  vim.fn.setreg("+", vim.fn.getreg('"'))
end, { desc = "Copy last yanked text to clipboard" })

-- Map <Leader>y to yank into the system clipboard
vim.keymap.set("n", "<Leader>y", '"+y', { desc = "Yank to clipboard" })

-- Map <Leader>p to paste from the system clipboard
vim.keymap.set("n", "<Leader>p", '"+p', { desc = "Paste from clipboard" })
