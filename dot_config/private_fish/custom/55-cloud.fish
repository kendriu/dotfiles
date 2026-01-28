# Cloud Configuration (AWS, Azure, OCI)
# Automatic profile switching and cloud helpers

# Automatic AWS profile switching based on directory
function _auto_aws_profile --on-variable PWD -d "Auto-switch AWS profile based on project directory"
    # Define project directory to AWS profile mappings
    set -l project_mappings \
        "$HOME/sources/crater" "crater" \
        "$HOME/sources/autoscaler" "autoscaler"
    
    # Check if we're in any mapped project directory
    for i in (seq 1 2 (count $project_mappings))
        set -l project_dir $project_mappings[$i]
        set -l profile_name $project_mappings[(math $i + 1)]
        
        # Check if current directory is within this project
        if string match -q "$project_dir*" $PWD
            # Only change if profile is different
            if test "$AWS_PROFILE" != "$profile_name"
                set -gx AWS_PROFILE $profile_name
                echo "☁️  AWS profile: $profile_name"
            end
            return 0
        end
    end
    
    # Not in any mapped directory - unset AWS_PROFILE
    if set -q AWS_PROFILE
        set -e AWS_PROFILE
    end
end

# Manual AWS profile switcher with fzf
function awsp -d "Switch AWS profile interactively"
    if not type -q aws
        echo "❌ AWS CLI not installed"
        return 1
    end
    
    set -l profile (aws configure list-profiles | fzf --height 40% --reverse --prompt="AWS Profile: ")
    if test -n "$profile"
        set -gx AWS_PROFILE $profile
        echo "✓ Switched to AWS profile: $profile"
    end
end

# Show current AWS profile and identity
function awswho -d "Show current AWS profile and identity"
    if set -q AWS_PROFILE
        echo "Profile: $AWS_PROFILE"
        aws sts get-caller-identity 2>/dev/null
    else
        echo "No AWS_PROFILE set (using default)"
        aws sts get-caller-identity 2>/dev/null
    end
end

# Quick profile check
function awsprofile -d "Show current AWS profile"
    if set -q AWS_PROFILE
        echo "$AWS_PROFILE"
    else
        echo "default"
    end
end
