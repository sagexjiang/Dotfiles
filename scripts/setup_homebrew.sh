#!/usr/bin/env zsh

set -e  # Exit immediately if a command exits with a non-zero status

setup_homebrew() {
    echo "Setting up Homebrew..."

    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || return 1
        eval "$(/opt/homebrew/bin/brew shellenv)" || return 1
    else
        echo "Homebrew already installed. Updating..."
    fi
    
    brew update || return 1
    brew upgrade || return 1

    echo "Installing packages from Brewfile..."
    brew bundle --file=./Brewfile || return 1

    echo "Homebrew setup completed successfully."
}

# Run the setup function and capture its exit status
if setup_homebrew; then
    exit 0  # Success
else
    echo "Error: Homebrew setup failed"
    exit 1  # Failure
fi
