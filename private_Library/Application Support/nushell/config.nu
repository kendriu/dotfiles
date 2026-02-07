# config.nu
#
# Installed by:
# version = "0.110.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.show_banner = false

# -------------------------
# fzf configuration
# -------------------------
$env.FZF_DEFAULT_OPTS = "
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
--color=selected-bg:#494d64
--color=border:#363a4f,label:#cad3f5
"

# NuShell commands tweaks
def lsg [] { ls | sort-by type name -i | grid -c -i -s "  " }
def op [file] { open $file | nu-highlight }
alias rz = exec nu


alias lg = lazygit

# nvim
alias v = nvim

# git
alias gst = git status
alias gl = git pull
