# GitHub Copilot CLI Integration
# Convenient aliases and functions for using gh copilot

# Copilot suggest - Get command suggestions
function ghcs -d "GitHub Copilot suggest command"
    gh copilot suggest $argv
end

# Copilot explain - Explain a command
function ghce -d "GitHub Copilot explain command"
    gh copilot explain $argv
end

# Quick inline suggest - prompt for what you want to do
function ai -d "Quick AI command suggestion"
    if test (count $argv) -eq 0
        echo "Usage: ai <description>"
        echo "Example: ai list all python files modified today"
        return 1
    end
    gh copilot suggest -t shell "$argv"
end

# Explain the last command
function explain-last -d "Explain the last command run"
    set -l last_cmd (history | head -1 | string trim)
    if test -n "$last_cmd"
        echo "Explaining: $last_cmd"
        gh copilot explain "$last_cmd"
    else
        echo "No command in history"
    end
end
