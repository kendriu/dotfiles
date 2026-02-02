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
    function clogs -d "View crater logs with AWS SSO and lnav"
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

        # Create temp files for logs
        set timestamp (date +"%Y%m%dT%H%M%S")
        set web_tmp "/tmp/web-$timestamp.log"
        set scrub_tmp "/tmp/scrub-$timestamp.log"

        # Start background log streams
        AWS_PROFILE=crater just web-logs $argv >$web_tmp &
        set web_pid $last_pid

        AWS_PROFILE=crater just scrubber-logs $argv >$scrub_tmp &
        set scrub_pid $last_pid

        # Open lnav to view both logs
        lnav $web_tmp $scrub_tmp

        # Clean up background jobs after lnav exits
        kill $web_pid $scrub_pid 2>/dev/null
    end

    # Crater management functions
    function restart-crater --argument cloud --description "Restart crater-dev on specified cloud (e.g., aws)"
        if test -z "$cloud"
            echo "Usage: restart-crater <cloud-name>"
            echo "Example: restart-crater aws"
            return 1
        end

        set -l host "andrzej.skupien@crater-$cloud.vstd.int"
        
        echo "Restarting crater-dev on $host..."
        ssh "$host" "restart-crater-dev.sh"
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
            cat "$script" | ssh -t "$host" 'docker exec -i crater-dev env CLOUD_WATCH=false python -m crater.main interact'
        else
            # Interactive session
            echo "Starting iPython in crater-dev on $host..."
            ssh -t "$host" 'docker exec -it crater-dev env CLOUD_WATCH=false python -m crater.main interact'
        end
    end
    
    function crater-exec --argument cloud script --description "Execute local Python script in crater-dev container"
        if test -z "$cloud"; or test -z "$script"
            echo "Usage: crater-exec <cloud-name> <script.py>"
            echo "Example: crater-exec aws myscript.py"
            return 1
        end

        if not test -f "$script"
            echo "Error: Script file '$script' not found"
            return 1
        end

        set -l host "andrzej.skupien@crater-$cloud.vstd.int"
        
        echo "Executing $script in crater-dev on $host..."
        cat "$script" | ssh "$host" 'docker exec -i crater-dev env CLOUD_WATCH=false python'
    end
end
