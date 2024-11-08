#!/bin/bash

# Run yay.sh as a regular user
echo "Running yay.sh as a regular user..."
sudo -u $(logname) bash ./scripts/yay.sh

# Run nvidia.sh with root privileges
echo "Running nvidia.sh, root privileges required..."
sudo bash ./scripts/nvidia.sh

# Run hyperpanel.sh as a regular user
echo "Running hyperpanel.sh as a regular user..."
sudo -u $(logname) bash ./scripts/hyperpanel.sh

# Run sddm.sh with root privileges
echo "Running sddm.sh, root privileges required..."
sudo bash ./scripts/sddm/sddm.sh

# Run install_packages.sh as the appropriate user for each type of package
echo "Running install_packages.sh..."
bash ./scripts/packages/install_packages.sh

# Copy the contents of the configs folder into the home directory
echo "Copying configuration files to the home directory..."
cp -r ./configs/* $HOME/

echo "Configuration files copied successfully."
