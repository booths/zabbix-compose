#!/bin/bash
if [[ $1 == 'MusicList' ]]
then
    curl -s "http://127.0.0.1:19999/music/getHotMusicList" -X POST\
        -H "Content-Type: application/json" \
        -d "
       {
            'businessType':'music',
            'command':'getHotMusicList',
            'data': {
            'rankType':'17',
            'source':'100',
            'appkey':'rb35fqpoz33hyu56zh4kklgqqwdicqcmbxzwe4qc',
            'limit':'1',
            'udid':'yunzhisheng-biz-monitor'
        },
             'tcl': {
                'clientId':'359583075053951',
                'subSysId':9,
                'token':''
        },
            'version':'1.0.0'
    }" >  /tmp/getHotMusicList.txt
    cat /tmp/getHotMusicList.txt |grep "操作成功" |wc -l
elif [[ $1 == 'UserDevices' ]]
then
    curl -s "http://127.0.0.1:19999/getUserDevices" -X POST\
        -H "Content-Type: application/json" \
         -d "
        {'businessType':'deviceSetting','command':'getUserDevices','data':{'udid':'yunzhisheng-biz-monitor'},'tcl':{'clientId':'82858989','subSysId':9,'token':''},'version':'2.0.0'}" >  /tmp/getUserDevices.txt
    cat /tmp/getUserDevices.txt |grep "请求成功" |wc -l
fi