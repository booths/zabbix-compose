#!/bin/bash
set -e

checkVariable (){
    local varable_name=$1
    [[ `eval "echo tmp\\$$varable_name"` == "tmp" ]] && return 1 || return 0
}

checkVariableAll (){
    for variable in $*
    do
        if  ! checkVariable $variable
        then
            echo variable: \'$variable\' is not set >&2
            return 1
        fi
    done
}

get_line_number(){
    local file=$1
    check_file_exist $file
    wc -l $file | awk '{print $1}'
}

check_file_exist(){
    local file=$1
    checkVariable file
    test -f $file  && return 0 || return 1
}

get_before_line(){
    local file=$1
    local alert_flag="$2"
    checkVariableAll file
    local line_file line
    line_file=`get_tmp_file $file "$alert_flag"`
    if check_file_exist $line_file
    then
        line=`cat $line_file`
    else
        line=0
    fi
    echo $line
}

get_tmp_file(){
    local file_base_name file_name
    local file=$1
    local alert_flag="$2"
    file_base_name=`echo $file | tr '/' '.'`
    file_tag_name=`echo "$alert_flag"|md5sum|awk '{print $1}'`
    file_name="/tmp/${file_base_name}.$file_tag_name"
    echo $file_name
}

line_number_save(){
    local file=$1
    local number=$2
    local alert_flag="$3"
    local line_file
    checkVariableAll file number
    line_file=`get_tmp_file $file "$alert_flag"`
    echo $number > $line_file
}

check_file(){
    local log_file=$1
    local alert_flag="$2"
    local line_number=$3
    checkVariableAll log_file alert_flag line_number
    check_file_exist $log_file
    local alert_con=`tail -n $line_number $log_file | grep -- "$alert_flag" `
    if checkVariable alert_con
    then
        echo "$alert_con"
        exit 99
    else
        echo "OK"
        exit 0
    fi

}
check_alert(){
    local log_file="$1"
    local alert_flag="$2"
    local now_line_number before_line_number
    check_file_exist $log_file
    checkVariableAll alert_flag
    before_line_number=`get_before_line $log_file "$alert_flag"`
    now_line_number=`get_line_number $log_file`
    line_number_save $log_file $now_line_number "$alert_flag"
    check_line_number=$((now_line_number - before_line_number))
    if [ $check_line_number -ge 0 ]
    then
        check_file $log_file "$alert_flag" $check_line_number
    else
        check_file $log_file "$alert_flag" $now_line_number
    fi

}

log_file=$1
shift
alert_flag="$*"
alert_flag="${alert_flag//+/\[}"
alert_flag="${alert_flag//-/\]}"
check_alert "$log_file" "$alert_flag"
