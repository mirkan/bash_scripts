#!/bin/bash

#-------------------------------------------------------------------------------
# Author: Jack Söderblom
# Description: Uses rofi as an power settings menu
#
# If script is large make -h option
# Use curly brackets arround variables
# ------------------------------------------------------------------------------

# Get user that started the visual environment
user=$(w -sh | grep tty$(fgconsole 2>/dev/null) | awk '{ print $1 }')

# If used from cmd directly set user var correctly
if [ -z ${user} ]
then
    user=${USER}
fi

# Lock function
lock() {
    i3lock -i /home/${user}/pictures/wallpaper.png
}

# List items
list="1) lock
      2) logout
      3) poweroff
      4) reboot
      5) reboot to UEFI
      6) suspend"

# Menu to print on screen
# sed string removes leading whitespace only
selection=$(
    echo -e "${list}" \
    | sed -e 's/^[[:space:]]*//' \
    | rofi -dmenu -auto-select -fullscreen -p "Power option:"
)

# What to execute
case "${selection}" in
    "1)"*)
        $(lock)
        ;;
    "2)"*)
        $(i3-msg exit)
        ;;
    "3)"*)
        $(lock && systemctl suspend)
        ;;
    "4)"*)
        $(systemctl reboot)
        ;;
    "5)"*)
        $(systemctl reboot --firmware-setup)
        ;;
    "6)"*)
        $(systemctl poweroff)
        ;;
    *)
        exit 1
        ;;
esac

exit
