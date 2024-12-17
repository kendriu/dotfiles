export LANG=us_US.utf-8
if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end
fundle plugin 'jethrokuan/z'
fundle init

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

function c-sync
    cd ~/.local/share/chezmoi/
    git add .
    git commit -m"$argv"
    git push
end
