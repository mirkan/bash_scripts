#!/bin/env bash
## Description:

## Author: Robin Björnsvik
# Turnoff all running vagrant machines in one command
#set -xe
#vagrant_list=$(vagrant global-status)
declare -A machines

# Find ID of every running vagrant machine
vms=()
while read -r ; do
    name=$(echo $REPLY | sed -rn 's|^.*/(.*)$|\1|p')
    id=$(echo $REPLY | cut -d ' ' -f 1)
    machines[$name]=$id
done < <(vagrant global-status | grep running)

## Loop and shutdown
for vm in "${!machines[@]}"; do
    echo "$vm is now shutting down..."
    vagrant halt -f ${machines[$vm]}
done;
