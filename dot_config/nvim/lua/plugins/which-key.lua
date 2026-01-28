return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern", -- modern, classic, helix
		delay = 300, -- delay before showing the popup (ms)
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		win = {
			border = "rounded", -- none, single, double, shadow, rounded
			padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
		},
		show_help = true, -- show a help message in the command line for using WhichKey
		show_keys = true, -- show the currently pressed key and its label as a message in the command line
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Register group names/labels
		wk.add({
			-- Top-level keys (fast access, no group)
			{ "<leader><space>", desc = "Smart Find Files", icon = "" },
			{ "<leader>/", desc = "Grep", icon = "" },
			{ "<leader>?", desc = "Open Cheatsheet", icon = "" },
			{ "<leader><Tab>", desc = "File Explorer", icon = "" },
			{ "\\", desc = "Explorer Reveal", icon = "" },
			{ "<leader>z", desc = "Zen Mode", icon = "󰚀" },

			-- Harpoon
			{ "<leader>a", desc = "Add to Harpoon", icon = "󰛢" },
			{ "<leader>e", desc = "Harpoon Menu", icon = "󰛢" },

			-- Dropbar (Breadcrumbs Navigation)
			{ "<leader>;", desc = "Pick Symbol", icon = "" },
			{ "[;", desc = "Context Start", icon = "󰮰" },
			{ "];", desc = "Pick Symbol", icon = "" },

			-- AI/Assistant (CodeCompanion)
			{ "<leader>A", group = "AI/Assistant", icon = "" },
			{ "<leader>Ac", desc = "Toggle Chat", icon = "" },
			{ "<leader>An", desc = "New Chat", icon = "" },
			{ "<leader>Aa", desc = "Action Palette", icon = "" },
			{ "<leader>Ai", desc = "Inline Prompt", icon = "" },
			{ "<leader>Am", desc = "Model/Strategy", icon = "" },
			{ "<leader>Ar", desc = "Run on Selection", icon = "", mode = "v" },
			{ "gA", desc = "Add to AI Chat", icon = "", mode = "v" },

			-- Find/Files
			{ "<leader>f", group = "Find", icon = "" },
			{ "<leader>fb", desc = "Buffers", icon = "" },
			{ "<leader>fc", desc = "Config Files", icon = "" },
			{ "<leader>ff", desc = "Files", icon = "" },
			{ "<leader>fg", desc = "Git Files", icon = "" },
			{ "<leader>fp", desc = "Projects", icon = "" },
			{ "<leader>fr", desc = "Recent", icon = "" },
			{ "<leader>fw", desc = "Flash Word", icon = "⚡" },
			{ "<leader>fj", desc = "Flash Jump Line", icon = "⚡" },

			-- Search
			{ "<leader>s", group = "Search", icon = "" },
			{ "<leader>sb", desc = "Buffer Lines", icon = "" },
			{ "<leader>sB", desc = "Grep Buffers", icon = "" },
			{ "<leader>sg", desc = "Grep", icon = "" },
			{ "<leader>sw", desc = "Word/Selection", icon = "" },
			{ "<leader>sk", desc = "Keymaps", icon = "" },
			{ "<leader>sm", desc = "Marks", icon = "" },
			{ "<leader>sr", desc = "Resume Search", icon = "" },
			{ "<leader>ss", desc = "LSP Symbols", icon = "" },
			{ "<leader>sS", desc = "Workspace Symbols", icon = "" },

			-- Buffers
			{ "<leader>b", group = "Buffers", icon = "" },
			{ "<leader>bb", desc = "New Buffer", icon = "" },
			{ "<leader>bd", desc = "Delete Buffer", icon = "󰅖" },
			{ "<leader>bo", desc = "Delete Others", icon = "󰅙" },
			{ "<leader>bp", desc = "Pin Buffer", icon = "" },
			{ "<leader>bP", desc = "Close Unpinned", icon = "󰐃" },
			{ "<leader>bc", desc = "Close Other Buffers", icon = "󰱝" },
			{ "<leader>bC", desc = "Close Buffers to Right", icon = "" },
			{ "<leader>bf", desc = "First Buffer", icon = "" },
			{ "<leader>bl", desc = "Last Buffer", icon = "" },
			{ "<leader>bj", desc = "Pick Buffer (Jump)", icon = "" },
			{ "<leader>bs", desc = "Sort by Directory", icon = "" },
			{ "<leader>bS", desc = "Sort by Extension", icon = "" },
			{ "<leader>b1", desc = "Buffer 1", icon = "1" },
			{ "<leader>b2", desc = "Buffer 2", icon = "2" },
			{ "<leader>b3", desc = "Buffer 3", icon = "3" },
			{ "<leader>b4", desc = "Buffer 4", icon = "4" },
			{ "<leader>b5", desc = "Buffer 5", icon = "5" },
			{ "<leader>bm", group = "Move Buffer", icon = "" },
			{ "<leader>bm>", desc = "Move Right", icon = "" },
			{ "<leader>bm<", desc = "Move Left", icon = "" },

			-- Code
			{ "<leader>c", group = "Code", icon = "" },
			{ "<leader>ca", desc = "Code Actions", icon = "" },
			{ "<leader>cr", desc = "Rename Symbol", icon = "" },
			{ "<leader>cf", desc = "Format Document", icon = "" },
			{ "<leader>ci", desc = "Go to Implementation", icon = "" },
			{ "<leader>ct", desc = "Go to Type Definition", icon = "" },
			{ "<leader>cR", desc = "Rename File", icon = "" },
			{ "<leader>cs", desc = "Symbols (Trouble)", icon = "" },
			{ "<leader>cl", desc = "LSP Definitions/References", icon = "" },

			-- Refactoring
			{ "<leader>r", group = "Refactor", icon = "" },
			{ "<leader>re", desc = "Extract Function", icon = "", mode = "x" },
			{ "<leader>rf", desc = "Extract Function to File", icon = "", mode = "x" },
			{ "<leader>rv", desc = "Extract Variable", icon = "", mode = "x" },
			{ "<leader>ri", desc = "Inline Variable", icon = "", mode = { "n", "x" } },
			{ "<leader>rb", desc = "Extract Block", icon = "" },
			{ "<leader>rbf", desc = "Extract Block to File", icon = "" },
			{ "<leader>rp", desc = "Debug Print", icon = "" },
			{ "<leader>rc", desc = "Cleanup Debug Prints", icon = "󰃢" },
			{ "<leader>rs", desc = "Refactor Menu", icon = "", mode = { "n", "x" } },

			-- Diagnostics/Trouble
			{ "<leader>D", group = "Diagnostics", icon = "" },
			{ "<leader>Dd", desc = "Buffer Diagnostics", icon = "" },
			{ "<leader>DD", desc = "Workspace Diagnostics", icon = "" },
			{ "<leader>Dl", desc = "Location List", icon = "" },
			{ "<leader>Dq", desc = "Quickfix List", icon = "" },
			{ "<leader>Dt", desc = "TODO List", icon = "" },

			-- Git
			{ "<leader>g", group = "Git", icon = "" },
			{ "<leader>gg", desc = "Lazygit", icon = "" },
			{ "<leader>ga", desc = "Amend & Push", icon = "" },

			-- HTTP/Kulala
			{ "<leader>k", group = "HTTP/Kulala", icon = "󰖟" },

			-- Terminal
			{ "<leader>t", group = "Terminal", icon = "" },
			{ "<leader>tf", desc = "Float Terminal", icon = "" },
			{ "<leader>th", desc = "Horizontal Terminal", icon = "" },
			{ "<leader>tv", desc = "Vertical Terminal", icon = "" },
			{ "<leader>tt", desc = "Tab Terminal", icon = "" },
			{ "<leader>tg", desc = "Lazygit Terminal", icon = "" },
			{ "<leader>tp", desc = "Python REPL", icon = "" },
			{ "<leader>tn", desc = "Node REPL", icon = "" },

			-- Window
			{ "<leader>w", group = "Window", icon = "" },
			{ "<leader>wn", desc = "Save without Format", icon = "" },
			{ "<leader>we", desc = "Equal Window Size", icon = "" },
			{ "<leader>wx", desc = "Close Split", icon = "" },
			{ "<leader>v", desc = "Split Vertical", icon = "" },
			{ "<leader>h", desc = "Split Horizontal", icon = "" },

			-- Tabs
			{ "<leader>T", group = "Tabs", icon = "" },
			{ "<leader>To", desc = "Open Tab", icon = "" },
			{ "<leader>Tx", desc = "Close Tab", icon = "" },
			{ "<leader>Tn", desc = "Next Tab", icon = "" },
			{ "<leader>Tp", desc = "Prev Tab", icon = "" },

			-- Notifications
			{ "<leader>n", group = "Notifications", icon = "" },
			{ "<leader>nh", desc = "History", icon = "" },

			-- UI/Toggles
			{ "<leader>u", group = "UI/Toggles", icon = "" },
			{ "<leader>un", desc = "Dismiss Notifications", icon = "󰅖" },
			{ "<leader>uw", desc = "Toggle Wrap", icon = "" },
			{ "<leader>us", desc = "Toggle Spell", icon = "" },
			{ "<leader>ul", desc = "Toggle Line Numbers", icon = "" },
			{ "<leader>ur", desc = "Toggle Relative Numbers", icon = "" },
			{ "<leader>uh", desc = "Toggle Inlay Hints", icon = "" },

			-- Clipboard
			{ "<leader>y", desc = "Yank to Clipboard", icon = "", mode = { "n", "v" } },
			{ "<leader>p", desc = "Paste from Clipboard", icon = "", mode = { "n", "v" } },

			-- Diagnostics
			{ "]d", desc = "Next Diagnostic", icon = "" },
			{ "[d", desc = "Prev Diagnostic", icon = "" },
			{ "]q", desc = "Next Quickfix", icon = "" },
			{ "[q", desc = "Prev Quickfix", icon = "" },
			{ "]r", desc = "Next Reference", icon = "" },
			{ "[r", desc = "Prev Reference", icon = "" },

			-- Quickfix & Lists
			{ "<leader>l", group = "Lists", icon = "" },
			{ "<leader>ll", desc = "Toggle Quickfix", icon = "" },
			{ "<leader>lo", desc = "Open Quickfix", icon = "" },
			{ "<leader>lc", desc = "Close Quickfix", icon = "" },
			{ "<leader>lL", desc = "Location List", icon = "" },
			{ "<leader>ld", desc = "Diagnostics to Quickfix", icon = "" },

			-- LSP (when available)
			{ "K", desc = "Hover Documentation", icon = "" },
			{ "<leader>K", desc = "Signature Help", icon = "" },
			{ "gd", desc = "Go to Definition", icon = "" },
			{ "gD", desc = "Go to Declaration", icon = "" },
			{ "gR", desc = "References", icon = "" },
			{ "gI", desc = "Go to Implementation", icon = "" },
			{ "gy", desc = "Go to Type Definition", icon = "" },

			-- Flash
			{ "s", desc = "Flash Jump", icon = "⚡", mode = { "n", "x", "o" } },
			{ "S", desc = "Flash Treesitter", icon = "⚡", mode = { "n", "x", "o" } },

			-- Treesitter Text Objects (in visual/operator-pending mode)
			{ "af", desc = "Around Function", mode = { "x", "o" } },
			{ "if", desc = "Inside Function", mode = { "x", "o" } },
			{ "ac", desc = "Around Class", mode = { "x", "o" } },
			{ "ic", desc = "Inside Class", mode = { "x", "o" } },
			{ "aa", desc = "Around Argument", mode = { "x", "o" } },
			{ "ia", desc = "Inside Argument", mode = { "x", "o" } },
			{ "ab", desc = "Around Block", mode = { "x", "o" } },
			{ "ib", desc = "Inside Block", mode = { "x", "o" } },
			{ "al", desc = "Around Loop", mode = { "x", "o" } },
			{ "il", desc = "Inside Loop", mode = { "x", "o" } },
			{ "ao", desc = "Around Conditional", mode = { "x", "o" } },
			{ "io", desc = "Inside Conditional", mode = { "x", "o" } },
			{ "a/", desc = "Around Comment", mode = { "x", "o" } },
			{ "i/", desc = "Inside Comment", mode = { "x", "o" } },

			-- Treesitter Navigation
			{ "]f", desc = "Next Function Start" },
			{ "[f", desc = "Prev Function Start" },
			{ "]c", desc = "Next Class Start" },
			{ "[c", desc = "Prev Class Start" },
			{ "]a", desc = "Next Argument" },
			{ "[a", desc = "Prev Argument" },
			{ "]l", desc = "Next Loop Start" },
			{ "[l", desc = "Prev Loop Start" },
			{ "]o", desc = "Next Conditional Start" },
			{ "[o", desc = "Prev Conditional Start" },
			{ "]b", desc = "Next Block Start" },
			{ "[b", desc = "Prev Block Start" },
			{ "]F", desc = "Next Function End" },
			{ "[F", desc = "Prev Function End" },
			{ "]C", desc = "Next Class End" },
			{ "[C", desc = "Prev Class End" },
			{ "]A", desc = "Next Argument End" },
			{ "[A", desc = "Prev Argument End" },

			-- Treesitter Swap Operations
			{ "<leader>x", group = "eXchange/Swap", icon = "" },
			{ "<leader>xn", desc = "Swap Next Argument", icon = "" },
			{ "<leader>xp", desc = "Swap Prev Argument", icon = "" },
			{ "<leader>xm", desc = "Swap Next Function", icon = "" },
			{ "<leader>xM", desc = "Swap Prev Function", icon = "" },

			-- Peek Definition
			{ "<leader>p", group = "Peek", icon = "" },
			{ "<leader>pf", desc = "Peek Function", icon = "" },
			{ "<leader>pc", desc = "Peek Class", icon = "" },

			-- Explorer
			{ "<leader><Tab>", desc = "File Explorer", icon = "" },
			{ "\\", desc = "Explorer Reveal", icon = "" },
		})
	end,
}
