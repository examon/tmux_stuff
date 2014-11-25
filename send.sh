#!/bin/bash

# send command to specified range of panes

#if [ "$#" -ne 1 ]; then
#    echo "$0 session_name"
#    exit 1
#fi

#session=$1
from=1
to=1

while read -r -p "> " line; do
    #read -p "> " line
    #echo $line

    # get out of repl
    if [ "$line" == ":quit" ] || [ "$line" == ":q" ]; then
        exit 0
    fi

    # setup operating interval for tmux panes
    if [[ "$line" == :set* ]] || [[ "$line" == :s* ]]; then
        # format $line (e.g. ":s a   b c" -> ":s a b c")
        panes=$(echo ${line} | xargs)

        # split $line into $panes_array
        IFS=' ' read -ra panes_array <<< "${line}"

        # check input
        array_length=${#panes_array[@]}
        if [ $array_length -ne 3 ]; then
            echo ":s from to"
            continue
        fi

        # set from/to
        from=${panes_array[1]}
        to=${panes_array[2]}
        echo "active tmux panes [${from}..${to}]"
        continue
    fi

    for i in $(seq ${from} ${to}); do
        #tmux send-keys -t ${session}:$i "${line}" ENTER &
        tmux send-keys -t $i "${line}" ENTER &
    done
done
