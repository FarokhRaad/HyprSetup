#!/bin/bash

# === Color and Logging Setup ===
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }

# === Dry-Run Mode Support ===
DRY_RUN=false
for arg in "$@"; do
  [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

run() {
  if $DRY_RUN; then
    echo "[DRY RUN] $*"
  else
    eval "$@"
  fi
}

# === Visual Header ===
if command -v figlet &>/dev/null; then
  echo -e "${GREEN}"
  figlet -f slant "Package Install"
  echo -e "${NC}"
else
  echo -e "${GREEN}== Package Install ==${NC}"
fi

# === File Setup ===
pacman_file="pacman_packages.txt"
yay_file="yay_packages.txt"

if [[ ! -f "$pacman_file" ]]; then
  error "Missing file: $pacman_file"
  exit 1
fi

if [[ ! -f "$yay_file" ]]; then
  error "Missing file: $yay_file"
  exit 1
fi

pacman_packages=($(<"$pacman_file"))
yay_packages=($(<"$yay_file"))

# === Yay Bootstrap (if missing) ===
if ! command -v yay &>/dev/null; then
  info "yay not found. Installing yay from AUR..."
  run "sudo pacman -S --needed --noconfirm base-devel git"
  workdir=$(mktemp -d)
  run "git clone https://aur.archlinux.org/yay.git $workdir/yay"
  run "cd $workdir/yay && makepkg -si --noconfirm"
  run "cd ~ && rm -rf $workdir"
  success "yay installed successfully."
fi

# === Install with pacman ===
install_pacman_packages() {
  info "Installing packages with pacman..."
  for pkg in "${pacman_packages[@]}"; do
    run "sudo pacman -S --needed --noconfirm $pkg"
  done
  success "pacman packages installed."
}

# === Install with yay ===
install_yay_packages() {
  info "Installing packages with yay..."
  for pkg in "${yay_packages[@]}"; do
    run "yay -S --needed --noconfirm $pkg"
  done
  success "yay packages installed."
}

# === Run Installs ===
install_pacman_packages
install_yay_packages

success "All packages installed successfully."
exit 0
