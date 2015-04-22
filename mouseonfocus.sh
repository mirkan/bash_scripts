#!/usr/bin/env bash
APPLICATION="Firefox"

ID=$(xdpyinfo | grep focus | cut -f4 -d " ")
RUN=$(xprop -id $ID | grep WM_CLASS | cut -f4 -d "\"")

#sleep 1s
if [ $RUN == $APPLICATION ]; then
		synclient touchpadoff=0
else
		synclient touchpadoff=1
fi
