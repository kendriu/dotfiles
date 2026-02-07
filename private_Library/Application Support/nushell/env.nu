$env.LANG = "en_US.utf-8"


$env.EDITOR = "nvim"
$env.BAT_THEME = "Catppuccin Macchiato"
$env.PAGER = "bat --paging always"
$env.MANPAGER = "nvim +Man!"

let brew_prefix = ( ^/opt/homebrew/bin/brew --prefix | str trim )

$env.PATH = (
    $env.PATH
    | prepend "/usr/local/bin"
    | prepend $"($brew_prefix)/opt/rustup/bin"
    | prepend $"($env.HOME)/.cargo/bin"
    | prepend $"($env.HOME)/bin"
    | prepend $"($brew_prefix)/opt/gawk/libexec/gnubin"
)

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

mkdir ~/.local/share/atuin/

let file = "~/.local/share/atuin/init.nu"
if not ($file | path exists) {
  atuin init nu | save ~/.local/share/atuin/init.nu
  atuin import fish
  atuin import nu
}
