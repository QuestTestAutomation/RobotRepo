import smtplib
from email.mime.text import MIMEText

SRS = ['4406312 ']
for sr in SRS:

    to = ['seshikanth.anumolu@quest.com']
    cc = ['qstaf.testautomation@gmail.com']
    subject = '|SR Number:' + sr + '|'
    gmail_user = 'art.cognizant1@gmail.com'
    gmail_pwd = 'Quest@123'

    smtpserver = smtplib.SMTP("smtp.gmail.com", 587)
    smtpserver.ehlo()
    smtpserver.starttls()

    smtpserver.login(gmail_user, gmail_pwd)
    header = 'To:' + ", ".join(to) + '\n' + 'CC:' + ", ".join(cc) + '\n' + 'From: ' + gmail_user + '\n' + 'Subject: ' + subject + '\n'
    msg = header + '\n' + subject + '\n\n'
    print(header)
    smtpserver.sendmail(gmail_user, to, msg)