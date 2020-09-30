#!/bin/bash

source /etc/profile

# open files 
opened_files=`cat /proc/sys/fs/file-nr | awk '{print $1}'`

echo "${opened_files}"
