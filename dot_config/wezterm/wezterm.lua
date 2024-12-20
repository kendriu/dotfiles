local wezterm = require("wezterm")

local config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	-- enable_tab_bar = false,
	default_prog = { "/opt/homebrew/bin/fish" },
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", -- disable the title bar but enable the resizeble behaviour
	default_cursor_style = "SteadyBlock",
	color_scheme = "Monokai Pro (Gogh)",
	font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" }),
	font_size = 13,
}
return config
