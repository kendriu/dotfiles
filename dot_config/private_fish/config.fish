# Fish Shell Configuration
# Main config file - loads custom modular configuration files

# Note: conf.d/ files load BEFORE config.fish
# 01-paths.fish is in conf.d/ so it loads first

# Load custom configuration files in order
set -l custom_dir ~/.config/fish/custom

set custom_dir ~/.config/fish/custom

for file in $custom_dir/*.fish
    if test -f $file
        source $file
    end
end
