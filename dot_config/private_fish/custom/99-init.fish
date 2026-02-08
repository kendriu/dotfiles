# Shell Initialization
# Loaded last (99-) to initialize prompt and navigation

if type -q mise
    mise activate fish | source
end

# zoxide - smart cd with error handling
if type -q zoxide
    zoxide init fish | source
end

# starship - modern prompt
if type -q starship
    starship init fish | source
end

if type -q carapace
    set -gx CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
    carapace _carapace | source
end

if type -q fzf
    fzf --fish | source
end

if type -q atuin
    atuin init fish | source
end
