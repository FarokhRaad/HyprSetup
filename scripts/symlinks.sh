#!/bin/bash

# Define directories and files to symlink
CONFIG_DIRS=(
  "gtk-3.0"
  "gtk-4.0"
  "qt5ct"
  "qt6ct"
)
CONFIG_FILES=(
  ".gtkrc-2.0"
)

# Base paths
USER_CONFIG_DIR="$HOME/.config"
ROOT_CONFIG_DIR="/root/.config"

# Create /root/.config if it doesn't exist
if [ ! -d "$ROOT_CONFIG_DIR" ]; then
  echo "Creating $ROOT_CONFIG_DIR directory"
  sudo mkdir -p "$ROOT_CONFIG_DIR"
fi

# Create symlinks for directories
for dir in "${CONFIG_DIRS[@]}"; do
  SRC="$USER_CONFIG_DIR/$dir"
  DEST="$ROOT_CONFIG_DIR/$dir"
  if [ -e "$SRC" ]; then
    if [ ! -L "$DEST" ]; then
      echo "Creating symlink for $SRC -> $DEST"
      sudo ln -s "$SRC" "$DEST"
    else
      echo "Symlink for $SRC already exists"
    fi
  else
    echo "Source directory $SRC does not exist, skipping."
  fi
done

# Create symlinks for files
for file in "${CONFIG_FILES[@]}"; do
  SRC="$USER_CONFIG_DIR/$file"
  DEST="$ROOT_CONFIG_DIR/$file"
  if [ -e "$SRC" ]; then
    if [ ! -L "$DEST" ]; then
      echo "Creating symlink for $SRC -> $DEST"
      sudo ln -s "$SRC" "$DEST"
    else
      echo "Symlink for $SRC already exists"
    fi
  else
    echo "Source file $SRC does not exist, skipping."
  fi
done

echo "Symlink creation complete."
