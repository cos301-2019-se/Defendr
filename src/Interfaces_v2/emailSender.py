import smtplib
import databaseCon
import time

gmail_sender='info@darknites.co.za'
gmail_password='D@rkN1t3s'

def emailAddNewUser(db,server,name):
    sub ='Verify user'
    text ='Account verification needed for '+name+'\nDefendr'
    sendEmail(db,server, sub, text)

def emailForHack(db,server,hacked_gmail):
    sub ='Warning'
    text ='Warning the user accunt\'s ('+hacked_gmail+') password may being focred.\nDefendr'
    sendEmail(db,server,sub,text)

def sendEmail(db,server, subject, body):
    try:
        temp = databaseCon.get_email_to_send_to(db)
        for TO in temp:
            BODY = '\r\n'.join(['To: %s' % TO,
                                'From: %s' % gmail_sender,
                                'Subject: %s' % subject,
                                '',
                                body])
            server.sendmail(gmail_sender, [TO], BODY)
            print('email sent to ' + TO)
    except:
        print('error')

def connectToSMTPserver():
    server = smtplib.SMTP('mail.darknites.co.za', 587 )
    server.ehlo()
    server.starttls()
    server.login(gmail_sender, gmail_password)
    return server

