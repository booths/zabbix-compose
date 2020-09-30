#!/bin/bash

source /etc/profile

# curl http://172.20.72.96:18083/api/stats
passport_emqtt=`curl -s -X GET --connect-timeout 60 -u admin:public http://172.20.72.96:18083/api/stats | grep -Eo '"clients/count":[0-9]*'|awk -F':' '{print $2}'`

echo "${passport_emqtt}"
