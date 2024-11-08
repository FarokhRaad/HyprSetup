#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

# Update system and install necessary packages
echo "Updating system and installing necessary packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm nvidia nvidia-utils nvidia-settings dkms linux-headers libva libva-nvidia-driver

# Improve kernel headers installation logic
kernel_headers_pkg=$(uname -r | sed 's/-arch/-headers/')
echo "Installing kernel headers package: $kernel_headers_pkg"
sudo pacman -S --needed --noconfirm "$kernel_headers_pkg"

# Check if system uses mkinitcpio or dracut and configure accordingly
if [ -f "/etc/mkinitcpio.conf" ]; then
    # Load the NVIDIA module with mkinitcpio
    echo "Configuring mkinitcpio to load NVIDIA modules early..."
    sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
    if ! sudo sed -Ei 's/^(MODULES=\([^)]+)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm fbdev)/' /etc/mkinitcpio.conf; then
        echo "Error modifying mkinitcpio.conf. Restoring backup."
        sudo cp /etc/mkinitcpio.conf.bak /etc/mkinitcpio.conf
        exit 1
    else
        echo "Nvidia modules added to /etc/mkinitcpio.conf"
        echo "Generating a new initramfs with mkinitcpio..."
        sudo mkinitcpio -P
    fi
elif [ -d "/etc/dracut.conf.d" ]; then
    # Load the NVIDIA module with dracut
    echo "Configuring dracut to load NVIDIA and fbdev modules early..."
    echo 'add_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm fbdev "' | sudo tee /etc/dracut.conf.d/nvidia.conf
    echo "Generating a new initramfs with dracut..."
    sudo dracut --force
else
    echo "Neither mkinitcpio nor dracut found. Exiting..."
    exit 1
fi

# Enable DRM modeset
echo "Configuring DRM modeset for NVIDIA..."
if ! grep -q 'GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub; then
    echo 'GRUB_CMDLINE_LINUX_DEFAULT=""' | sudo tee -a /etc/default/grub
fi
if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
    sudo sed -i -e '/GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ nvidia-drm.modeset=1"/' /etc/default/grub
    echo "Updating GRUB..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# Add nvidia.conf to modprobe.d to ensure modeset and fbdev support are enabled
echo "Adding nvidia.conf to /etc/modprobe.d/..."
NVEA="/etc/modprobe.d/nvidia.conf"
echo -e "options nvidia_drm modeset=1" | sudo tee "$NVEA"

# Enable Persistence Daemon
echo "Enabling NVIDIA persistence daemon..."
sudo systemctl enable nvidia-persistenced.service
sudo systemctl start nvidia-persistenced.service

# Consolidate Nouveau blacklisting into a single file
echo "Blacklisting Nouveau driver..."
echo -e "blacklist nouveau\ninstall nouveau /bin/true" | sudo tee /etc/modprobe.d/nouveau.conf

# Create pacman hook to regenerate initramfs after NVIDIA driver update
echo "Creating pacman hook to regenerate initramfs after NVIDIA driver update..."
HOOK_DIR="/etc/pacman.d/hooks"
HOOK_FILE="${HOOK_DIR}/nvidia.hook"

if [ ! -d "$HOOK_DIR" ]; then
    sudo mkdir -p "$HOOK_DIR"
fi

cat <<EOF | sudo tee $HOOK_FILE
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = nvidia
Target = linux

[Action]
Description = Rebuilding initramfs after NVIDIA driver update...
When = PostTransaction
Exec = /usr/bin/mkinitcpio -P
EOF

# Reboot suggestion
echo -e "\nInstallation and configuration completed successfully! It is recommended to reboot your system to apply all changes."

exit 0
