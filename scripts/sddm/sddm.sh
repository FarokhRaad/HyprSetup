#!/bin/bash

# Script to install and configure SDDM
# Run this script with root privileges

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update package repositories
echo "Updating package repositories..."
pacman -Syu --noconfirm

# Install SDDM
echo "Installing SDDM..."
pacman -S --noconfirm sddm

# Verify if SDDM was successfully installed
if ! command -v sddm &> /dev/null; then
  echo "SDDM installation failed. Please check for errors."
  exit 1
fi

# Enable SDDM as the default display manager
# Arch Linux uses systemd to enable SDDM as the display manager
echo "Configuring SDDM as the default display manager..."
systemctl enable sddm.service

# Copy the provided SDDM configuration file
CONFIG_FILE="/etc/sddm.conf"
USER_CONFIG_FILE="./sddm.conf"

if [ -f "$USER_CONFIG_FILE" ]; then
  echo "Copying user-provided SDDM configuration file..."
  cp "$USER_CONFIG_FILE" "$CONFIG_FILE"
  echo "SDDM configuration file copied to $CONFIG_FILE"
else
  echo "User-provided configuration file not found. Using default settings..."
  # Creating an SDDM configuration file (if it doesn't exist)
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating default SDDM configuration file..."
    cat <<EOL > "$CONFIG_FILE"
[Theme]
# Default theme for SDDM
theme=elarun

[Users]
# Automatically login a user (uncomment and change "username" as needed)
# autoLogin=username

[Wayland]
# Enable or disable Wayland sessions
EnableWayland=false
EOL
    echo "Default SDDM configuration file created at $CONFIG_FILE"
  else
    echo "SDDM configuration file already exists. You can edit $CONFIG_FILE to modify settings as needed."
  fi
fi

# Copy Sequoia theme if available
SEQUOIA_THEME_DIR="/usr/share/sddm/themes/sequoia"
USER_SEQUOIA_THEME="./sequoia"

if [ -d "$USER_SEQUOIA_THEME" ]; then
  echo "Copying Sequoia theme to SDDM themes directory..."
  cp -r "$USER_SEQUOIA_THEME" "$SEQUOIA_THEME_DIR"
  echo "Sequoia theme copied to $SEQUOIA_THEME_DIR"
  # Set Sequoia as the default theme
  sed -i 's/^theme=.*/theme=sequoia/' "$CONFIG_FILE"
else
  echo "Sequoia theme not found in the provided location. Skipping theme installation."
fi

# Enable the SDDM service at startup
echo "Enabling SDDM service..."
systemctl enable sddm

# Start SDDM (without rebooting)
echo "Starting SDDM..."
systemctl start sddm

# Finish
echo "SDDM installation and configuration completed successfully."

exit 0
