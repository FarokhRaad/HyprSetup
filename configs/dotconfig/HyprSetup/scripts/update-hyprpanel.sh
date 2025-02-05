#!/bin/bash
# _   _           _       _         _   _                                         _ 
#| | | |_ __   __| | __ _| |_ ___  | | | |_   _ _ __  _ __ _ __   __ _ _ __   ___| |
#| | | | '_ \ / _` |/ _` | __/ _ \ | |_| | | | | '_ \| '__| '_ \ / _` | '_ \ / _ \ |
#| |_| | |_) | (_| | (_| | ||  __/ |  _  | |_| | |_) | |  | |_) | (_| | | | |  __/ |
# \___/| .__/ \__,_|\__,_|\__\___| |_| |_|\__, | .__/|_|  | .__/ \__,_|_| |_|\___|_|
#      |_|                                |___/|_|        |_|                       

sleep 1
clear
aur_helper="$(cat ~/.config/HyprSetup/settings/aur.sh)"
figlet -f smslant "Update Hyprpanel"
echo

# Define variables
TEMP_REPO_PATH="$HOME/git/HyprPanel"  # Temporary path for git operations
TARGET_PATH="$HOME/.config/ags"      # Target path to copy files
REPO_URL="https://github.com/Jas-SinghFSU/HyprPanel.git"  # GitHub repository URL
BRANCH="master"  # Replace with the correct branch name, e.g., main or master

# Step 1: Ensure the BASE_GIT_PATH exists
if [ ! -d "$BASE_GIT_PATH" ]; then
    echo "Creating $BASE_GIT_PATH directory..."
    mkdir -p "$BASE_GIT_PATH"
fi

# Step 2: Clone or pull the repository to the temp directory
if [ ! -d "$TEMP_REPO_PATH/.git" ]; then
    echo "Cloning repository into $TEMP_REPO_PATH..."
    git clone "$REPO_URL" "$TEMP_REPO_PATH"
else
    echo "Pulling the latest changes into $TEMP_REPO_PATH..."
    cd "$TEMP_REPO_PATH" || { echo "Failed to navigate to repository path. Exiting."; exit 1; }
    git fetch origin "$BRANCH"
    git reset --hard "origin/$BRANCH"
fi

# Step 3: Copy only the contents of TEMP_REPO_PATH (not the folder itself) to TARGET_PATH
echo "Updating configuration files in $TARGET_PATH..."
rsync -av --delete "$TEMP_REPO_PATH/" "$TARGET_PATH/"

# Notify of completion
echo 
echo ":: Hyperpanel update complete"
echo 
echo 

echo "Press [ENTER] to close."
read