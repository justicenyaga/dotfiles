#!/bin/sh

BAR_HEIGHT=52  # polybar height
YAD_WIDTH=222  # 222 is minimum possible value
YAD_HEIGHT=193 # 193 is minimum possible value
ALLOWANCE=25   # Minor Allowance

if [ "$(xdotool getwindowfocus getwindowname)" = "yad-calendar" ]; then
    exit 0
fi

eval "$(xdotool getdisplaygeometry --shell)"

pos_x=$(((WIDTH / 2) - (YAD_WIDTH / 2) - ALLOWANCE))
pos_y=$((BAR_HEIGHT + BORDER_SIZE))

yad --calendar --undecorated --fixed --close-on-unfocus --no-buttons \
    --width="$YAD_WIDTH" --height="$YAD_HEIGHT" --posx="$pos_x" --posy="$pos_y" \
    --title="yad-calendar" --borders=0 >/dev/null &
# esac
