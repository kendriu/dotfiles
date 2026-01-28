# Work-Specific Configuration
# VAST-specific functions, abbreviations, and environment variables
# Only loaded if work directories exist

# Check if this is a work environment
if test -d ~/sources/infra
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
end
