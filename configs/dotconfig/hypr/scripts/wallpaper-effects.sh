#!/bin/bash
# __        ______    _____  __  __           _       
# \ \      / /  _ \  | ____|/ _|/ _| ___  ___| |_ ___ 
#  \ \ /\ / /| |_) | |  _| | |_| |_ / _ \/ __| __/ __|
#   \ V  V / |  __/  | |___|  _|  _|  __/ (__| |_\__ \
#    \_/\_/  |_|     |_____|_| |_|  \___|\___|\__|___/
#                                                    

# Get current wallpaper
cache_file="$HOME/.config/HyprSetup/cache/current_wallpaper"

# Open rofi to select the Hyprshade filter for toggle
options="$(ls ~/.config/hypr/effects/wallpaper/)\noff"

# Open rofi
choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/.config/rofi/config-themes.rasi -i -no-show-icons -l 5 -width 30 -p "Hyprshade") 
if [ ! -z $choice ] ;then
    echo "$choice" > ~/.config/HyprSetup/settings/wallpaper-effect.sh
    dunstify "Changing Wallpaper Effect to " "$choice"
    waypaper --wallpaper $(cat $cache_file)
fi