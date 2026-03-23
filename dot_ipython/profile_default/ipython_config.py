from IPython.utils.PyColorize import linux_theme, theme_table
from copy import deepcopy

theme = deepcopy(linux_theme)

# Choose catppuccin theme
# catppuccin_theme = "catppuccin-mocha"
catppuccin_theme = "catppuccin-macchiato"
# catppuccin_theme = "catppuccin-frappe"
# catppuccin_theme = "catppuccin-latte"

theme.base = catppuccin_theme
theme_table[catppuccin_theme] = theme

c = get_config()
c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.colors = catppuccin_theme
