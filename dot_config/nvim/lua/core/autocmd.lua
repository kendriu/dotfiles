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

-- Create user command to check AI adapter status
vim.api.nvim_create_user_command("AIStatus", function()
	local ai_adapter = require("core.ai-adapter")
	local status = ai_adapter.status()
	
	local msg = string.format(
		"AI Adapter Status:\n" ..
		"  Hostname: %s\n" ..
		"  Preferred: %s\n" ..
		"  Current: %s\n" ..
		"  Fallback triggered: %s",
		status.hostname,
		status.preferred,
		status.current,
		status.fallback_triggered and "YES" or "NO"
	)
	
	vim.notify(msg, vim.log.levels.INFO)
end, { desc = "Show AI adapter status" })

