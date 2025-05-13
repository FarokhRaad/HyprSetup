#    ___           __
#   / _ \___  ____/ /__
#  / // / _ \/ __/  '_/
# /____/\___/\__/_/\_\
#

#!/bin/bash

dock_config_dir="$HOME/.config/nwg-dock-hyprland"
config="$HOME/.config/gtk-3.0/settings.ini"

killall nwg-dock-hyprland
sleep 0.5

prefer_dark_theme="$(grep 'gtk-application-prefer-dark-theme' "$config" | sed 's/.*\s*=\s*//')"
if [ "$prefer_dark_theme" == "0" ]; then
    ln -sf "$dock_config_dir/style-light.css" "$dock_config_dir/style.css"
else
    ln -sf "$dock_config_dir/style-dark.css" "$dock_config_dir/style.css"
fi

nwg-dock-hyprland -d -hd 0 -i 32 -w 5 -ml 10 -mr 10 -c "rofi -show drun" -lp start
