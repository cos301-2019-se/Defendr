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
    # Initializing database.
    def __init__(self):
        self.database = database()
        if (self.db_connects == ""):
            self.db_connects = self.database.connect()
        self.smpt = email()
        if (self.smpt_connects == ""):
            self.smpt_connects = self.smpt.connect_To_SMTP_server()
    # Function for logging into program.
    def login(self,loginText,passwordText):
        if (not (loginText == '') and not (passwordText == '')):
            roll=self.database.get_roll(self.db_connects,loginText)
            if(roll=='new'):
                return "Please let an admin validate your account."
            else:
                output = self.database.check_pass(self.db_connects,loginText,passwordText)
                if(output):
                    return roll
                else:
                    return "Error"
        else:
            return "Enter info"
    # Send email for hack attempt.
    def send_Email_Hacked(self,hacked):
        self.smpt.email_For_Hack(self.db_connects,self.database,self.smpt_connects,hacked)
    # Send email for new user being added.
    def send_email_add(self, name, email):
        self.smpt.email_Add_New_User(self.db_connects,self.database,self.smpt_connects,name,email)
    # List the blacklist.
    def list_black_ip(self, ip):
        return self.database.find_Blacklisted_IP(self.db_connects, ip)
    # Remove a blacklisted an IP.
    def remove_black_ip(self, ip):
        if(self.check_IP(ip)):
            self.xdp.remove_Blacklisted_IP(ip)
            self.database.rem_Blacklisted_IP(self.db_connects, ip)
            return "IP is removed."
        else:
            return "Invalid IP."

    # Blacklist an IP.
    def add_black_ip(self, ip):
        if(self.check_IP(ip)):
            if not self.database.find_Blacklisted_IP(self.db_connects, ip) and not self.database.find_whiteListed_IP(self.db_connects, ip):
                self.xdp.black_list_IP(ip)
                self.database.add_ip(self.db_connects, ip)
                return "IP is black listed."
            else:
                return "IP on the blacklisted."
        else:
            return "Invalid IP."
    # Get the logs from database.
    def get_logs(self,  input, searchOn, insort, sort, skipNr, limitNr):
        return self.database.find_packets(self.db_connects,input, searchOn, insort, sort, skipNr, limitNr)
    # List the whitelist.
    def list_white_ip(self, ip):
        return self.database.find_whiteListed_IP(self.db_connects, ip)

    # Stop xdp services.
    def start_xdp(self):
        self.xdp.load_xdp()
        return
    
    # Start sdp services/
    def stop_xdp(self):
        self.xdp.unload_xdp()
        return   

    # Whitelist an IP.
    def add_white_ip(self,ip):
        if self.check_IP(ip):
            if not self.database.find_whiteListed_IP(self.db_connects, ip):
                self.database.rem_Blacklisted_IP(self.db_connects, ip)
                self.database.add_whiteListed_ip(self.db_connects, ip)
                self.xdp.remove_Blacklisted_IP(ip)
                self.xdp.white_list_IP(ip)
                return "IP is white listed."
            else:
                return "IP on the whitelisted."
        else:
            return "Invalid IP."

    #Remove an IP from whitelist.
    def remove_white_ip(self,ip):
        if self.check_IP(ip):
            self.database.rem_Whitelisted_IP(self.db_connects, ip)
            self.xdp.remove_whitelisted_IP(ip)
            return "IP is removed."
        else:
            return "Invalid IP."
    # Function to register a new user.
    def register(self,name, surname, email, password, confirm_pass):
        if (not self.database.print_user(self.db_connects,surname, "lastname", "lastname", 1)):
            result = self.register_user(name, surname, email, password, confirm_pass, "admin")
        else:
            result = self.register_user(name, surname, email, password, confirm_pass, "new")
        if (result=="Add"):
            self.send_email_add(name, email)
        return result

    def register_user(self,name,surename,email,password,rePassword,roll):
        if(name==""):
            return "Please enter name."
        else:
            if(surename==""):
                return "Please enter surname."
            else:
                if(self.check_email(email)):
                    password_output=self.check_password(password)
                    if(password_output=="True"):
                        if(rePassword==""):
                            return "Re-enter password."
                        else:
                            if(password==rePassword):
                                if(roll=="admin"):
                                    output = self.database.make_new_user(self.db_connects,name,surename,password,roll,email,"yes")
                                else:
                                    output = self.database.make_new_user(self.db_connects,name,surename,password,roll,email,"no")
                                if(not output):
                                    return "Falid."
                                return "Add"
                            else:
                                return "Passwords does not match."
                    else:
                        return password_output
                else:
                    return "Invalid email."

    def add_user(self,name,surename,email,password,rePassword,admin,sendEmail):
        if (name == ""):
            return "Please enter name"
        else:
            if (surename == ""):
                return "Please enter surname."
            else:
                if (self.check_email(email)):
                    password_output =self.check_password(password)
                    if (password_output=="True"):
                        if (rePassword == ""):
                            return "Re-enter password"
                        else:
                            if (password == rePassword):
                                if (admin):
                                    if (sendEmail):
                                        self.database.make_new_user(self.db_connects, name, surename, password, "admin", email, "yes")
                                    else:
                                        self.database.make_new_user(self.db_connects, name, surename, password, "admin", email, "no")
                                else:
                                    self.database.make_new_user(self.db_connects, name, surename, password, "user", email, "no")
                                return "Add"
                            else:
                                return "Passwords do not match"
                    else:
                        return password_output
                else:
                    return "Invalid email."

    def list_user(self, name, searchOn, insort, sort):
        return self.database.print_user(self.db_connects,name, searchOn, insort, sort)

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
            if(new_data!=""):
                self.database.change_name(self.db_connects,email,new_data)
            else:
                return "Invalid name"
        if(wait_to_chacnges=="surname"):
            if(new_data!=""):
                self.database.change_lastname(self.db_connects,email,new_data)
            else:
                return "Invalid surname"
        if(wait_to_chacnges=="email"):
            if(self.check_email(new_data)):
                self.database.change_email(self.db_connects,email,new_data)
            else:
                return "Invalid email"
        if(wait_to_chacnges=="password"):
            output=self.check_password(new_data)
            if(output=="True"):
                self.database.change_password(self.db_connects,email,new_data)
            else:
                return output
        if(wait_to_chacnges=="roll"):
            self.database.change_roll(self.db_connects,email,new_data)
        if(wait_to_chacnges=="sendEmail"):
            self.database.change_state(self.db_connects,email,new_data)
        return "Updated"

    def get_name(self, email):
        return self.database.get_name(self.db_connects, email)

    def get_roll(self, email):
        return self.database.get_roll(self.db_connects, email)

    # check if the email is correct
    def check_email(self, email):
        mail = email
        if (mail == ""):
            return False
        check = re.search(
            "([a-z]|[A-Z]|[0-9])+\@([a-z]|[A-Z]|[0-9])+((\.(([A-Z]|[a-z]|[0-9])+))|(\.(([A-Z]|[a-z]|[0-9])+)){2})$",
            mail)
        if (check):
            return True
        else:
            return False

    def check_password(self, psw):
        password = psw
        if(password==""):
            return "Enter password"

        number = re.findall("[0-9]", password)
        if (not (number)):
            return "Password must contain a number."

        caps = re.findall("[A-Z]", password)
        if (not (caps)):
            return "Password must contain a uppercase character."

        lower = re.findall("[a-z]", password)
        if (not (lower)):
            return "Users mangement", "Password must contain a lowercase character."

        symbols = re.findall("[!,@,#,$,%,^,&,*,.,?]", password)
        if (not (symbols)):
            return "Password must contain a special character."

        if(len(password)<6):
            return "Password must contain at least 6 characters."
        return "True"

    def check_IP(self, IP):
        if(IP==""):
            return False
        check = re.search(
            "([0-9])+\.([0-9])+\.([0-9])+\.([0-9])+",
            IP)
        if (check):
            return True
        else:
            return False
