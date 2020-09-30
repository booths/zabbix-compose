#-*- coding: utf-8 -*-

import urllib2
import json
def alert_notice(webhook_url,alert_title,alert_text):
    urls=webhook_url
    #定义要提交的数据
    alert_text = "# %s\n " % (alert_title)  + alert_text
    alert_data ={
            "title": alert_title,
            "text": alert_text
            }

    postdata={
            "msgtype": "markdown",
            "markdown": alert_data
            }
    postdata=json.dumps(postdata)
    for url in urls:
        request = urllib2.Request(url,postdata)
        request.add_header('Content-Type', 'application/json;charset=utf-8')
        response=urllib2.urlopen(request)

def format_msg(data):
    msg = ""
    for one_alert in data:
        ip = one_alert[1]
        time = one_alert[3] + one_alert[4]
        core_name = one_alert[5]
        session_id = one_alert[6]
        run_time = one_alert[7]
        error_step = one_alert[8]
        error_code = one_alert[9]
        errno = one_alert[10]
        msg += "\n\n=============\n"
        msg += """- **IP:** %s \n- **time:** %s\n- **core name:** %s\n- **session id:** %s\n- **run time:** %s\n- **error step:** %s\n- **error code:** %s\n- **errno:** %s""" % (ip,time,core_name,session_id,run_time,error_step,error_code,errno)
    return msg
