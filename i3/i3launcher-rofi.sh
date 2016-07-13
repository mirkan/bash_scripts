#!/bin/bash

#-------------------------------------------------------------------------------
# Author: Jack Söderblom
# Description: Uses rofi as an application launcher
#
# If script is large make -h option
# Use curly brackets arround variables
# ------------------------------------------------------------------------------

# List items
list="1) firefox
      2) libreoffice
      3) vlc
      4) spotify
      5) transmission
      6) device manager
      7) iso/image mounter
      8) usb creator
      9) htop
      10) virtualbox"

# Menu to print on screen
# sed string removes leading whitespace only
selection=$(
    echo -e "${list}" \
    | sed -e 's/^[[:space:]]*//' \
    | rofi -dmenu -auto-select -fullscreen -p "Launch application:"
)

term="urxvtc -e"

# What to execute
case "${selection}" in
    "1)"*)
        firefox
        ;;
    "2)"*)
        libreoffice
        ;;
    "3)"*)
        vlc
        ;;
    "4)"*)
        spotify
        ;;
    "5)"*)
        transmission-gtk
        ;;
    "6)"*)
        gnome-disks
        ;;
    "7)"*)
        gnome-disk-image-mounter
        ;;
    "8)"*)
        usb-creator-gtk
        ;;
    "9)"*)
        ${term} htop
        ;;
    "10)"*)
        virtualbox
        ;;
    *)
        exit 1
        ;;
esac

exit
