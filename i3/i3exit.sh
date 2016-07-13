#!/bin/bash

user=$(w -sh | grep tty$(fgconsole) | awk '{ print $1 }')

lock() {
    i3lock -i /home/$user/Pictures/wallpaper.png
}

case "$1" in
    lock)
        lock
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        lock
        systemctl suspend

        # Workaround for zenbook suspend freeze
        # Needs systemd .pth and .service file which allows -
        # user to write to system file
        #echo mem > /sys/power/state
        ;;
    reboot)
        systemctl reboot
        ;;
    UEFI)
        systemctl reboot --firmware-setup
        ;;
    poweroff)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|reboot|UEFI|poweroff}"
        exit 2
esac

exit 0
