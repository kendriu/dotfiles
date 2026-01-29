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
			{ "<leader><space>", desc = "Find Files", icon = "" },
			{ "<leader>/", desc = "Search in Project", icon = "" },
			{ "<leader>?", desc = "Cheatsheet", icon = "" },
			{ "<leader><Tab>", desc = "File Explorer", icon = "" },
			{ "\\", desc = "Reveal in Explorer", icon = "" },
			{ "<leader>z", desc = "Zen Mode", icon = "󰚀" },

			-- Harpoon
			{ "<leader>a", desc = "Mark File", icon = "󰛢" },
			{ "<leader>e", desc = "Marked Files", icon = "󰛢" },
			{ "<C-1>", desc = "File 1", icon = "1" },
			{ "<C-2>", desc = "File 2", icon = "2" },
			{ "<C-3>", desc = "File 3", icon = "3" },
			{ "<C-4>", desc = "File 4", icon = "4" },
			{ "<C-S-P>", desc = "Prev Marked File", icon = "󰛢" },
			{ "<C-S-N>", desc = "Next Marked File", icon = "󰛢" },

			-- Dropbar (Breadcrumbs Navigation)
			{ "<leader>;", desc = "Jump to Symbol", icon = "" },
			{ "[;", desc = "Go to Context Start", icon = "󰮰" },
			{ "];", desc = "Jump to Symbol", icon = "" },

			-- AI/Assistant (CodeCompanion)
			{ "<leader>A", group = "AI/Assistant", icon = "" },
			{ "<leader>Ac", desc = "Toggle Chat", icon = "" },
			{ "<leader>An", desc = "New Chat", icon = "" },
			{ "<leader>Aa", desc = "Action Palette", icon = "" },
			{ "<leader>Ai", desc = "Ask AI Inline", icon = "" },
			{ "<leader>Am", desc = "Change AI Model", icon = "" },
			{ "<leader>Ar", desc = "Ask AI About Selection", icon = "", mode = "v" },
			{ "<leader>As", desc = "Minimal Edit", icon = "" },
			{ "<leader>Ad", desc = "Debug Ticket", icon = "" },
			{ "<leader>Av", desc = "Review Code", icon = "", mode = { "n", "v" } },
			{ "<leader>AR", desc = "Review Changes", icon = "" },
			{ "<leader>AC", desc = "Write Commit Message", icon = "" },
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
			{ "<leader>sB", desc = "Search All Buffers", icon = "" },
			{ "<leader>sg", desc = "Search in Project", icon = "" },
			{ "<leader>sw", desc = "Search Current Word", icon = "" },
			{ "<leader>sk", desc = "Keymaps", icon = "" },
			{ "<leader>sm", desc = "Marks", icon = "" },
			{ "<leader>sr", desc = "Resume Last Search", icon = "" },
			{ "<leader>ss", desc = "Document Symbols", icon = "" },
			{ "<leader>sS", desc = "Project Symbols", icon = "" },

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
			{ "<leader>bj", desc = "Jump to Buffer", icon = "" },
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
			{ "<leader>ca", desc = "Code Action", icon = "" },
			{ "<leader>cr", desc = "Rename", icon = "" },
			{ "<leader>cf", desc = "Format", icon = "" },
			{ "<leader>cR", desc = "Rename File", icon = "" },
			{ "<leader>cs", desc = "Symbols", icon = "" },
			{ "<leader>cl", desc = "Definitions/References", icon = "" },

			-- Refactoring
			{ "<leader>r", group = "Refactor", icon = "" },
			{ "<leader>re", desc = "Extract Function", icon = "", mode = "x" },
			{ "<leader>rf", desc = "Extract Function to File", icon = "", mode = "x" },
			{ "<leader>rv", desc = "Extract Variable", icon = "", mode = "x" },
			{ "<leader>ri", desc = "Inline Variable", icon = "", mode = { "n", "x" } },
			{ "<leader>rb", desc = "Extract Block", icon = "" },
			{ "<leader>rbf", desc = "Extract Block to File", icon = "" },
			{ "<leader>rp", desc = "Add Debug Print", icon = "" },
			{ "<leader>rc", desc = "Remove Debug Prints", icon = "󰃢" },
			{ "<leader>rs", desc = "Refactor Options", icon = "", mode = { "n", "x" } },

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
			{ "<leader>th", desc = "Horizontal Split", icon = "" },
			{ "<leader>tv", desc = "Vertical Split", icon = "" },

			-- Window
			{ "<leader>w", group = "Window", icon = "" },
			{ "<leader>wn", desc = "Save without Format", icon = "" },
			{ "<leader>we", desc = "Equal Window Size", icon = "" },
			{ "<leader>wx", desc = "Close Split", icon = "" },
			{ "<leader>v", desc = "Split Vertical", icon = "" },
			{ "<leader>h", desc = "Split Horizontal", icon = "" },
			
			-- Window Navigation
			{ "<C-h>", desc = "Window Left", icon = "" },
			{ "<C-j>", desc = "Window Down", icon = "" },
			{ "<C-k>", desc = "Window Up", icon = "" },
			{ "<C-l>", desc = "Window Right", icon = "" },
			{ "<C-q>", desc = "Save All & Quit", icon = "" },
			
			-- Window Resize
			{ "<Up>", desc = "Decrease Height", icon = "" },
			{ "<Down>", desc = "Increase Height", icon = "" },
			{ "<Left>", desc = "Decrease Width", icon = "" },
			{ "<Right>", desc = "Increase Width", icon = "" },

			-- Tabs
			{ "<leader>T", group = "Tabs", icon = "" },
			{ "<leader>To", desc = "Open Tab", icon = "" },
			{ "<leader>Tx", desc = "Close Tab", icon = "" },
			{ "<leader>Tn", desc = "Next Tab", icon = "" },
			{ "<leader>Tp", desc = "Prev Tab", icon = "" },
			
			-- Buffer Switching
			{ "<Tab>", desc = "Next Buffer", icon = "" },
			{ "<S-Tab>", desc = "Prev Buffer", icon = "" },
			{ "<leader>bb", desc = "New Buffer", icon = "" },

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
			{ "<leader>uf", desc = "Toggle Format on Save", icon = "" },

			-- Clipboard
			{ "<leader>y", desc = "Yank to Clipboard", icon = "", mode = { "n", "v" } },
			{ "<leader>p", desc = "Paste from Clipboard", icon = "", mode = { "n", "v" } },

			-- Diagnostics & Navigation
			{ "]d", desc = "Next Diagnostic", icon = "" },
			{ "[d", desc = "Prev Diagnostic", icon = "" },
			{ "]D", desc = "Last Diagnostic", icon = "" },
			{ "[D", desc = "First Diagnostic", icon = "" },
			{ "]q", desc = "Next Quickfix", icon = "" },
			{ "[q", desc = "Prev Quickfix", icon = "" },
			{ "]Q", desc = "Last Quickfix", icon = "" },
			{ "[Q", desc = "First Quickfix", icon = "" },
			{ "]<C-Q>", desc = "Quickfix (Next File)", icon = "" },
			{ "[<C-Q>", desc = "Quickfix (Prev File)", icon = "" },
			{ "]l", desc = "Next Location", icon = "" },
			{ "[l", desc = "Prev Location", icon = "" },
			{ "]L", desc = "Last Location", icon = "" },
			{ "[L", desc = "First Location", icon = "" },
			{ "]<C-L>", desc = "Location (Next File)", icon = "" },
			{ "[<C-L>", desc = "Location (Prev File)", icon = "" },
			{ "]a", desc = "Next Arg", icon = "" },
			{ "[a", desc = "Prev Arg", icon = "" },
			{ "]A", desc = "Last Arg", icon = "" },
			{ "[A", desc = "First Arg", icon = "" },
			{ "]b", desc = "Next Buffer", icon = "" },
			{ "[b", desc = "Prev Buffer", icon = "" },
			{ "]B", desc = "Last Buffer", icon = "" },
			{ "[B", desc = "First Buffer", icon = "" },
			{ "]<Space>", desc = "Blank Line Below", icon = "" },
			{ "[<Space>", desc = "Blank Line Above", icon = "" },
			{ "]r", desc = "Next Reference", icon = "" },
			{ "[r", desc = "Prev Reference", icon = "" },
			
			-- Todo Comments
			{ "]t", desc = "Next TODO", icon = "" },
			{ "[t", desc = "Prev TODO", icon = "" },
			{ "]T", desc = "Last Tag", icon = "" },
			{ "[T", desc = "First Tag", icon = "" },
			{ "]<C-T>", desc = "Tag (Next Match)", icon = "" },
			{ "[<C-T>", desc = "Tag (Prev Match)", icon = "" },
			{ "]w", desc = "Next WARNING", icon = "" },
			{ "[w", desc = "Prev WARNING", icon = "" },
			{ "]n", desc = "Next NOTE", icon = "" },
			{ "[n", desc = "Prev NOTE", icon = "" },

			-- Quickfix & Lists
			{ "<leader>l", group = "Lists", icon = "" },
			{ "<leader>ll", desc = "Toggle Quickfix", icon = "" },
			{ "<leader>lo", desc = "Open Quickfix", icon = "" },
			{ "<leader>lc", desc = "Close Quickfix", icon = "" },
			{ "<leader>lL", desc = "Location List", icon = "" },
			{ "<leader>ld", desc = "Show Diagnostics in List", icon = "" },

			-- LSP
			{ "K", desc = "Show Documentation", icon = "" },
			{ "<leader>K", desc = "Show Signature", icon = "" },
			{ "gd", desc = "Definition", icon = "" },
			{ "gD", desc = "Declaration", icon = "" },
			{ "gR", desc = "References", icon = "" },
			{ "gI", desc = "Implementation", icon = "" },
			{ "gy", desc = "Type Definition", icon = "" },
			{ "gO", desc = "Symbols", icon = "" },
			
			-- LSP gr* keymaps (Neovim defaults)
			{ "gr", group = "LSP", icon = "" },
			{ "gra", desc = "Code Action", icon = "", mode = { "n", "v" } },
			{ "grn", desc = "Rename", icon = "" },
			{ "grr", desc = "References", icon = "" },
			{ "gri", desc = "Implementation", icon = "" },
			{ "grt", desc = "Type Definition", icon = "" },
			
			-- Comment
			{ "gc", desc = "Comment", icon = "󰆉", mode = { "n", "v" } },
			{ "gcc", desc = "Comment Line", icon = "󰆉" },
			
			-- Vim Defaults
			{ "<Esc>", desc = "Clear Highlights", icon = "" },
			{ "n", desc = "Next Search (centered)", icon = "" },
			{ "N", desc = "Prev Search (centered)", icon = "" },
			{ "x", desc = "Delete (no yank)", icon = "" },
			{ "X", desc = "Delete Line (no yank)", icon = "" },
			{ "Y", desc = "Yank to EOL", icon = "" },
			{ "&", desc = "Repeat :s", icon = "" },
			{ "%", desc = "Matching Bracket", icon = "" },
			{ "g%", desc = "Matching Bracket (reverse)", icon = "" },
			{ "[%", desc = "Matching Bracket (prev)", icon = "" },
			{ "]%", desc = "Matching Bracket (next)", icon = "" },
			
			-- Visual Mode
			{ "<", desc = "Indent Left", icon = "", mode = "v" },
			{ ">", desc = "Indent Right", icon = "", mode = "v" },
			{ "p", desc = "Paste (keep register)", icon = "", mode = "v" },
			
			-- Open URL/File
			{ "gx", desc = "Open Link", icon = "", mode = { "n", "v" } },
			
			-- Scroll
			{ "<C-d>", desc = "Scroll Down", icon = "" },
			{ "<C-u>", desc = "Scroll Up", icon = "" },
			{ "<C-f>", desc = "Page Down", icon = "" },
			{ "<C-b>", desc = "Page Up", icon = "" },

			-- Flash
			{ "s", desc = "Jump", icon = "⚡", mode = { "n", "x", "o" } },
			{ "S", desc = "Jump (Treesitter)", icon = "⚡", mode = { "n", "x", "o" } },

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
			{ "]]", desc = "Next Section", icon = "" },
			{ "[[", desc = "Prev Section", icon = "" },
			{ "][", desc = "Next Section End", icon = "" },
			{ "[]", desc = "Prev Section End", icon = "" },
			{ "]f", desc = "Next Function", icon = "" },
			{ "[f", desc = "Prev Function", icon = "" },
			{ "]c", desc = "Next Class", icon = "" },
			{ "[c", desc = "Prev Class", icon = "" },
			{ "]a", desc = "Next Argument", icon = "" },
			{ "[a", desc = "Prev Argument", icon = "" },
			{ "]l", desc = "Next Loop", icon = "" },
			{ "[l", desc = "Prev Loop", icon = "" },
			{ "]o", desc = "Next Conditional", icon = "" },
			{ "[o", desc = "Prev Conditional", icon = "" },
			{ "]b", desc = "Next Block", icon = "" },
			{ "[b", desc = "Prev Block", icon = "" },
			{ "]F", desc = "Next Function End", icon = "" },
			{ "[F", desc = "Prev Function End", icon = "" },
			{ "]C", desc = "Next Class End", icon = "" },
			{ "[C", desc = "Prev Class End", icon = "" },
			{ "]A", desc = "Next Argument End", icon = "" },
			{ "[A", desc = "Prev Argument End", icon = "" },

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
