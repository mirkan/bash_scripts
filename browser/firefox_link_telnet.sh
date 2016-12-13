#!/bin/env bash
## Description:

## Author: Robin Björnsvik

URL=`echo "$1" | sed 's#telnet://##'`

HOST=`echo "$URL" | awk -F':' '{print $1}'`
PORT=`echo "$URL" | awk -F':' '{print $2}'`
urxvt -title $HOST -e telnet $HOST $PORT &
