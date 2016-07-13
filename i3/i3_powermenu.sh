#!/bin/env bash
## Description:
# Generate power off menu for i3
## Author: Robin Björnsvik

i3-nagbar -m 'Are you leaving' \
	-b Poweroff 'exec sudo poweroff' \
	-b Reboot 'exec sudo reboot' \
	-b Suspend 'exec sudo systemctl suspend' \
	-b 'Logout' 'i3-msg exit' \
	-t warning
