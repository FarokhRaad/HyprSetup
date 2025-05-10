#!/bin/bash

# === Color and Messaging Setup ===
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }

# === Dry Run Support ===
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

# === Root Check ===
if [ "$EUID" -ne 0 ]; then
  error "Please run this script as root (use sudo)."
  exit 1
fi

# === Banner ===
if command -v figlet &>/dev/null; then
  echo -e "${GREEN}"
  figlet -f slant "SDDM Setup"
  echo -e "${NC}"
else
  echo -e "${GREEN}== SDDM Setup ==${NC}"
fi

# === Install and Enable SDDM ===
info "Updating system packages..."
run "pacman -Syu --noconfirm"

info "Installing SDDM..."
run "pacman -S --noconfirm sddm"

if ! command -v sddm &>/dev/null; then
  error "SDDM installation failed."
  exit 1
fi
success "SDDM installed successfully."

info "Enabling SDDM to start at boot..."
run "systemctl enable sddm"

# === Configuration File ===
CONFIG_FILE="/etc/sddm.conf"
USER_CONFIG_FILE="./sddm.conf"

if [ -f "$USER_CONFIG_FILE" ]; then
  info "Copying user-provided SDDM configuration file..."
  run "cp \"$USER_CONFIG_FILE\" \"$CONFIG_FILE\""
  success "Custom SDDM config installed."
else
  if [ ! -f "$CONFIG_FILE" ]; then
    info "Creating default SDDM configuration..."
    run "cat <<EOL > \"$CONFIG_FILE\"
[Theme]
theme=elarun

[Users]
# autoLogin=username

[Wayland]
EnableWayland=false
EOL"
    success "Default config created at $CONFIG_FILE"
  else
    warn "SDDM config already exists. Skipping creation."
  fi
fi

# === Theme Installation ===
SEQUOIA_THEME_DIR="/usr/share/sddm/themes/sequoia"
USER_SEQUOIA_THEME="./sequoia"

if [ -d "$USER_SEQUOIA_THEME" ]; then
  info "Installing Sequoia theme..."
  run "cp -r \"$USER_SEQUOIA_THEME\" \"$SEQUOIA_THEME_DIR\""
  run "sed -i 's/^theme=.*/theme=sequoia/' \"$CONFIG_FILE\""
  success "Sequoia theme installed and set as default."
else
  warn "Sequoia theme not found at $USER_SEQUOIA_THEME. Skipping."
fi

# === Start SDDM ===
info "Starting SDDM..."
run "systemctl start sddm"

success "SDDM setup complete."
exit 0
