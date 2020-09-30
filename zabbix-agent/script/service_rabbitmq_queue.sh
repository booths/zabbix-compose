#!/bin/bash

set -e
set -o pipefail
set -o errtrace


export PATH=/usr/local/bin:$PATH

queue_name=$1

if [ tmp$queue_name == "tmp" ]
then
    cat <<EOF
    Usage:
          $0 < queue >
EOF
    exit 2
fi

rabbitmqadmin   list queues |awk '$2 ~ /^'$queue_name'$/ {print $4}'
