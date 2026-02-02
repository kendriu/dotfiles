# Git Configuration
# Abbreviations and helper functions

# Basic git abbreviations
abbr gst git status
abbr gl git pull
abbr glog git log --oneline --decorate --graph
abbr gcan! git commit --verbose --all --no-edit --amend
abbr gpf git push --force-with-lease

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
