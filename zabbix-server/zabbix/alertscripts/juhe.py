#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import os
import time
import smtplib
import dingtalk
from email.mime.text import MIMEText
from email.header import Header

dingtalk_url=[sys.argv[1]]
#dingtalk_url=["https://oapi.dingtalk.com/robot/send?access_token="]
#fx_dingtalk_url=["https://oapi.dingtalk.com/robot/send?access_token="]
tmp_file="/juhe_tmp/juhe.txt"
def juhe():
    file = open(tmp_file)
    alerts={}
    file=file.read().split("**")
    file.pop(0)
    for line in file:
        one_alert = line.split("^")
        alert_who = one_alert[0]
        alert_status = one_alert[1]
        alert_ip = one_alert[2]
        alert_trigger = one_alert[3]
        alert_info = one_alert[4]

        if alerts.has_key(alert_who):
            if alerts[alert_who].has_key(alert_status):
               alerts[alert_who][alert_status].append([alert_ip, alert_trigger, alert_info])
            else:
               alerts[alert_who][alert_status] = [[alert_ip, alert_trigger, alert_info]]
        else:
            alerts[alert_who] = {}
            alerts[alert_who][alert_status] = [[alert_ip, alert_trigger, alert_info]]
    return alerts

def send_mail(to_list,sub='test',content='test',mail_user_show='ZABBIX'):
    mail_host="xx.outlook.cn:587"
    mail_user="xx@xx.com"
    mail_pass="xx"
    mail_postfix="xx.com"
    me=mail_user_show+"<"+mail_user+">"
    # 设置UTF-8解决中文乱码问题
    msg = MIMEText(content,'html',_charset='UTF-8')
    msg['Subject'] = Header(sub,"UTF-8")
    msg['From'] = me
    msg['To'] = ",".join(to_list)
    try:
        s = smtplib.SMTP()
        s.connect(mail_host)
        s.esmtp_features["auth"]="LOGIN"
        s.ehlo()
        s.starttls()
        s.login(mail_user,mail_pass)
        s.sendmail(me, to_list, msg.as_string())
        s.close()
        return True
    except Exception, e:
        print str(e)
        return False
def alert(mail_to,alerts,dingtalk_url):
    for status in alerts:
        mail_subject = "ZABBIX ALERT: " + status
        mail_content = "<table border='1'>"
        ding_text = ""
        for alert in alerts[status]:
            mail_content += "<tr><td>%s</td><td>%s</td><td>%s</td></tr>" % (alert[0], alert[1], alert[2])
            ding_text += "\n\n=============\n- %s\n- %s\n- %s" % (alert[0], alert[1], alert[2])
        mail_content += "</table>"
        dingtalk.alert_notice(dingtalk_url,mail_subject,ding_text)
        #send_mail(mail_to,mail_subject,mail_content)
def main():
    alerts = juhe()
    for who in alerts:
        mail_to = who.split(",")
        alert(mail_to,alerts[who],dingtalk_url)
        #if "xiangrong.ke@phicomm.com" in  mail_to:
        #    alert(mail_to,alerts[who],fx_dingtalk_url)
        #else:
        #    alert(mail_to,alerts[who],dingtalk_url)

if __name__ == '__main__':
    main()

