return {
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"copilotlsp-nvim/copilot-lsp",
		},
		cmd = "Copilot",
		event = "InsertEnter",
		build = ":Copilot auth", -- run once to authenticate
		cond = function()
			-- Only load if this laptop should use Copilot
			local ai_adapter = require("core.ai-adapter")
			return ai_adapter.init() == "copilot"
		end,
		config = function()
			require("copilot").setup({
				nes = {
					enabled = true,
					keymap = {
						accept_and_goto = "<C-e>",
						accept = false,
						dismiss = "<Esc>",
					},
				},
				suggestion = {
					enabled = false, -- Enable for NES to work
				},
				panel = { enabled = false }, -- disable panel when using copilot-cmp
				copilot_node_command = "node", -- override if needed (path to node)
			})

			-- Enable Copilot by default on this laptop
			vim.g.copilot_enabled = true

			-- Add C-e in insert mode to accept NES directly
			vim.keymap.set("i", "<C-e>", function()
				-- Exit insert mode first
				vim.cmd("stopinsert")
				vim.schedule(function()
					-- Call the copilot-lsp NES functions with error handling
					local ok, nes = pcall(require, "copilot-lsp.nes")
					if ok then
						local success, err = pcall(function()
							if nes.apply_pending_nes() then
								nes.walk_cursor_start_edit()
							end
						end)
						if not success then
							vim.notify("Copilot NES error (copilot-lsp bug)", vim.log.levels.WARN)
						end
					end
				end)
			end, { desc = "Accept Copilot NES" })
		end,
	},
}
