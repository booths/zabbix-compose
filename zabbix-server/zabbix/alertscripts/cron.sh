#!/bin/sh
set -e 
cd `dirname $0`
touch /juhe_tmp/juhe.txt
chmod 666 /juhe_tmp/juhe.txt
while :;do
    date 
    python ./juhe.py ${ding_talk_url:? error: The \'ding_talk_url\' is not defined}
    : >/juhe_tmp/juhe.txt
    sleep $((60*5))
done
