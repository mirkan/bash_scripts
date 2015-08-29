#!/bin/env bash
## Description:

## Author: Robin Björnsvik

path=/sys/class/backlight/acpi_video0
max=100
level=10
current=$(cat ${path}/brightness)
case $1 in
    up)
        if [ ${current} -lt ${max} ]; then
            ((current+=$level))
            echo ${current} | sudo tee ${path}/brightness
        fi
        ;;
    down)
        if [ ${current} -gt 0 ]; then
            ((current-=$level))
            echo ${current} | sudo tee ${path}/brightness
        fi
        ;;
esac
