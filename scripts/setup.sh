#!/usr/bin/env zsh

# Initialize an array to store failed steps
failed_steps=()

run_step() {
    echo "Starting $1"
    if ./scripts/$1.sh; then
        echo "$1 completed successfully"
    else
        echo "Error: $1 failed"
        failed_steps+=("$1")
    fi
    echo
}

main() {
    echo "Starting setup"
  
    run_step "setup_homebrew"
    run_step "setup_zsh"
    run_step "setup_vscode"
    run_step "setup_wezterm"
    
    if [ ${#failed_steps[@]} -eq 0 ]; then
        echo "Setup completed successfully"
        echo "Please restart your terminal or run 'source ~/.zshenv' to apply changes"
    else
        echo "Setup completed with errors"
        echo "The following steps failed:"
        for step in "${failed_steps[@]}"; do
            echo "- $step"
        done
        echo "Please check the output above for more details"
        exit 1
    fi
}

main
