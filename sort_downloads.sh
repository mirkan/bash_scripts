#!/bin/env bash

# Description: 
# Using inotify to monitor for new files in
# ~/Downloads and move them to a more useful location.

# Author: Robin Björnsvik

WATCH_DIR="$HOME/Downloads"
TORRENT_DIR='/media/NFS/brix/.torrents/watch/'
regex='.*.torrent$'

inotifywait -m -e close_write --format %f $WATCH_DIR |
	while read file; do
		# Match for torrent-files
		if [[ $file =~ $regex ]];then
			if [ -d $TORRENT_DIR ]; then
				cp "$WATCH_DIR/$file" $TORRENT_DIR
				echo "Match"
			fi
		else
			echo "No match :("
		fi
	done
