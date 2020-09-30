#!/bin/bash
export HOME=/data/emqttd_prod/emqttd/bin
/data/emqttd_prod/emqttd/bin/emqttd_ctl status |grep 'is running'|wc -l