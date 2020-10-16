#!/bin/bash
set -e
set -o pipefail
set -o errtrace

PWD=`cd $(dirname $0);pwd`
export PATH=$PWD:/usr/local/bin:$PATH

queue_name=$1

if [ tmp$queue_name == "tmp" ]
then
    cat <<EOF
    Usage:
          $0 < queue >
EOF
    exit 2
fi
curl  -s -u guest:guest 'http://127.0.0.1:15672/api/queues'  |jq '.[]|[.name,.messages|tostring]|.[0]+"^"+.[1]' |sed 's/\"//g'|awk -F'^' '$1 ~ /^'$queue_name'$/ {print $2}'
