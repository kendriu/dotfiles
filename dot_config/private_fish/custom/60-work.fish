# Work-Specific Configuration
# VAST-specific functions, abbreviations, and environment variables
# Only loaded on work laptop

# Check if this is the work laptop (by hostname)
if string match -q "MB-928298.local" (hostname)
    # Work environment variables
    fish_add_path ~/sources/infra/user-scripts
    set -gx USE_QPIPES yes
    set -gx MAIN "TEAM/infra-5.5"
    set -gx NEXT "TEAM/infra-5.5"


    # Work abbreviations
    abbr c ./comet.sh -R DEVVM:orion
    abbr gm git checkout $MAIN
    abbr glm git pull origin $MAIN

    # SSH settings
    set kitty_ssh "kitten ssh"
    alias ssh=$kitty_ssh
    set -gx DEVVM_SSH_COMMAND $kitty_ssh

    # Git rebase on main
    function glrm -d "Switch to main, pull, switch back, and rebase"
        git switch $MAIN
        git pull origin $MAIN
        git switch -
        git rebase $MAIN
    end

    # Git prop automation
    function gp -d "Run git prop for COMET and BUILD"
        git prop $MAIN q:COMET
        git prop $MAIN q:BUILD
        # Commented out for now - legacy code
        # set root $MAIN
        # set first_commit (git cherry $root | head -n 1 | cut -d" " -f2)
        # set message (git log --format=%B -n 1 $first_commit | string trim)
        # set last_message (git log -1 --pretty=%B)
        # git commit --amend -m "$last_message" -m"ci-jobs: COMET"
        # git prop $root BUILD $message
        # git commit --amend -m "$last_message"
        # git prop
    end

    # Jira integration
    if type -q jira
        abbr j jira
        abbr jmy jira issue list -a $(jira me) -s~Closed -s~Integrated -s~Debug --order-by priority --columns PRIORITY,KEY,SUMMARY,STATUS,REPORTER,CREATED

        # Open Jira ticket from current git branch
        function ticket -d "Open Jira ticket from current git branch name"
            # Get current branch name
            set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
            if test $status -ne 0
                echo "❌ Not in a git repository"
                return 1
            end

            # Extract ticket number (e.g., ORION-310342)
            set ticket (string match -r '[A-Z]+-\d+' -- $branch)
            if test -n "$ticket"
                set url "https://vastdata.atlassian.net/browse/$ticket"
                open $url
                echo "✓ Opened $ticket in browser"
            else
                echo "❌ No ticket number found in branch name: $branch"
                return 1
            end
        end
    end

    # Crater logs viewer with AWS SSO
    function clogs -d "View project logs with AWS SSO and lnav (auto-detects project from git root)"
        # Check AWS SSO authentication
        if not aws sts get-caller-identity --profile crater >/dev/null 2>&1
            echo "🔐 AWS SSO not logged in; running aws sso login..."
            aws sso login --use-device-code --profile crater

            # If login failed or was cancelled, stop
            if test $status -ne 0
                echo "❌ AWS SSO login failed"
                return 1
            end
        end

        # Find project root by locating .git folder
        set -l current_dir (pwd)
        set -l project_root ""
        
        while test "$current_dir" != "/"
            if test -d "$current_dir/.git"
                set project_root $current_dir
                break
            end
            set current_dir (dirname $current_dir)
        end
        
        # Get project name from root directory
        if test -z "$project_root"
            echo "⚠️  Not in a git repository"
            return 1
        end
        
        set -l project (basename $project_root)
        
        # Define log sources per project
        set -l log_sources
        switch $project
            case 'autoscaler'
                set log_sources 'autoscaler'
            case 'crater'
                set log_sources 'crater-web' 'crater-scrubber'
            case '*'
                echo "⚠️  Unknown project: $project (no log sources configured)"
                return 1
        end

        # Hash args for cache
        set args_hash (echo $argv | md5)
        
        # Build file paths and check cache
        set log_files
        set markers
        set all_cached true
        
        for source in $log_sources
            set log_file "/tmp/$source-$args_hash.log"
            set marker "$log_file.done"
            set log_files $log_files $log_file
            set markers $markers $marker
            
            if not test -f $marker
                set all_cached false
            end
        end

        # If all cached, open and return
        if test $all_cached = true
            echo "📂 Using cached $project logs for: $argv"
            lnav $log_files
            return
        end

        # Download all sources in background
        echo "📥 Downloading $project logs for: $argv"
        rm -f $markers
        set pids
        
        for i in (seq (count $log_sources))
            set source $log_sources[$i]
            set log_file $log_files[$i]
            set marker $markers[$i]
            
            # Determine awslogs command based on source naming
            if string match -q 'crater-*' $source
                set cmd "awslogs get -SG $source --profile crater"
            else
                set cmd "awslogs get $source -SG --profile crater"
            end
            
            fish -c "$cmd "(string join ' ' -- (string escape -- $argv))" > $log_file 2>&1; and test -s $log_file; and touch $marker" &
            set pids $pids $last_pid
        end

        # Wait briefly for downloads to start, then open lnav
        sleep 1
        lnav $log_files

        # Cleanup
        for pid in $pids
            kill $pid 2>/dev/null
        end
    end

    # Crater management functions
    function deploy-branch --argument cloud --description "Deploys and restarts current bookmark on specified cloud (e.g., aws)"
        if test -z "$cloud"
            echo "Usage: deploy-branch <cloud-name>"
            echo "Example: deploy-branch aws"
            return 1
        end

        set -l host "andrzej.skupien@crater-$cloud.vstd.int"
        set -l bookmark (jj log -r @ -T 'bookmarks' | head -1 | string replace -r '^@\s*' '' | string replace -r '\*$' '')
        
        echo "Deploying bookmark '$bookmark' to crater-dev on $host..."
        ssh "$host" "restart-crater.sh dev branch-$bookmark"
    end

    function crater-ipython --argument cloud script --description "Start iPython shell in crater-dev container on specified cloud"
        if test -z "$cloud"
            echo "Usage: crater-ipython <cloud-name> [script.py]"
            echo "Example: crater-ipython aws"
            echo "Example: crater-ipython aws myscript.py"
            return 1
        end

        set -l host "andrzej.skupien@crater-$cloud.vstd.int"
        
        if test -n "$script"
            # Execute local script in remote Python session
            if not test -f "$script"
                echo "Error: Script file '$script' not found"
                return 1
            end

            echo "Running $script in crater-dev on $host..."
            cat "$script" | /usr/bin/ssh -t "$host" 'docker exec -i crater-dev env CLOUD_WATCH=false python -m crater.main interact'
        else
            # Interactive session
            echo "Starting iPython in crater-dev on $host..."
            /usr/bin/ssh -t "$host" 'docker exec -it crater-dev env CLOUD_WATCH=false python -m crater.main interact'
        end
    end
end
