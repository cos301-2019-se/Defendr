from databaseCon import database
from emailSender import email
from controller import controller
import re

class FacadeClass():
    db_connects=""
    database=""
    smpt=""
    smpt_connects=""
    xdp = controller("../")

    def __init__(self):
        self.database = database()
        if (self.db_connects == ""):
            self.db_connects = self.database.connect()
        self.smpt = email()
        if (self.smpt_connects == ""):
            self.smpt_connects = self.smpt.connectToSMTPserver()

    def login(self,loginText,passwordText):
        if (not (loginText == '') and not (passwordText == '')):
            roll=self.database.get_roll(self.db_connects,loginText)
            if(roll=='new'):
                return "Please let admin valid your account."
            else:
                output = self.database.check_pass(self.db_connects,loginText,passwordText)
                if(output):
                    return roll
                else:
                    return "Error"
        else:
            return "Enter info"

    def sendEmailHacked(self,hacked):
        self.smpt.emailForHack(self.db_connects,self.database,self.smpt_connects,hacked)

    def send_email_add(self, name, email):
        self.smpt.emailAddNewUser(self.db_connects,self.database,self.smpt_connects,name,email)

    def list_black_ip(self, ip):
        if (self.check_IP(ip) or ip==""):
            return self.database.find_Blacklisted_IP(self.db_connects, ip)

    def remove_black_ip(self, ip):
        if(self.check_IP(ip)):
            self.xdp.remove_Blacklisted_IP(ip)
            self.database.rem_Blacklisted_IP(self.db_connects, ip)

    def add_black_ip(self, ip):
        if(self.check_IP(ip)):
            if not self.database.find_Blacklisted_IP(self.db_connects, ip) and not self.database.find_whiteListed_IP(self.db_connects, ip):
                self.xdp.black_list_IP(ip)
                self.database.add_ip(self.db_connects, ip)

    def get_logs(self, ip):
        if(self.check_IP(ip) or ip=="" ):
            return self.database.find_packets(self.db_connects,ip)

    def list_with_ip(self, ip):
        if (self.check_IP(ip) or ip==""):
            return self.database.find_whiteListed_IP(self.db_connects, ip)

    def add_with_ip(self,ip):
        if self.check_IP(ip):
            if not self.database.find_whiteListed_IP(self.db_connects, ip):
                self.database.rem_Blacklisted_IP(self.db_connects, ip)
                self.database.add_whiteListed_ip(self.db_connects, ip)
                self.xdp.remove_Blacklisted_IP(ip)

    def remove_with_ip(self,ip):
        if self.check_IP(ip):
            self.database.rem_Whitelisted_IP(self.db_connects, ip)

    def register(self,name, surname, email, password, confirm_pass):
        if (not self.database.print_user(self.db_connects)):
            check = self.register_user(name, surname, email, password, confirm_pass, "admin")
        else:
            check = self.register_user(name, surname, email, password, confirm_pass, "new")
        if (check):
            self.send_email_add(name, email)
            return True
        return False

    def register_user(self,name,surename,email,password,rePassword,roll):
        if(name==""):
            print("Name must not be enter")
        else:
            if(surename==""):
                print("Surename must not be enter")
            else:
                if(self.check_email(email)):
                    if(self.check_password(password)):
                        if(rePassword==""):
                            print("Re-enter password")
                        else:
                            if(password==rePassword):
                                if(roll=="admin"):
                                    output = self.database.make_new_user(self.db_connects,name,surename,password,roll,email,"yes")
                                else:
                                    output = self.database.make_new_user(self.db_connects,name,surename,password,roll,email,"no")
                                if(not output):
                                    print("Falid1")
                                    return False
                                print("Added")
                                return True
                            else:
                                print("Password does not macth")
        return False

    def add_user(self,name,surename,email,password,rePassword,admin,sendEmail):
        if (name == ""):
            print("Name must not be enter")
        else:
            if (surename == ""):
                print("Surename must not be enter")
            else:
                if (self.check_email(email)):
                    if (self.check_password(password)):
                        if (rePassword == ""):
                            print("Re-enter password")
                        else:
                            if (password == rePassword):
                                if (admin):
                                    if (sendEmail):
                                        output = self.database.make_new_user(self.db_connects, name, surename, password, "admin", email, "yes")
                                    else:
                                        output = self.database.make_new_user(self.db_connects, name, surename, password, "admin", email, "no")
                                else:
                                    output = self.database.make_new_user(self.db_connects, name, surename, password, "user", email, "no")
                                print(output)
                            else:
                                print("Password does not macth")

    def list_user(self):
        return self.database.print_user(self.db_connects)

    def remove_user(self, email):
        if (self.check_email(email)):
            self.database.remove(self.db_connects,email)

    def verify_user(self, email):
        if (self.check_email(email)):
            if(self.database.get_roll(self.db_connects,email)=="new"):
                self.database.change_roll(self.db_connects,email,"user")

    def get_user_detail(self, email):
        details=[]
        details.append(self.database.get_name(self.db_connects,email))
        details.append(self.database.get_last_name(self.db_connects,email))
        details.append(email)
        details.append(self.database.get_roll(self.db_connects,email))
        details.append(self.database.get_email_send(self.db_connects,email))
        return details

    def update_user_detail(self, email, wait_to_chacnges, new_data):
        if(wait_to_chacnges=="name"):
            self.database.change_name(self.db_connects,email,new_data)
        if(wait_to_chacnges=="surname"):
            self.database.change_lastname(self.db_connects,email,new_data)
        if(wait_to_chacnges=="email"):
            if(self.check_email(new_data)):
                self.database.change_email(self.db_connects,email,new_data)
        if(wait_to_chacnges=="password"):
            if(self.check_password(new_data)):
                self.database.change_password(self.db_connects,email,new_data)
        if(wait_to_chacnges=="roll"):
            self.database.change_roll(self.db_connects,email,new_data)
        if(wait_to_chacnges=="sendEmail"):
            self.database.change_state(self.db_connects,email,new_data)

    # check if the email is correct
    def check_email(self, email):
        mail = email
        if (mail == ""):
            print("Enter an email")
            return False
        check = re.search(
            "([a-z]|[A-Z]|[0-9])+\@([a-z]|[A-Z]|[0-9])+((\.(([A-Z]|[a-z]|[0-9])+))|(\.(([A-Z]|[a-z]|[0-9])+)){2})$",
            mail)
        if (check):
            return True
        else:
            print("Invalid email.")
            return False

    def check_password(self, psw):
        password = psw
        if(password==""):
            print("Enter a password")
            return False
        number = re.findall("[0-9]", password)
        if (not (number)):
            print("Your password needs a number.")
            return False
        caps = re.findall("[A-Z]", password)
        if (not (caps)):
            print("Your password needs a uppercase chatter.")
            return False
        lower = re.findall("[a-z]", password)
        if (not (lower)):
            print("Users mangement", "Your password needs a lowercase chatter.")
            return False
        symbols = re.findall("[!,@,#,$,%,^,&,*,.,?]", password)
        if (not (symbols)):
            print( "Your password needs a symbol.")
            return False
        if(len(password)<6):
            print( "Your password needs to be 6 chatters long.")
            return False
        return True

    def check_IP(self, IP):
        if(IP==""):
            print("Enter an ip")
            return False
        check = re.search(
            "([0-9])+\.([0-9])+\.([0-9])+\.([0-9])+",
            IP)
        if (check):
            return True
        else:
            print("Invalid ip.")
            return False