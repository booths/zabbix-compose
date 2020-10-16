#!/bin/bash

PWD=`cd $(dirname $0);pwd`
export PATH=$PWD:/usr/local/bin:$PATH
queues=`curl -s -u guest:guest 'http://127.0.0.1:15672/api/queues'  |jq '.[]|.name'|sed 's/\"//g'`
num=`echo $queues|wc -w`
echo '{"data":['
for q in  $queues
do
    let a+=1
    if [ $num == $a ]
    then
        echo -e "\t{\"{#QUEUE_NAME}\":\"$q\"}"
    else
        echo -e "\t{\"{#QUEUE_NAME}\":\"$q\"},"
    fi
done
echo ']}'
