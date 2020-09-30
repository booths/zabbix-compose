#!/bin/bash

set -e
set -o pipefail
set -o errtrace


export PATH=/usr/local/bin:$PATH

redis_cli=`which redis-cli`
redis_port=$1
need=$2


maxmemory(){
    local port=$1
    echo config get maxmemory |$redis_cli -p $port|tail -1
}

used_memory(){
    local port=$1
    echo info memory |$redis_cli -p $port|grep used_memory: |awk -F: '{print $NF}'
}

usage(){
    cat <<EOF
$0 <port> <max|used>
  port: the port of  redis service

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
    check_variable_all  redis_cli redis_port need || (usage ;exit 2)
	case $need in
		max)
			maxmemory $redis_port ;;
		used)
			used_memory $redis_port ;;
		*)
            usage
			exit 1
			;;
	esac
}

start
