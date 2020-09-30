#!/bin/bash
if [[ $2 == rrqm ]]
then
    iostat -dxkt |grep "\b$Device\b"|grep $1|awk '{print $2}'
elif [[ $2 == wrqm  ]]
then
    iostat -dxkt |grep "\b$Device\b"|grep $1|awk '{print $3}'
elif [[ $2 == rps  ]]
then
    iostat -dxkt |grep "\b$Device\b"|grep $1|awk '{print $4}'
elif [[ $2 == wps  ]]
then
    iostat -dxkt |grep "\b$Device\b" |grep $1|awk '{print $5}'
elif [[ $2 == rKBps  ]]
then
    iostat -dxkt |grep "\b$Device\b" |grep $1|awk '{print $6}'
elif [[ $2 == wKBps  ]]
then
    iostat -dxkt |grep "\b$Device\b" |grep $1|awk '{print $7}'
elif [[ $2 == avgrq-sz  ]]
then
    iostat -dxkt |grep "\b$Device\b" |grep $1|awk '{print $8}'
elif [[ $2 == avgqu-sz  ]]
then
    iostat -dxkt |grep "\b$Device\b" |grep $1|awk '{print $9}'
elif [[ $2 == await  ]]
then
    iostat -dxkt |grep "\b$Device\b" |grep $1|awk '{print $10}'
elif [[ $2 == svctm  ]]
then
    iostat -dxkt |grep "\b$Device\b" |grep $1|awk '{print $11}'
elif [[ $2 == util  ]]
then
    iostat -dxkt |grep "\b$Device\b" |grep $1|awk '{print $12}'
fi