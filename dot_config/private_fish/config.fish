# Fish Shell Configuration
# Main config file - loads custom modular configuration files

# Load custom configuration files in order
set -l custom_dir ~/.config/fish/custom

if test -d $custom_dir
    # Environment variables
    source $custom_dir/00-env.fish
    
    # PATH configuration
    source $custom_dir/10-paths.fish
    
    # Modern CLI tools (bat, eza, fzf, yazi)
    source $custom_dir/20-tools.fish
    
    # Git abbreviations
    source $custom_dir/30-git.fish
    
    # General abbreviations
    source $custom_dir/40-abbreviations.fish
    
    # Custom helper functions
    source $custom_dir/50-functions.fish
    
    # Cloud automation (AWS auto-switcher)
    source $custom_dir/55-cloud.fish
    
    # Work-specific configuration (conditional)
    source $custom_dir/60-work.fish
    
    # Shell initialization (zoxide, starship)
    source $custom_dir/99-init.fish
end

