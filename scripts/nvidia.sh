#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Helpers
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Parse arguments
DRY_RUN=false
for arg in "$@"; do
  [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

# Run wrapper
run() {
  if $DRY_RUN; then
    echo "[DRY RUN] $*"
  else
    eval "$@"
  fi
}

# Banner
if command -v figlet &>/dev/null; then
  echo -e "${GREEN}"
  figlet -f smslant "NVIDIA Setup"
  echo -e "${NC}"
else
  echo -e "${GREEN}== NVIDIA Setup ==${NC}"
fi

# Prerequisite check
for bin in gum sudo; do
  if ! command -v $bin &>/dev/null; then
    error "Missing dependency: '$bin'. Install it via pacman."
    exit 1
  fi
done

# Prompt

if gum confirm "Do you have an NVIDIA GPU and want to install the proprietary driver?"; then

  aur_helper="${aur_helper:-yay}"
  if ! command -v $aur_helper &>/dev/null; then
    error "AUR helper '$aur_helper' not found. Set it explicitly or install yay."
    exit 1
  fi

  info "Removing conflicting Hyprland-NVIDIA packages..."
  if $aur_helper -Qs hyprland &>/dev/null; then
    for pkg in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
      run "$aur_helper -R --noconfirm $pkg 2>/dev/null || true"
    done
    success "Conflicts removed."
  else
    info "No conflicting Hyprland packages found."
  fi

  # Install packages
  info "Installing NVIDIA and VAAPI packages..."
  nvidia_pkgs=(
    nvidia-dkms nvidia-utils nvidia-settings
    libva libva-nvidia-driver-git
  )

  for krnl in $(cat /usr/lib/modules/*/pkgbase 2>/dev/null); do
    run "$aur_helper -S --needed --noconfirm ${krnl}-headers"
  done

  run "$aur_helper -S --needed --noconfirm ${nvidia_pkgs[*]}"
  success "NVIDIA packages installed."

  # Modify mkinitcpio
  if ! grep -qE '^MODULES=.*nvidia.*nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
    run "sudo sed -Ei 's/^(MODULES=\\([^)]+)\\)/\\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf"
    success "Updated mkinitcpio.conf"
  fi
  run "sudo mkinitcpio -P"

  # modprobe config
  conf_file="/etc/modprobe.d/nvidia.conf"
  if [[ ! -f "$conf_file" ]]; then
    run "echo 'options nvidia_drm modeset=1 fbdev=1' | sudo tee $conf_file"
    success "Created modprobe config."
  fi

  # GRUB
  if [[ -f /etc/default/grub ]]; then
    run "sudo sed -i -e '/GRUB_CMDLINE_LINUX_DEFAULT=/ s/\"$/ nvidia-drm.modeset=1 nvidia_drm.fbdev=1\"/' /etc/default/grub"
    run "sudo grub-mkconfig -o /boot/grub/grub.cfg"
    success "Updated GRUB with NVIDIA kernel params."
  fi

  # systemd-boot
  if [[ -f /boot/loader/loader.conf ]]; then
    entries=(/boot/loader/entries/*.conf)
    updated=false
    for entry in "${entries[@]}"; do
      if ! grep -q "nvidia-drm.modeset=1" "$entry"; then
        run "sudo cp $entry $entry.ml4w.bkp"
        run "sdopt=\$(grep -w \"^options\" $entry | sed 's/\\b quiet\\b//g; s/\\b splash\\b//g; s/\\b nvidia.*=1\\b//g')"
        run "sudo sed -i \"/^options/c\\\$sdopt quiet splash nvidia-drm.modeset=1 nvidia_drm.fbdev=1\" $entry"
        updated=true
      fi
    done
    if $updated; then
      success "Updated systemd-boot entries."
    else
      warn "systemd-boot already configured."
    fi
  fi

  # Blacklist Nouveau
  if gum confirm "Would you like to blacklist the Nouveau driver?"; then
    run "echo 'blacklist nouveau' | sudo tee /etc/modprobe.d/nouveau.conf"
    run "echo 'install nouveau /bin/true' | sudo tee /etc/modprobe.d/blacklist.conf"
    success "Nouveau driver blacklisted."
  fi

  success "NVIDIA setup complete."

else
  info "NVIDIA setup skipped."
fi
