# coding:utf-8



import sys
import time
import random
import requests
import hashlib
import sys
import json
reload(sys)
sys.setdefaultencoding('utf8')

'''

http://wiki.it.yzs.io:8090/pages/viewpage.action?pageId=9775537
'''

Server = "http://127.0.0.1:8080"
# Server = "http://10.30.10.21:8180"

# AppKey = "zfsh3gvjpigszkc5pxyvo4qd5hqhpjgxj45pujak"
# AppSecret = "9cd65696426f4255991aea2f6c0b9190"

AppKey = '4y4twwj7q665p6g6322nwt6kyvn3b3a6hp3evpqz'
AppSecret = 'caa5bf2b38ff69a039a399be85d560df'

UDID = "test_udid_0001"
apiname = sys.argv[1]
# apiname = "refreshDeviceToken"
reslut = 0

def common_params():
    return {
            "appKey" : AppKey,
            "appSecret" : AppSecret,
            "udid" : UDID,
            "deviceSn" : "monitor_test_by_devops_team_build_by_Dakang",
            "pkgName" : "com.unisound.devopes.test",
            "appVersion" : "v1.1.0",
            "imei" : "imei01",
            "macAddress" : "macAddress01",
            "wifiSsid" : "wifiSsid01",
            "telecomOperator" : "operator01",
            "bssId" : "bssId01",
            "productName" : "productName01",
            "productModel" : "productModel01",
            "productMfr" : "productMfr01",
            "productOs" : "productOs01",
            "productOsVersion" : "productOsVersion01",
            "hardwareSn" : "hardwareSn01",
            "memo" : "memo01",
            "timestamp" : str(get_timestamp())
        }

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

def getDeviceToken(params_get_token):
    post_path = Server + "/rest/v2/device/activate"


    active_ret = send_post(post_path, params_get_token)
    #print "get-Device-token:" + active_ret
    token = active_ret.split('"token":"')[1].split('"')[0]
    return token

def refreshDeviceToken():
    params_get_token = common_params()
    params_get_token['signature'] = get_signature(params_get_token.values())
    token = getDeviceToken(params_get_token)

    params_refresh_token = {
                "appKey" : AppKey,
                "appSecret" : AppSecret,
                "udid" : UDID,
                "token" : token,
                "timestamp" : str(get_timestamp())
                }
    params_refresh_token['signature'] = get_signature(params_refresh_token.values())

    refresh_path = Server + '/rest/v2/token/refresh'
    refresh_ret = send_post(refresh_path, params_refresh_token)
    # print "refresh-Device-token:" + refresh_ret
    refresh_json = json.loads(refresh_ret,"utf-8")
    if refresh_json["message"] == "成功" and int(refresh_json["costTime"]) < 2000:
        reslut = 1
    print reslut

def activate_by_customer():
    customer_active_path = Server + "/rest/v2/device/activate_by_customer"
    params_activate_by_customer = common_params()
    params_activate_by_customer['customerCode'] = "libin_inner_devops"
    params_activate_by_customer['signature'] = get_signature(params_activate_by_customer.values())

    customer_active_ret = send_post(customer_active_path, params_activate_by_customer)
    # print "customer_active_ret:" + customer_active_ret
    customer_json = json.loads(customer_active_ret,"uft-8")
    if customer_json["message"] == "成功" and int(customer_json["costTime"]) < 3000:
        reslut = 1
    print reslut

if __name__ == '__main__':
    if apiname == "refreshDeviceToken":
        refreshDeviceToken()
    elif apiname == "activate_by_customer":
        activate_by_customer()
