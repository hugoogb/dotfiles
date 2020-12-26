#!/bin/bash

# Screens
hdmi=`xrandr --listmonitors | awk '{print $4}' | sed '/^ *$/d' | grep "HDMI-1"`

if [ "$hdmi" = "HDMI-1" ]; then
  xrandr --output eDP-1 --primary --mode 1920x1080 --pos 666x1440 --rotate normal --output HDMI-1 --mode 3440x1440 --pos 0x0 --rotate normal --output DP-1 --off &
else
  xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off &
fi
