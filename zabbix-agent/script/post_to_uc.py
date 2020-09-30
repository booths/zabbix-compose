# -*- coding: utf-8 -*-

import sys
import time
import random
import requests
import hashlib
import sys
import json
reload(sys)
sys.setdefaultencoding('utf8')


# Server = "http://10.30.10.32:10080"
# Server = "http://117.121.49.9:9001"
Server = "http://127.0.0.1:8080"

SubsystemId = 3
Account = "sdktestuser"
Password = "e10adc3949ba59abbe56e057f20f883e"
ClientId = 'access_token_test_by_unisound_testTeam_'

def get_signature(param_list):
    s = ""
    param_list = sorted(param_list)
    for p in param_list:
        s += p
    signature = hashlib.sha1(s.encode('utf-8')).hexdigest().upper().strip()
    return signature

def get_timestamp():
    return int(time.time())

def send_post(url, params_with_sign):
    return requests.post(url, data=params_with_sign).text

def getAccessToken():
    timestamp = get_timestamp();
    clientId = ClientId + str(timestamp)
    login_path = Server + "/rest/v2/user/login";
    param_dict = {'subsystemId': str(SubsystemId),
                   'account' : Account,
                   'password' : Password,
                   'clientId' : clientId,
                   'timestamp' : str(timestamp)
        }
    param_dict['signature'] = get_signature(param_dict.values())

    flush_token_ret = send_post(login_path, param_dict)

    try:
        flush_token = flush_token_ret.split('"flushToken":"')[1].split('"')[0]
        param_dict = {'subsystemId': '3',
                   'clientId' : clientId,
                   'flushToken': flush_token,
                   'timestamp' : str(get_timestamp())
        }
        accToken_path = Server + "/rest/v2/token/get_access_token"
        param_dict['signature'] = get_signature(param_dict.values())
        r = send_post(accToken_path, param_dict)
        accessToken = r.split('"accessToken":"')[1].split('"')[0]
        #print r
        return (clientId, accessToken)
    except Exception as e:
        #print r
        #print e
        result = 0
        print result
        return (None, None)


def validateAccessToken():
    validate_token_url = Server + "/rest/v2/token/validate_access_token"
    clientId, accessToken = getAccessToken()
    param_dict = { 'subsystemId': str(SubsystemId),
                   'clientId' : clientId,
                   'accessToken': accessToken,
                   'timestamp' : str(get_timestamp())
        }
    param_dict['signature'] = get_signature(param_dict.values())
    r = send_post(validate_token_url, param_dict)
    rjson = json.loads(r,encoding="utf-8")
    message = rjson["message"]
    if message == "操作成功":
        result = 1
    else:
        result = 0
    print result
    return r

if __name__ == '__main__':
    validateAccessToken()
