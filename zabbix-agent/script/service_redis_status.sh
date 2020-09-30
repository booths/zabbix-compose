#!/bin/bash

set -e
set -o pipefail
set -o errtrace


export PATH=/usr/local/bin:$PATH

redis_cli=`which redis-cli`

action=$1
redis_ip=${2:-127.0.0.1}
redis_port=${3:-6379}


check_set(){
    local redis_ip=$1
    local redis_port=$2
    check_variable_all  redis_ip redis_port
    rs=`echo "set zabbix_check zabbix_check"|$redis_cli -h $redis_ip -p $redis_port 2>/dev/null|tail -1`
    if [ "tmp$rs" == "tmpOK" ]
    then
        echo 0
    else
        echo 1
    fi
}
check_get(){
    local redis_ip=$1
    local redis_port=$2
    check_variable_all  redis_ip redis_port
    rs=`echo "get zabbix_check "|$redis_cli -h $redis_ip -p $redis_port 2>/dev/null|tail -1`
    if [ "tmp$rs" == "tmpzabbix_check" ]
    then
        echo 0
    else
        echo 1
    fi
}


usage(){
    cat <<EOF
$0 <get|set> [ip] [port]
  port: the port of  redis service
  ip  : redis ip

EOF
}
check_variable (){
    local varable_name
    varable_name=$1
    [[ `eval "echo tmp\\$$varable_name"` == "tmp" ]] && return 1 || return 0
    }

check_variable_all (){
    local variable
    for variable in $*
    do
       if  ! check_variable $variable
       then
           echo variable: \'$variable\' is not set >&2
           return 1
       fi
    done
    }

start(){
    check_variable_all action || (usage ;exit 2)
	case $action in
		set)
			check_set  $redis_ip  $redis_port ;;
		get)
			check_get  $redis_ip  $redis_port ;;
		*)
            usage
			exit 1
			;;
	esac
}

start
