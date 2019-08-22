import smtplib

class email():
    gmail_sender='info@darknites.co.za'
    gmail_password='D@rkN1t3s'

    def emailAddNewUser(self,db, database,server,name, email):
        sub ='Verify user'
        text ='Account verification needed for '+name+'('+email+')\nDefendr'
        self.sendEmail(db, database,server, sub, text)

    def emailForHack(self,db, database,server,hacked_gmail):
        sub ='Warning'
        text ='Warning the user accunt\'s ('+hacked_gmail+') password may being focred.\nDefendr'
        self.sendEmail(db, database,server,sub,text)

    def emailForAttack(self,db, database,server,meta):
        sub ='Warning'
        if(meta == "cps"):
            text = 'Warining! System under extreme stress. Please see Defendr metrics'
        else:
            text ='Ip \''+ip+'\' blacklisted because of possible attack attempt.'
        self.sendEmail(db, database,server,sub,text)

    def sendEmail(self,db, database,server, subject, body):
        try:
            temp = database.get_email_to_send_to(db)
            for TO in temp:
                BODY = '\r\n'.join(['To: %s' % TO,
                                    'From: %s' % self.gmail_sender,
                                    'Subject: %s' % subject,
                                    '',
                                    body])
                server.sendmail(self.gmail_sender, [TO], BODY)
                //print('Email sent to ' + TO)
        except:
            print('Mail not send.')

    def connectToSMTPserver(self):
        server = smtplib.SMTP('mail.darknites.co.za', 587 )
        server.ehlo()
        server.starttls()
        server.login(self.gmail_sender, self.gmail_password)
        return server

