export LANG=us_US.utf-8
export EDITOR=nvim

if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end
fundle plugin 'jethrokuan/z'
fundle plugin 'jorgebucaran/autopair.fish'
fundle plugin 'franciscolourenco/done'
fundle init

fish_add_path /opt/homebrew/opt/rustup/bin

eval "$(/opt/homebrew/bin/brew shellenv)"

# nvim
abbr v nvim
abbr vim nvim

# fish
abbr cf chezmoi edit -va ~/.config/fish/config.fish
abbr rz fish

# chezmoi
abbr c chezmoi
abbr ca chezmoi apply -v

# brew
function cb -d "Change brew file & install"
    set fish_trace 1
    nvim ~/.local/share/chezmoi/run_onchange_install-packages.sh.tmpl 
    chezmoi apply -v

end

function c-sync
    set fish_trace 1
    cd ~/.local/share/chezmoi/
    git add .
    git commit -m"$argv"
    git push
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
