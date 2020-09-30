#! /bin/bash
#---------------------------------------------------------------------------|
#  @Program   : Check rabbitMQ usage Status is OK                           |
#  @Author    : vien.lee                                                    |
#  @Create on : 2018/04/12 16:19                                            |
#---------------------------------------------------------------------------|

check_return_code() {
    if [[ $1 -ne 0 ]]; then
        echo 1
        exit 1
    fi
}

MQ_ADMIN="/usr/local/bin/rabbitmqadmin"
$MQ_ADMIN declare queue name=monitor durable=true>/dev/null 2>&1
check_return_code $?
$MQ_ADMIN publish routing_key=moniotr payload="just for monitor">/dev/null 2>&1
check_return_code $?
$MQ_ADMIN get queue=monitor requeue=false>/dev/null 2>&1
check_return_code $?
echo 0
exit 0