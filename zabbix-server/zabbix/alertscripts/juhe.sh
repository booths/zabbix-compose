#!/bin/bash

#who=`echo "$1"|sed 's/kar@unisound.com/liwenshan@unisound.com,hewei@unisound.com/g'`
echo "**$who^$2^$3" | tr '\n' ''| sed 's//<\br>/g' >> /juhe_tmp/juhe.txt
