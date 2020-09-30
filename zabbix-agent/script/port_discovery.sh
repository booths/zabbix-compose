#!/bin/bash


ports=`ss -ntpl -ntl|awk '{print $4}'|grep -Ev '(10050|127.0.0.1)'|awk -F: '{print $NF}'|grep -E '[0-9]'|sort|uniq`
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
