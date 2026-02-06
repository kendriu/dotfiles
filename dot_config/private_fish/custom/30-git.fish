# Git Configuration
# Abbreviations and helper functions

# Basic git abbreviations
abbr gst git status
abbr gl git pull
abbr glog git log --oneline --decorate --graph
abbr gcan! git commit --verbose --all --no-edit --amend
abbr gpf git push --force-with-lease

function gsb --description "Switch to a git branch using fzf with aligned commit messages"
    # Collect all branches with their last commit messages
    set refs (git for-each-ref --sort=-committerdate --format="%(refname:short)|%(contents:subject)" refs/heads)

    # Find max branch name length for padding
    set max_len 0
    for ref in $refs
        set branch (string split "|" $ref)[1]
        set len (string length -- $branch)
        if test $len -gt $max_len
            set max_len $len
        end
    end

    # Print branches with padded spacing and dimmed commit messages
    for ref in $refs
        set parts (string split "|" $ref)
        set branch $parts[1]
        set message $parts[2]
        # Pad branch with spaces to align commit messages
        set pad (math $max_len - (string length -- $branch))
        printf "%s%*s  \e[2m%s\e[0m\n" "$branch" $pad "" "$message"
    end | fzf --ansi --height=40% --reverse --prompt="Switch to> " | read -l selection

    if test -n "$selection"
        # Branch name is everything before first two spaces
        set branch (string match -r '^\S+' $selection)
        git switch "$branch"
    else
        echo "No branch selected."
    end
end
abbr lg lazygit

function clean_old_branches --description "Delete local git branches whose last commit is older than 3 months"
    set cutoff (date -v-3m +%s)

    set current (git branch --show-current)

    for line in (git for-each-ref --format='%(refname:short) %(committerdate:unix)' refs/heads/)
        set branch (echo $line | awk '{print $1}')
        set commit_date (echo $line | awk '{print $2}')

        if test "$branch" = "$current"
            continue
        end

        if contains $branch main master develop
            continue
        end

        if test $commit_date -lt $cutoff
            echo "Deleting branch: $branch"
            git branch -D $branch
        end
    end
end
