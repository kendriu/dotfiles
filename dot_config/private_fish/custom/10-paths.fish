# PATH Configuration
# Loaded early (10-) to ensure paths are set for other modules

fish_add_path (brew --prefix)/opt/gawk/libexec/gnubin
fish_add_path $HOME/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /opt/homebrew/opt/rustup/bin
fish_add_path /usr/local/bin

# Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"
