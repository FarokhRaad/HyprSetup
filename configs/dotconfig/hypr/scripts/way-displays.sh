#!/bin/sh

sleep 1 # give Hyprland a moment to set its defaults
notify-send "WayDisplays Restarted"
way-displays > "/tmp/way-displays.${XDG_VTNR}.${USER}.log" 2>&1
