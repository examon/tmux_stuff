#!/bin/bash
#SESSION=$1
MACHINES=$1
PASSWORD=$2

SSH="./ssh_login.sh"

if [ "$#" -ne 2 ]; then
    echo "$0 hostnames_file password"
    exit 1
fi

# in case there is already tmux session named ${SESSION}
#tmux kill-session -t ${SESSION}

#xfce4-terminal -e "tmux new -s ${SESSION}"

# pade_id=1 belongs to empty bash window
pane_id=2

while read -r line; do
    echo ${line}
    hostnames=$(echo ${line} | xargs)

    ISF=' ' read -ra hostnames_array <<< "${line}"
    hostnames_length=${#hostnames_array[@]}

    if [ $hostnames_length -eq 1 ]; then
        echo "1"
        tmux new-window -n ${pane_id}
        tmux send-keys -t ${pane_id} "${SSH} root ${hostnames_array[0]} ${PASSWORD}" ENTER
    elif [ $hostnames_length -eq 2 ]; then
        echo "2"
        tmux new-window -n ${pane_id}
        tmux send-keys -t ${pane_id} "sshpass -p ${PASSWORD} ssh -A -t root@${hostnames_array[0]} /root/vmman/vm_ssh.sh ${hostnames_array[1]}" ENTER
    fi
    pane_id=`expr ${pane_id} + 1`
done < ${MACHINES}
