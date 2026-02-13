# Custom Functions
# User-defined helper functions

# Smart Python virtualenv activation
function venv -d "Activate Python venv (auto-detect .venv, venv, or env)"
    for dir in .venv venv env
        if test -f $dir/bin/activate.fish
            source $dir/bin/activate.fish
            echo "✓ Activated $dir"
            return 0
        end
    end
    echo "❌ No virtualenv found (.venv, venv, or env)"
    return 1
end
abbr a venv

# Automatic Python virtualenv activation on directory change
function _auto_venv --on-variable PWD -d "Auto-activate Python venv on directory change"
    # Deactivate current venv if we're in one
    if set -q VIRTUAL_ENV
        # Check if we're still in the same venv's parent directory tree
        set -l venv_dir (dirname $VIRTUAL_ENV)
        if not string match -q "$venv_dir*" $PWD
            # We've left the venv directory, deactivate
            if functions -q deactivate
                deactivate 2>/dev/null
            end
            set -e VIRTUAL_ENV
        end
    end

    # Try to activate venv in current or parent directories
    set -l current_dir $PWD
    while test $current_dir != /
        for venv_name in .venv venv env
            if test -f $current_dir/$venv_name/bin/activate.fish
                # Only activate if not already in this venv
                if not set -q VIRTUAL_ENV; or test $VIRTUAL_ENV != $current_dir/$venv_name
                    source $current_dir/$venv_name/bin/activate.fish 2>/dev/null
                    set -gx VIRTUAL_ENV $current_dir/$venv_name
                end
                return 0
            end
        end
        # Move to parent directory
        set current_dir (dirname $current_dir)
    end
end

# Watch directory and rsync on changes
function r --wraps rsync -d "Watch directory and rsync on changes (respects .gitignore)"
    # Usage: r SOURCE DEST
    # Watches SOURCE recursively, syncs to DEST on any change
    # Respects .gitignore files in source and home
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

function rfv
    tv text
end

function upgrade-all --description "Upgrade all Homebrew packages and tools managed by mise, then clean up old versions."
    chezmoi update
    brew upgrade
    brew cleanup --scrub
    mise self-update --yes
    mise install
    mise upgrade --bump --yes
    mise prune --yes

    # Neovim: Lazy plugins
    echo "Updating Neovim Lazy plugins..."
    nvim --headless -c "Lazy! sync" +qa 2>&1 | rg "^\s*\S+\s+(updated|installed)" || echo "  ✓ All up to date"

    # Neovim: Mason packages
    echo "To update Mason packages, run: nvim and then :Mason -> press U on packages"
end

alias cb="nvim ~/.local/share/chezmoi/run_onchange_10-install-packages.fish.tmpl"
