# Shell Initialization
# Loaded last (99-) to initialize prompt and navigation

# zoxide - smart cd with error handling
if type -q zoxide
    zoxide init fish | source
end

# starship - modern prompt
if type -q starship
    starship init fish | source
end
