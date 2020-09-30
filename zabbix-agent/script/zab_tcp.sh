#!/bin/bash


# $1 一般可以用 ALl , SYN-RECV, ESTAB , FIN-WAIT-1 ,FIN-WAIT-2 ,TIME-WAIT ,CLOSE-WAIT, CLOSING
# shou55在实际中认为比较重要的有  ALl , SYN-RECV , ESTAB , CLOSE-WAIT . 前面几个不用说, 最后一个是因为shou55实际中有遇到有服务的很多tcp处于CLOSE-WAIT导致fd被耗尽而拒绝服务

if [ $# -ne 1 ]
then
	echo 'par must be only one'
	exit 1
fi

if [ "$1" = "ALL" ]
then
	ss -an | wc -l
else
	ss -an  | grep "$1" | wc -l	
fi

