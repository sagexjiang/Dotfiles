#!/usr/bin/env zsh

set -e  # Exit immediately if a command exits with a non-zero status

# Setup zsh configuration files
setup_zsh_files() {
    echo "Setting up zsh configuration files..."
    
    # Set ZDOTDIR
    echo "export ZDOTDIR=\"\$HOME/.config/zsh\"" > $HOME/.zshenv
    
    # Create necessary directories
    mkdir -p $HOME/.config/zsh
    mkdir -p $HOME/.local/share/zsh
    
    # Create .zshrc
    cat > "$HOME/.config/zsh/.zshrc" << EOL
# Source zsh dotfiles
source "\$ZDOTDIR/env.zsh"
source "\$ZDOTDIR/aliases.zsh"
source" \$ZDOTDIR/functions.zsh"
source "\$ZDOTDIR/plugins.zsh"
source "\$ZDOTDIR/options.zsh"
source "$ZDOTDIR/completions.zsh"

# Initialize zoxide
eval "$(zoxide init zsh)"

EOL
    
    # Create env.zsh for environment variables and PATH
    cat > "$HOME/.config/zsh/env.zsh" << EOL
# PATH management
typeset -U path  # Ensure unique entries in PATH

# Add paths here:
path=(
    /opt/homebrew/bin
    \$HOME/.local/bin
    \$path
)

export PATH

# History settings
HISTFILE="\$HOME/.local/share/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Choose editors
export EDITOR="nvim"
export VISUAL="code"

# Homebrew setup
eval "\$(/opt/homebrew/bin/brew shellenv)"

EOL

    # Create aliases.zsh
    cat > "$HOME/.config/zsh/aliases.zsh" << EOL
# Base Aliases
alias ls='eza'
alias ll='eza -lh'
alias la='eza -lah'
alias tree='eza --tree'
alias cat='bat'

EOL

    # Create functions.zsh
    cat > "$HOME/.config/zsh/functions.zsh" << EOL
# Function to create a new directory and enter it
mkcd() {
    mkdir -p "\$@" && cd "\$_"
}

EOL

    # Create options.zsh
    cat > "$HOME/.config/zsh/options.zsh" << EOL
# Changing directories
# If a command is issued that can't be executed as a normal command, and the command is 
# the name of a directory, perform the cd command to that directory.
setopt auto_cd

# Expansion and Globbing
# Treat the '#', '~' and '^' characters as part of patterns for filename generation, etc.
setopt extended_glob

# Input/Output
# Allow comments even in interactive shells.
setopt interactive_comments

EOL

    # Setup zsh plugins
    mkdir -p "$HOME/.config/zsh/plugins"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.config/zsh/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.config/zsh/plugins/zsh-autosuggestions"

    cat > "$HOME/.config/zsh/plugins.zsh" << EOL
# Load zsh plugins
source "\$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "\$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

EOL

    # Create completions.zsh
    cat > "$HOME/.config/zsh/options.zsh" << EOL
# Load the completion system
autoload -Uz compinit
compinit

# Enable menu-style completion
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colorize completion suggestions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

# Fuzzy match mistyped completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Completion for specific commands can be added here
# For example, for the 'git' command:
# zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
# fpath=(~/.zsh $fpath)

EOL

    echo "Zsh configuration files created."
}

# Run the setup function and capture its exit status
if setup_zsh_files; then
    exit 0  # Success
else
    echo "Error: Zsh setup failed"
    exit 1  # Failure
fi
