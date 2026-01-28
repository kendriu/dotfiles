# Modern CLI Tools Configuration
# bat, eza, fzf, yazi

# bat - better cat with syntax highlighting
function cat --wraps bat -d "bat with default options"
    bat $argv
end

if type -q batpipe
    eval (batpipe)
end

# fzf - fuzzy finder with Catppuccin theme
set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--color=border:#363a4f,label:#cad3f5"

# eza - better ls with icons
abbr l ls
function ls --wraps eza -d "eza with icons and grouped directories"
    eza --icons=auto --group-directories-first $argv
end

# yazi - terminal file manager with cd integration
function y -d "Open yazi and cd to selected directory"
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
