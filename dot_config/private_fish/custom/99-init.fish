# Shell Initialization
# Loaded last (99-) to initialize prompt and navigation

if type -q mise
    mise activate fish | source
    if ! type -p usage &>/dev/null
        echo >&2
        echo "Error: usage CLI not found. This is required for completions to work in mise." >&2
        echo "See https://usage.jdx.dev for more information." >&2
        return 1
    end
    set -l tmpdir (if set -q TMPDIR; echo $TMPDIR; else; echo /tmp; end)
    set -l spec_file "$tmpdir/usage__usage_spec_mise_2026_2_5.spec"
    if not test -f "$spec_file"
        mise usage | string collect >"$spec_file"
    end

    set -l tokens
    if commandline -x >/dev/null 2>&1
        complete -xc mise -a "(command usage complete-word --shell fish -f \"$spec_file\" -- (commandline -xpc) (commandline -t))"
    else
        complete -xc mise -a "(command usage complete-word --shell fish -f \"$spec_file\" -- (commandline -opc) (commandline -t))"
    end
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

if type -q tv
    tv init fish | source
end
