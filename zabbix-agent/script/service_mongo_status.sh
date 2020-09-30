#! /bin/bash
#---------------------------------------------------------------------------|
#  @Program   : Check mongo usage Status is OK                              |
#  @Author    : vien.lee                                                    |
#  @Create on : 2018/04/11 17:19                                            |
#---------------------------------------------------------------------------|

MONGO_SHELL="/usr/local/bin/mongo"

mongo_ip=${1:-127.0.0.1}
mongo_port=${2:-27017}
$MONGO_SHELL --host $mongo_ip:$mongo_port test -u monitor -p 'yunzhisheng' --authenticationDatabase=test --eval 'db.monitor.insert({"status": "ok"});db.monitor.remove({"status": "ok"});' > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo 0
else
    echo 1
fi
