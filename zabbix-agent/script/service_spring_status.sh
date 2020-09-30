#!/bin/bash
# liyunwei@unisound.com
# 2018-04-08
# check spring status

set -e
set -o pipefail
set -o errtrace
export port=$1
export app=$2

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

check_response(){
    response=$1
    check_variable_all response
    if grep -q "UP" <<< "$response"
    then
        return 0
    else
        return 1
    fi
}

get_response(){
    local port=$1
    local app=$2
    local response
    check_variable_all port app
    if [ "$app" == "ROOT" ]
    then
        response=`curl -s -m 1 "http://127.0.0.1:$port/actuator/health"`
    else
        response=`curl -s -m 1 "http://127.0.0.1:$port/$app/actuator/health"`
    fi
    echo "$response"
}
check(){
    local port=$1
    local app=$2
    local response
    check_variable_all port app 2>/dev/null|| (usage;exit 2)
    response=`get_response $port $app`
    if check_response "tmp$response"
    then
        echo 0
    else
        echo 1
    fi
}
usage(){
    cat <<EOF
Usage:
     $0 <port> <app>
     port: spring service port
     app: service app
EOF
}
check $port $app
