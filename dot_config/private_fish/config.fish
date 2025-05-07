set -gx LANG us_US.utf-8
set fish_greeting

fish_add_path /opt/homebrew/opt/rustup/bin
fish_add_path $HOME/bin

eval "$(/opt/homebrew/bin/brew shellenv)"

#bat 
set -gx BAT_THEME "Catppuccin Macchiato"
set -gx PAGER bat
set -gx MANPAGER bat
function cat --wraps bat
    bat $argv
end
eval (batpipe)

# fzf
set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--color=border:#363a4f,label:#cad3f5"

# nvim
set -gx EDITOR nvim
abbr v nvim
abbr vim nvim
abbr n neovide
function cv
    cd ~/.config/nvim
    set fish_trace 1
    nvim
    chezmoi --force forget ~/.config/nvim
    chezmoi add ~/.config/nvim
end

# wezterm
abbr cw chezmoi edit -a ~/.config/wezterm/wezterm.lua

# fish
function cf
    set fish_trace 1
    chezmoi edit -a ~/.config/fish/config.fish
    fish
end
abbr rz fish

# eza 
abbr l ls
function ls --wraps eza
    eza --icons=auto --group-directories-first $argv
end

# yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# chezmoi
abbr ch chezmoi
abbr chc cd ~/.local/share/chezmoi/
abbr cha chezmoi apply
abbr chu chezmoi update

function c-sync
    set fish_trace 1
    cd ~/.local/share/chezmoi/
    git add .
    git commit -mSync
    git push
end

# brew
function cb -d "Change brew file & install"
    set fish_trace 1
    nvim ~/.local/share/chezmoi/run_onchange_install-packages.sh.tmpl
    chezmoi apply

end

# git
abbr gst git status
abbr gl git pull
abbr glog git log --oneline --decorate --graph
abbr gcan! git commit --verbose --all --no-edit --amend
abbr gpf git push --force-with-lease

# ssh
abbr cssh chezmoi edit -a ~/.ssh/config

# starship
starship init fish | source

# misc
abbr a source .venv/bin/activate.fish

fish_add_path /Users/andrzej.skupien/sources/infra/user-scripts
fish_add_path /usr/local/bin/

# set -gx USE_QPIPES yes
set -gx MAIN "release/5.3.0"
set -gx NEXT "TEAM/infra-5.4"

abbr c ./comet.sh -R DEVVM:orion
abbr gm git checkout $MAIN
abbr glm git pull origin $MAIN
abbr j just -f ./.local/justfile

function glrm
    git switch $MAIN
    git pull origin $MAIN
    git switch -
    git rebase $MAIN

end

function gp
    set root $MAIN
    set first_commit (git cherry $root | head -n 1 | cut -d" " -f2)
    set message (git log --format=%B -n 1 $first_commit | string trim)
    set last_message (git log -1 --pretty=%B)
    git commit --amend -m "$last_message" -m"ci-jobs: COMET"

    git prop $root BUILD $message
    git commit --amend -m "$last_message"

    git prop
end

function r --wraps rsync
    fswatch --recursive --one-per-batch $argv[1] | while read line
        rsync -ah --stats --delete-after \
            --filter=":- $argv[1]/.gitignore" \
            --filter=':- ~/.gitignore' \
            $argv
        set_color yellow
        date
        set_color normal
        terminal-notifier -title Orion -message Synced
    end
end

#zoxide 
zoxide init fish | source
