#!/bin/bash
#  liyunwei@unisound.com
#  2018-04-08
#  discovery spring web
set -C
set -e
set -o pipefail
set -o errtrace


base_dir="/data /opt"


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


apps_list(){
    find $base_dir  -maxdepth 3 -mindepth 2 -name '*.properties'|xargs egrep '^[^#].*context-path' | awk -F[:=] '{print $NF}'
    find $base_dir  -maxdepth 3 -mindepth 2 -name '*.yml'|xargs egrep '^[^#].*context-path' | awk -F: '{print $NF}'
}
port_list(){
    port=`netstat -ntpl|grep java|awk '{print $4}'|awk -F: '{print $NF}'`
    echo $port
}
ping_jsp(){
    local app_dir=$1
    check_variable_all app_dir
    ping_path=$app_dir/ping.jsp
    test -f $ping_path || echo -n "pong" > $ping_path
}
check_app(){
    local port=$1
    local app=$2
    check_variable_all port app
    if [ "$app" == "ROOT" ]
    then
        curl -s -m 1 http://127.0.0.1:$port/actuator/health 2>/dev/null|grep -q UP
    else
        curl -s -m 1 http://127.0.0.1:$port/$app/actuator/health 2>/dev/null|grep -q UP
    fi
    return $?
}
discovery(){
    check_variable_all base_dir
    local apps app ports  port
    echo '{"data":['
        ports=`port_list`
        apps=`apps_list`
        apps=${apps:-ROOT}
        for port in `echo $ports`
        do
            for app in `echo $apps`
            do
                #if true
                if check_app $port $app
                then
                    echo -e "\t{\"{#SPRING_PORT}\":\"$port\",\"{#SPRING_APP}\":\"$app\"},"
                fi
            done
        done
    echo ']}'
}
format(){
    data=$1
    check_variable_all data
    local line_num fix_num
    line_num=`echo "$data" |wc -l`
    let fix_num=$line_num-1
    echo "$data" |awk '{if(NR ~ '$fix_num'){txt=$1;sub(/,$/,"",txt);print  "\t" txt}else{print $0}}'
}
#discovery
format "`discovery`"
