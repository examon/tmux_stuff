#!/bin/bash
MACHINES=$1
PASSWORD=$2

SSH="./ssh_login.sh"
INSTALL_NODES="install_nodes.sh"
SCP="./scp_send.sh"


if [ "$#" -ne 2 ]; then
    echo "$0 hostnames_file password"
    exit 1
fi

# pade_id=1 belongs to empty bash window
pane_id=2

while read -r line; do
    echo ${line}
    hostnames=$(echo ${line} | xargs)

    ISF=' ' read -ra hostnames_array <<< "${line}"
    hostnames_length=${#hostnames_array[@]}

    if [ $hostnames_length -eq 1 ]; then
        echo "need more arguments in config"
        exit 1
    elif [ $hostnames_length -eq 2 ]; then
        tmux new-window -n ${pane_id}
        tmux send-keys -t ${pane_id} "${SSH} root ${hostnames_array[0]} ${PASSWORD}" ENTER
    fi
    pane_id=`expr ${pane_id} + 1`
done < ${MACHINES}

for i in $(seq 2 ${pane_id}); do
    tmux send-keys -t ${pane_id} "${scp} ${install_nodes} "root@${hostnames_array[0]}" ${password}" enter
done

