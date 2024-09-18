#!/usr/bin/env zsh

set -e  # Exit immediately if a command exits with a non-zero status

setup_homebrew() {
    echo "Setting up Homebrew..."

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || return 1
        
        # Add Homebrew to PATH for ARM Macs
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo "Homebrew already installed. Updating..."
    fi

    # Update Homebrew
    brew update || return 1

    # Install packages from Brewfile
    echo "Installing packages from Brewfile..."
    brew bundle --file=./Brewfile || return 1

    echo "Homebrew setup completed successfully"
}

# Run the setup function and capture its exit status
if setup_homebrew; then
    exit 0  # Success
else
    echo "Error: Homebrew setup failed"
    exit 1  # Failure
fi
