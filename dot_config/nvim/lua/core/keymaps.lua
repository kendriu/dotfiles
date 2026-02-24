-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- clear highlights
vim.keymap.set("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true, desc = "Clear Highlights" })

-- save file without auto-formatting
vim.keymap.set(
	"n",
	"<leader>wn",
	"<cmd>noautocmd w <CR>",
	{ noremap = true, silent = true, desc = "Save without Format" }
)

-- save all and quit (works in all modes)
vim.keymap.set({ "n", "i", "v" }, "<C-q>", "<cmd>wqa<CR>", { noremap = true, silent = true, desc = "Save All & Quit" })

-- Delete without copying into register
vim.keymap.set("n", "x", '"_d', { noremap = true, silent = true, desc = "Delete (no yank)" })
vim.keymap.set("n", "X", '"_D', { noremap = true, silent = true, desc = "Delete Line (no yank)" })

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Scroll Down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll Up (centered)" })

-- Find and center
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true, desc = "Next Search (centered)" })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true, desc = "Prev Search (centered)" })

-- Resize with arrows
-- vim.keymap.set("n", "<Up>", ":resize -2<CR>", { noremap = true, silent = true, desc = "Decrease Height" })
-- vim.keymap.set("n", "<Down>", ":resize +2<CR>", { noremap = true, silent = true, desc = "Increase Height" })
-- vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", { noremap = true, silent = true, desc = "Decrease Width" })
-- vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", { noremap = true, silent = true, desc = "Increase Width" })

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Prev Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd> enew <CR>", { noremap = true, silent = true, desc = "New Buffer" })

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", { noremap = true, silent = true, desc = "Split Vertical" })
vim.keymap.set("n", "<leader>h", "<C-w>s", { noremap = true, silent = true, desc = "Split Horizontal" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { noremap = true, silent = true, desc = "Equal Window Size" })
vim.keymap.set("n", "<leader>wx", ":close<CR>", { noremap = true, silent = true, desc = "Close Split" })

-- Navigate between splits
-- vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true, desc = "Window Up" })
-- vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true, desc = "Window Down" })
-- vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true, desc = "Window Left" })
-- vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true, desc = "Window Right" })

-- Tabs
vim.keymap.set("n", "<leader>To", ":tabnew<CR>", { noremap = true, silent = true, desc = "Open Tab" })
vim.keymap.set("n", "<leader>Tx", ":tabclose<CR>", { noremap = true, silent = true, desc = "Close Tab" })
vim.keymap.set("n", "<leader>Tn", ":tabn<CR>", { noremap = true, silent = true, desc = "Next Tab" })
vim.keymap.set("n", "<leader>Tp", ":tabp<CR>", { noremap = true, silent = true, desc = "Prev Tab" })

-- UI/Toggles
vim.keymap.set("n", "<leader>uw", "<cmd>set wrap!<CR>", { noremap = true, silent = true, desc = "Toggle Wrap" })
vim.keymap.set("n", "<leader>us", "<cmd>set spell!<CR>", { noremap = true, silent = true, desc = "Toggle Spell" })
vim.keymap.set(
	"n",
	"<leader>ul",
	"<cmd>set number!<CR>",
	{ noremap = true, silent = true, desc = "Toggle Line Numbers" }
)
vim.keymap.set(
	"n",
	"<leader>ur",
	"<cmd>set relativenumber!<CR>",
	{ noremap = true, silent = true, desc = "Toggle Relative Numbers" }
)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent Left" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent Right" })

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true, desc = "Paste (keep register)" })

-- Diagnostic keymaps
vim.keymap.set("n", "]dzz", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "[dzz", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })

-- Quick fix list
vim.keymap.set("n", "]q", ":cnext<CR>zz", { desc = "Go to next on quickfix list" })
vim.keymap.set("n", "[q", ":cprev<CR>zz", { desc = "Go to previous on quickfix list" })

-- System clipboard iteraction
-- Map <Leader>y to yank into the system clipboard
vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to clipboard" })

-- Map <Leader>p to paste from the system clipboard
vim.keymap.set({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from clipboard" })

-- Copy full file path to clipboard
vim.keymap.set("n", "<Leader>yp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
	vim.notify("Copied: " .. vim.fn.expand("%:p"), vim.log.levels.INFO)
end, { desc = "Copy file path to clipboard" })

-- Open cheatsheet
vim.keymap.set("n", "<leader>?", function()
	vim.cmd("edit " .. vim.fn.stdpath("config") .. "/CHEATSHEET.md")
end, { desc = "Open Cheatsheet" })

-- Terminal
vim.keymap.set("n", "<leader>th", "<cmd>split | terminal<CR>", { desc = "Terminal Horizontal" })
vim.keymap.set("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Terminal Vertical" })

-- Terminal mode: easier escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Git amend and push force with lease
vim.keymap.set("n", "<leader>ga", function()
	vim.notify("Amending commit...", vim.log.levels.INFO)

	-- Amend the commit silently (no verbose output)
	local amend_result = vim.fn.system("git commit --all --no-edit --amend 2>&1")

	if vim.v.shell_error ~= 0 then
		vim.notify("Git amend failed: " .. amend_result, vim.log.levels.ERROR)
		return
	end

	-- Check if there's an upstream branch
	local upstream = vim.fn.system("git rev-parse --abbrev-ref @{upstream} 2>/dev/null")
	if vim.v.shell_error ~= 0 then
		vim.notify("No upstream branch to push to", vim.log.levels.WARN)
		return
	end

	-- Push with force-with-lease
	vim.notify("Pushing to " .. vim.trim(upstream) .. "...", vim.log.levels.INFO)
	local push_result = vim.fn.system("git push --force-with-lease 2>&1")

	if vim.v.shell_error == 0 then
		vim.notify("Pushed successfully", vim.log.levels.INFO)
	else
		vim.notify("Push failed: " .. push_result, vim.log.levels.ERROR)
	end
end, { desc = "Git amend and push force with lease" })

-- Git: Commit with visual selection as message
vim.api.nvim_create_user_command("GitCommitSelection", function()
	-- Get visual selection
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	if #lines == 0 then
		vim.notify("No selection to use as commit message", vim.log.levels.WARN)
		return
	end

	-- Join lines and trim
	local commit_msg = table.concat(lines, "\n"):gsub("^%s+", ""):gsub("%s+$", "")

	if commit_msg == "" then
		vim.notify("Empty commit message", vim.log.levels.WARN)
		return
	end

	-- Run git commit
	vim.fn.system(string.format("git commit -m %s", vim.fn.shellescape(commit_msg)))

	if vim.v.shell_error == 0 then
		vim.notify("Committed: " .. commit_msg:sub(1, 50), vim.log.levels.INFO)
	else
		vim.notify("Git commit failed", vim.log.levels.ERROR)
	end
end, { desc = "Commit with selection as message" })

vim.keymap.set("v", "<leader>gc", ":<C-u>GitCommitSelection<CR>", { desc = "Commit with selection" })

vim.keymap.set("n", "<space><space>X", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>X", ":.lua<CR>")
vim.keymap.set("v", "<space>X", ":lua<CR>")

vim.api.nvim_create_user_command("CopyScriptfromBtoE", function()
	-- Yank from mark 'b' to mark 'e' into the default register
	vim.cmd("normal! `bV`e y")
end, { desc = "Copy from mark b to mark e to the default register" })
