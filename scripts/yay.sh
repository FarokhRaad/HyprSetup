#!/bin/bash

# Define colors for output to make it easy to read
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print success messages
function success {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to print error messages
function error {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  error "Please do not run this script as root."
  exit 1
fi

# Update system packages and install base-devel, git
sudo pacman -Syu --needed --noconfirm base-devel git
if [ $? -eq 0 ]; then
  success "System updated and base-devel + git installed."
else
  error "Failed to update system or install required packages."
  exit 1
fi

# Clone the yay repository from AUR
if [ ! -d "yay" ]; then
  git clone https://aur.archlinux.org/yay.git
  if [ $? -eq 0 ]; then
    success "yay repository cloned successfully."
  else
    error "Failed to clone yay repository."
    exit 1
  fi
else
  success "yay directory already exists. Skipping cloning."
fi

# Change directory to yay and build package
cd yay || { error "Failed to enter the yay directory."; exit 1; }
makepkg -si --noconfirm
if [ $? -eq 0 ]; then
  success "yay installed successfully."
else
  error "Failed to build and install yay."
  exit 1
fi

# Cleanup
cd ..
rm -rf yay
success "Installation complete and temporary files cleaned up."

# Verification
yay --version &>/dev/null
if [ $? -eq 0 ]; then
  success "yay is installed and working correctly."
else
  error "yay installation verification failed."
  exit 1
fi
