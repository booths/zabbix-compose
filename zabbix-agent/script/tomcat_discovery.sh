#!/bin/bash
#  liyunwei@unisound.com
#  2018-04-08
#  discovery tomcat web
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
    local tomcat=$1
    check_variable_all tomcat
    local apps
    apps=`find $tomcat/webapps -maxdepth 1 -mindepth 1 -type d`
    for app in `echo $apps`
    do
        ping_jsp $app
        basename $app
    done
}
port_list(){
    local tomcat=$1
    check_variable_all
    local log_file tomcat_pid port
    log_file=$tomcat/lib/catalina.jar
    #log_file=$tomcat/logs/catalina.out
    tomcat_pid=` lsof -n $log_file |awk '$2 ~ /[0-9]+/{print $2}'|head -1`
    if [ "tmp$tomcat_pid" != "tmp" ]
    then
        port=`netstat -ntpl|grep $tomcat_pid|awk '{print $4}'|awk -F: '{print $NF}'`
    fi
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
        curl -s -m 1 http://127.0.0.1:$port/ping.jsp 2>/dev/null|grep -q pong
    else
        curl -s -m 1 http://127.0.0.1:$port/$app/ping.jsp 2>/dev/null|grep -q pong
    fi
    return $?
}
discovery(){
    check_variable_all base_dir
    local apps app tomcat ports  port webapps_dir webapp_dir
    webapps_dir=`find $base_dir -name webapps -type d 2>/dev/null`
    echo '{"data":['
    for webapp_dir in `echo $webapps_dir`
    do
        tomcat=`dirname $webapp_dir`
        ports=`port_list $tomcat`
        apps=`apps_list $tomcat`
        for port in `echo $ports`
        do
            for app in `echo $apps`
            do
                #if true
                if check_app $port $app
                then
                    echo -e "\t{\"{#PORT}\":\"$port\",\"{#APP}\":\"$app\"},"
                fi
            done
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
