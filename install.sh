#!/bin/bash


# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NONE='\033[0m'

# Ensure core visual dependencies are installed
echo -e "${BLUE}Checking for required dependencies: gum, figlet...${NONE}"
sudo pacman -S --needed --noconfirm gum figlet || {
    echo -e "${RED}Failed to install gum and figlet. Exiting.${NONE}"
    exit 1
}

echo -e "${GREEN}"
figlet -f slant "Hyprland Setup"
echo -e "${NONE}"

echo ":: This script will automate the base setup for Hyprland on Arch Linux."
echo ":: Make sure you're running this after a minimal base install and network is enabled."
echo

# Make all scripts in ./scripts and its subdirectories executable
echo -e "${BLUE}Making all setup scripts executable...${NONE}"
find ./scripts -type f -name "*.sh" -exec chmod +x {} \;


# Step 1: yay.sh
echo -e "${BLUE}[1/6] Installing AUR helper...${NONE}"
sudo -u $(logname) bash ./scripts/yay.sh || {
    echo -e "${RED}Failed to run yay.sh. Exiting.${NONE}"
    exit 1
}

# Step 2: nvidia.sh
if gum confirm "Do you have an NVIDIA GPU and want to configure proprietary drivers?"; then
    echo -e "${BLUE}[2/6] Running NVIDIA setup...${NONE}"
    sudo bash ./scripts/nvidia.sh || {
        echo -e "${RED}NVIDIA setup failed. Exiting.${NONE}"
        exit 1
    }
else
    echo -e "${BLUE}[2/6] Skipping NVIDIA setup...${NONE}"
fi

# Step 3: install_packages.sh
echo -e "${BLUE}[4/6] Installing required packages...${NONE}"
bash ./scripts/packages/install_packages.sh || {
    echo -e "${RED}Failed to install packages. Exiting.${NONE}"
    exit 1
}

# Step 4: Copy configuration files
echo -e "${BLUE}[5/6] Copying configuration files...${NONE}"

mkdir -p "$HOME/.config" "$HOME/.cache" "$HOME/.fonts" "$HOME/wallpaper" "$HOME/.icons" "$HOME/.themes"

[ -d ./configs/dotconfig ]   && cp -r ./configs/dotconfig/* "$HOME/.config/"
[ -d ./configs/dotcache ]    && cp -r ./configs/dotcache/* "$HOME/.cache/"
[ -d ./configs/dotfonts ]    && cp -r ./configs/dotfonts/* "$HOME/.fonts/"
[ -d ./configs/dotthemes ]   && cp -r ./configs/dotthemes/* "$HOME/.themes/"
[ -d ./configs/doticons ]    && cp -r ./configs/doticons/* "$HOME/.icons/"
[ -d ./configs/wallpaper ]   && cp -r ./configs/wallpaper/* "$HOME/wallpaper"

# Make any shell scripts in .config executable
find "$HOME/.config" -type f -name "*.sh" -exec chmod +x {} \;

echo -e "${GREEN}✓ Configuration files copied and prepared successfully.${NONE}"


# Step 5: Link user themes/configs to root
echo -e "${BLUE}[6/6] Linking user config to root...${NONE}"
sudo ./scripts/symlink.sh || {
  echo -e "${RED}Symlinking failed. Exiting.${NONE}"
  exit 1
}


# Step 5: sddm.sh
echo -e "${BLUE}[6/6] Configuring SDDM Display Manager...${NONE}"
sudo bash ./scripts/sddm/sddm.sh || {
    echo -e "${RED}Failed to configure SDDM. Exiting.${NONE}"
    exit 1
}

echo -e "${GREEN}"
figlet -f small "Setup Complete!"
echo -e "${NONE}"
