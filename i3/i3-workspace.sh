#!/usr/bin/env bash
#set -x

WORKSPACES=$(
    i3-msg -t get_workspaces \
    | tr ',' '\n' \
    | grep "name" \
    | sed 's/"name":"\(.*\)"/\1/g' \
    | sort -n
)
workspace_name=""
# Fix ordered workspaces and remove gaps between numbers
set_workspaces() {
    # Get current workspaces
    current_workspaces=$(
        i3-msg -t get_workspaces \
        | tr ',' '\n' \
        | grep "name" \
        | sed 's/"name":"\(.*\)"/\1/g' \
        | sort -n
    )
    declare -a ordered_workspaces
    # Get current workspaces with no nr
    workspaces=$(sed -rn 's|^[0-9]:(.*)$|\1|p' <<< "${current_workspaces}")
    i=1
    for w in $workspaces; do
        ordered_workspaces+=("${i}:$w")
        let i=i+1
    done
    WORKSPACES=$(echo ${ordered_workspaces[*]})
}

# Pressed number to navigate/create workspace at
WORKSPACE_NR=${1}

create_workspace() {
    # Check if workspace already exists
    active_workspace=$(grep --word-regexp "${WORKSPACE_NR}" <<< "${WORKSPACES}" )
    if [ $? -eq 0 ]; then
        i3-msg workspace "${active_workspace}"
    else
        # Pick a workspace name with roofi
        workspace_name="$(prompt)"

        # Create workspace
        i3-msg "workspace ${WORKSPACE_NR}:${workspace_name}"
    fi
}
move_container_to_workspace() {
    # Check if workspace already exists
    active_workspace=$(grep --word-regexp "${WORKSPACE_NR}" <<< "${WORKSPACES}" )
    if [ $? -eq 0 ]; then
        i3-msg move container to workspace "${active_workspace}"
    else
        # Pick a workspace name with roofi
        workspace_name="$(prompt)"

        # Create workspace
        i3-msg move container to workspace "${WORKSPACE_NR}:${workspace_name}"
    fi
}
# Exec bin in case "workspace_name" matches witch executable file in $PATH
exec_workspace_name() {
    if which $workspace_name; then
        nohup $workspace_name > /dev/null 2>&1&
    fi
}

prompt() {
   # List most used apps from rofis runcache
   most_used=$(grep -m1 "rofi-[0-9].runcache" <<< "$(ls $HOME/.cache/rofi-*)")
   cat $most_used | sed -rn 's|[0-9]+ (.*)|\1|p' | rofi -dmenu -p "Workspace:"
}

# Make sure parameter exists before attempting to run
! [[ $1 ]] && exit
if [ $2 = 'move' ]; then
    move_container_to_workspace
else
    create_workspace
    exec_workspace_name
fi
exit
