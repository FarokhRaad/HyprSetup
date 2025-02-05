#!/bin/bash

# Define package list files
pacman_file="pacman_packages.txt"  
yay_file="yay_packages.txt"        

# Check if files exist
if [[ ! -f "$pacman_file" ]]; then
    echo "Error: $pacman_file not found."
    exit 1
fi

if [[ ! -f "$yay_file" ]]; then
    echo "Error: $yay_file not found."
    exit 1
fi

# Read package lists from files
pacman_packages=($(<"$pacman_file"))
yay_packages=($(<"$yay_file"))

# Function to install packages with pacman (requires root privileges)
install_pacman_packages() {
    echo "Installing packages with pacman..."
    for package in "${pacman_packages[@]}"; do
        sudo pacman -S --needed --noconfirm "$package"
    done
    echo "Pacman package installation complete."
}

# Function to install packages with yay (as a regular user)
install_yay_packages() {
    echo "Installing packages with yay..."
    for package in "${yay_packages[@]}"; do
        yay -S --needed --noconfirm "$package"
    done
    echo "Yay package installation complete."
}

# Check if yay is installed, and install it if missing
if ! command -v yay &> /dev/null; then
    echo "Yay not found. Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install the packages
install_pacman_packages
install_yay_packages

echo "All packages installed successfully."
