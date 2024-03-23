#!/usr/bin/env bash

uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -no-config -theme ~/.config/rofi/powermenu.rasi"

# Options
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
suspend=" Sleep"
logout=" Logout"

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
      systemctl poweroff
      ;;
    $reboot)
			systemctl reboot
      ;;
    $lock)
      if [[ -f /usr/bin/i3lock-fancy ]]; then
        i3lock-fancy
      elif [[ -f /usr/bin/betterlockscreen ]]; then
        betterlockscreen -l
      fi
      ;;
    $suspend)
			mpc -q pause
			amixer set Master mute
			systemctl suspend
      ;;
    $logout)
			if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
				i3-msg exit
			fi
      ;;
esac
