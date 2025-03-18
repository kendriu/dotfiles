import pdb
import pygments


try:

    class Config(pdb.DefaultConfig):
        formatter = pygments.formatters.TerminalTrueColorFormatter(
            style="catppuccin-macchiato",
        )
        use_pygments = True
except ModuleNotFoundError:
    pass
