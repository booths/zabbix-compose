#!/bin/bash


ports=`ps -ef|grep -E 'codis-server|redis-server'|grep -v grep|awk -F: '{print $NF}'`
num=`echo $ports|wc -w`
echo '{"data":['
for port in  $ports
do
    let a+=1
    if [ $num == $a ]
    then
        echo -e "\t"{\"{#PORT}\":$port}
    else
        echo -e "\t"{\"{#PORT}\":$port},
    fi
done
echo ']}'
