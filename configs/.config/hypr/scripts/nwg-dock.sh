#!/bin/sh
pkill -f nwg-dock-hyprland
notify-send "Dock Restarted"
nwg-dock-hyprland -d -hd 0  -i 32 -w 5 -ml 10 -mr 10  -c "rofi -show drun" -lp start


