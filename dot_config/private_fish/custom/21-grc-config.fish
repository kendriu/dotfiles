# grc plugin configuration
# Add executables to ignore here to prevent wrapper conflicts

# Ensure grc is in PATH before plugin checks for it
fish_add_path -g /opt/homebrew/bin

# Prevent grc from wrapping itself
set -g grc_plugin_ignore_execs grc
