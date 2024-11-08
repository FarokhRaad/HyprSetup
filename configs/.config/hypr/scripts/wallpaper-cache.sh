#!/bin/bash
generated_versions="$HOME/.config/HyprSetup/cache/wallpaper-generated"
rm $generated_versions/*
echo ":: Wallpaper cache cleared"
notify-send "Wallpaper cache cleared"