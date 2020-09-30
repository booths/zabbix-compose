#!/bin/bash

export PATH=/usr/local/bin:$PATH
queues=`rabbitmqadmin   list queues |awk '$4 ~ /[0-9]+/ {print $2}'`
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
