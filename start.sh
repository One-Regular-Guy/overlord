#!/usr/bin/env bash
# put this in ~/.config/hypr/
# initialize wallpaper daemon
swww init &
# set wallpaper
swww img ~/path/to/file.png &

# networking
nm-applet --indicator &

waybar &
dunst
# remenber to add this in the end of hyprland.conf
# exec-once=bash ~/.config/hypr/start.sh
