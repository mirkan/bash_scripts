#!/usr/bin/env bash
set -x
WORKSPACES=$(
    i3-msg -t get_workspaces \
    | tr ',' '\n' \
    | grep "name" \
    | sed 's/"name":"\(.*\)"/\1/g' \
    | sort -n
)

# Pressed number to navigate/create workspace at
WORKSPACE_NR=${1}

# Navigate/Create or Move container to
#ACTION=${2}

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


set_key_color() {
    KEY_COLOR="#268BD2"
    echo "<span color='${KEY_COLOR}'>${1}</span>: ${2}&#09;"
}

#MENU+="$(set_key_color "Enter" "Enter")"
#MENU+="$(set_key_color "Alt+r" "Rename")"
#MENU+="$(set_key_color "Alt+m" "Move container")"

prompt() {
    echo "" | rofi -dmenu -p "Workspace:" -mesg "${MENU}" \
        -kb-custom-1 "Alt+r" \
        -kb-custom-2 "Alt+m" \
        -kb-custom-3 "Alt+o"
}

# Make sure parameter exists before attempting to run
! [[ $1 ]] && exit

if [ $2 = 'move' ]; then
    move_container_to_workspace
else
    create_workspace
fi

exit
