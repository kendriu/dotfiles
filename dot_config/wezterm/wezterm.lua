local wezterm = require("wezterm")

local config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	-- enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", -- disable the title bar but enable the resizeble behaviour
	default_cursor_style = "SteadyBlock",
	color_scheme = "Catppuccin Macchiato",
	font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" }),
	font_size = 14,
	keys = {
		-- Maximizes the window using a custom function
		{
			key = "Enter",
			mods = "CTRL",
			action = wezterm.action_callback(function(win, pane)
				win:maximize()
			end),
		},
		-- Splits the current pane horizontally
		{
			key = "d",
			mods = "CMD",
			action = wezterm.action.SplitHorizontal({}),
		},
		-- Splits the current pane vertically
		{
			key = "d",
			mods = "CMD|SHIFT",
			action = wezterm.action.SplitVertical({}),
		},
		-- Moves focus to the pane on the left
		{
			key = "h",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		-- Moves focus to the pane on the right
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		-- Moves focus to the pane above
		{
			key = "k",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
		-- Moves focus to the pane below
		{
			key = "j",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},
		-- Closes the current pane without confirmation
		{
			key = "w",
			mods = "CMD|SHIFT",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},
		-- Moves the current tab to the left
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.MoveTabRelative(-1),
		},
		-- Moves the current tab to the right
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.MoveTabRelative(1),
		},
	},
}
return config
