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
		{
			key = "Enter",
			mods = "CTRL",
			action = wezterm.action_callback(function(win, pane)
				win:maximize()
			end),
		},
		{
			key = "d",
			mods = "CMD",
			action = wezterm.action.SplitHorizontal({}),
		},
		{
			key = "d",
			mods = "CMD|SHIFT",
			action = wezterm.action.SplitVertical({}),
		},
		{
			key = "w",
			mods = "CMD|SHIFT",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},
	},
}
return config
