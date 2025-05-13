#!/bin/bash
#  ___           _        _ _   _   _           _       _             
# |_ _|_ __  ___| |_ __ _| | | | | | |_ __   __| | __ _| |_ ___  ___  
#  | || '_ \/ __| __/ _` | | | | | | '_ \ / _` |/ _` | __/ _ \/ __| 
#  | || | | \__ \ || (_| | | | | |_| | |_) | (_| | (_| | ||  __/\__ \ 
# |___|_| |_|___/\__\__,_|_|_|  \___/| .__/ \__,_|\__,_|\__\___||___/ 
#                                    |_|                              

clear
aur_helper="$(cat ~/.config/HyprSetup/settings/aur.sh)"
figlet -f smslant "Updates"
echo

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

if gum confirm "DO YOU WANT TO START THE UPDATE NOW?" ; then
    echo
    echo ":: Update started."
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Update canceled."
    exit
fi

# ------------------------------------------------------
# Run AUR/System Updates
# ------------------------------------------------------

$aur_helper

# ------------------------------------------------------
# Final Notification
# ------------------------------------------------------

notify-send "Update complete"
echo
echo ":: Update complete"
echo
echo "Press [ENTER] to close."
read
