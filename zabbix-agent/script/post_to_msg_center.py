# coding:utf-8

'''
monitor msg_center_register api

'''

import sys
import time
import random
import requests
import hashlib
import urllib2
import sys
import json
reload(sys)
sys.setdefaultencoding('utf8')


# Server = "http://10.30.11.16:8088"
# Appkey = '4vv55dzjavtvm7kc4pcskzpze7p3jnkwpeb6bjaw'
# Appsecret = 'ba8473a5343fb816c728751d841807d6'

Server = "http://127.0.0.1"
Appkey = "4y4twwj7q665p6g6322nwt6kyvn3b3a6hp3evpqz"
Appsecret = "caa5bf2b38ff69a039a399be85d560df"


def get_signature(param_list):
    s = ""
    param_list = sorted(param_list)
    for p in param_list:
        s += p
    signature = hashlib.sha1(s.encode('utf-8')).hexdigest().upper().strip()
    return signature

def get_timestamp(hum=False):
    if hum:
        return time.strftime('%Y_%m_%d_%H_%M_%S',time.localtime(time.time()))
    return int(time.time())

def send_post(url, params_with_sign):
    return requests.post(url, data=params_with_sign).text

def register_msg_center():
    register_url = Server + "/rest/v1/client/register"

    timestamp = str(get_timestamp())
    # timestamp = '1523953221'
    udid = "msg_center_monitor_001"
    # udid = "msg_center_monitor_by_devops_11"
    tcDeviceId = ""

    dataVersion = 'v1'
    appOsType = '1'    # 0:others 1:miui 2:huawei 3:iOS 4:chip
    subsystemId = '5'  # 4:IoT 6:musicbox 7:KAR 9:Pandora
    extras = 'extras_' + timestamp
    # extras = 'additional_params_1523953221590'

    param_dict = {
        'appKey' : Appkey,
        'appOsType' : appOsType,
        'subsystemId': subsystemId,
        'udid' : udid,
        'tcDeviceId' : tcDeviceId,
        'dataVersion' : dataVersion,
        'extras' : extras,
        'timestamp' : timestamp
    }
    # signature with urlencode
    sign_params = []
    for x in param_dict.values() + [Appsecret]:
        sign_params.append(urllib2.quote(x))
    param_dict['signature'] = get_signature(sign_params)

    r = send_post(register_url, param_dict)
    resultjson = json.loads(r,"uft-8")
    # print r
    result = 0
    if resultjson["message"] == "client已注册":
        result = 1
    print result
    return r


if __name__ == '__main__':
    register_msg_center()
