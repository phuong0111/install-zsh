#!/bin/bash

# Print colorized messages
print_message() {
    echo -e "\n\033[1;34m===> $1\033[0m"
}

print_error() {
    echo -e "\n\033[1;31mERROR: $1\033[0m" >&2
}

# Error handling
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        print_error "An error occurred. Installation failed with exit code: $exit_code"
        print_error "Please check the error message above and try again."
    fi
    exit $exit_code
}

trap cleanup EXIT
set -e

# Check if script is run with sudo
if [ "$EUID" -eq 0 ]; then
    print_error "Please run this script without sudo"
    exit 1
fi

# Install ZSH and required packages
print_message "Installing ZSH and required packages..."
sudo apt install -y zsh curl git

# Install Oh My Zsh
print_message "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install plugins
print_message "Installing plugins..."

# zsh-autosuggestions
print_message "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
print_message "Installing zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# fast-syntax-highlighting
print_message "Installing fast-syntax-highlighting..."
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

# zsh-autocomplete
print_message "Installing zsh-autocomplete..."
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# Configure .zshrc
print_message "Configuring .zshrc..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc

print_message "Installation completed successfully!"
print_message "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
print_message "To change your default shell to zsh, run: chsh -s $(which zsh)"
