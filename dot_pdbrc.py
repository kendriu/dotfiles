import pdb
from pygments import formatters


try:

    class Config(pdb.DefaultConfig):
        formatter = formatters.TerminalTrueColorFormatter(
            style="catppuccin-macchiato",
        )
        use_pygments = True
except ModuleNotFoundError:
    pass
