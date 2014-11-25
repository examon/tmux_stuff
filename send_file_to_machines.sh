#!/bin/bash

HOSTNAMES=$1
PASSWORD=$2
SOURCE=$3
DESTINATION=$4

USER=root

if [ "$#" -ne 4 ]; then
    echo "$0 hostnames_file password source destination"
    exit 1
fi

for target in $(cat ${HOSTNAMES} | xargs); do
    expect -c "
    spawn /usr/bin/scp -r ${SOURCE} ${USER}@${target}:${DESTINATION}
    expect {
    "*password:*" { send ${PASSWORD}\r;interact }
    }
    exit
    "
done
