import pymongo
import hashlib, uuid
import urllib.parse

class database():
    #Function to connect
    def connect(self):
        mongo_uri = "mongodb+srv://darknites:" + urllib.parse.quote("D@rkN1t3s") + "@defendr-1vnvv.azure.mongodb.net/test?retryWrites=true"
        client = pymongo.MongoClient(mongo_uri)
        db = client["Defendr"]
        return db

    #Function to find blacklisted ip in database of blacklisted ids
    def find_Blacklisted_IP(self,db, ip):
        col = db["blacklist"]
        data = []
        if ip == "":
            for x in col.find({}, {"_id": 0}):
                data.append(x)
        else:
            query = {"adress": ip}
            for x in col.find(query, {"_id": 0}):
                data.append(x)
        return data

    #Function to add an ip to the blacklist on the database
    def add_ip(self,db,ip):
        col = db["blacklist"]
        data = {"adress": ip}
        col.insert_one(data)

    #Function to remove blacklisted ip from database of blacklisted ips
    def rem_Blacklisted_IP(self,db, ip):
        col = db["blacklist"]
        col.remove({"adress": ip})
        doc = col.find({"adress": ip},{"_id": 0})
        string_output = "Not Found"
        for x in doc:
            string_output =str(x)
        if(string_output=="Not Found"):
            return "Success"
        return "Fail"

    #Function to find whitelist ip in database of blacklisted ids
    def find_whiteListed_IP(self,db,ip):
        col = db["whitelist"]
        data = []
        if ip == "":
            for x in col.find({}, {"_id": 0}):
                data.append(x)
        else:
            query = {"adress": ip}
            for x in col.find(query, {"_id": 0}):
                data.append(x)
        return data

    #Function to add an ip to the whitelist on the database
    def add_whiteListed_ip(self,db,ip):
        col = db["whitelist"]
        data = {"adress": ip}
        col.insert_one(data)

    #Function to remove whitelist ip from database of blacklisted ips
    def rem_Whitelisted_IP(self,db, ip):
        col = db["whitelist"]
        col.remove({"adress": ip})
        doc = col.find({"adress": ip},{"_id": 0})
        string_output = "Not Found"
        for x in doc:
            string_output =str(x)
        if(string_output=="Not Found"):
            return "Success"
        return "Fail"

    #Function to get packets
    def find_packets(self,db, input, searchOn, insort, sort, skipNr, limitNr):
        col = db["packets_list"]
        data =[]
        if input=="":
            for x in col.find({},{"_id": 0}).skip(skipNr).limit(limitNr).sort(insort, sort):
                data.append(x)
        else:
            query = {searchOn: input}
            print( col.find(query,{"_id": 0}))
            for x in col.find(query,{"_id": 0}).skip(skipNr).limit(limitNr).sort(insort, sort):
                data.append(x)
        return data

    #Function to get the salt for an email
    def get_salt(self,db,email):
        col = db["user"]
        doc = col.find({"email": email},{ "_id": 0, "name": 0, "roll": 0, "password": 0, "lastname": 0,"email": 0,"sendEmail":0})
        string_output = "notFond"
        for x in doc:
            string_output =str(x)
        if(string_output!="notFond"):
            return string_output[10:len(string_output)-2]
        return string_output

    #Function to get the password for an email
    def get_password(self,db,email):
        col = db["user"]
        doc = col.find({"email": email},{ "_id": 0, "name": 0, "roll": 0, "salt": 0, "lastname": 0,"email": 0,"sendEmail":0})
        string_output = "notFond"
        for x in doc:
            string_output = str(x)
        if(string_output!="notFond"):
            return string_output[14:len(string_output)-2]
        return string_output

    #Function to get the roll for an email
    def get_roll(self,db,email):
        col = db["user"]
        doc = col.find({"email": email},{ "_id": 0, "name": 0, "salt": 0, "password": 0, "lastname": 0,"email": 0,"sendEmail":0})
        string_output="notFond"
        for x in doc:
            string_output = str(x)
        if(string_output!="notFond"):
            return string_output[10:len(string_output) - 2]
        return string_output

    #Function to get the name for an email
    def get_name(self,db,email):
        col = db["user"]
        doc = col.find({"email": email},{ "_id": 0, "roll": 0, "salt": 0, "password": 0, "lastname": 0,"email": 0,"sendEmail":0})
        string_output="notFond"
        for x in doc:
            string_output = str(x)
        if(string_output!="notFond"):
            return string_output[10:len(string_output) - 2]
        return string_output

    #Function to get the last name for an email
    def get_last_name(self,db,email):
        col = db["user"]
        doc = col.find({"email": email},{ "_id": 0, "name": 0, "salt": 0, "password": 0, "roll": 0,"email": 0,"sendEmail":0})
        string_output="notFond"
        for x in doc:
            string_output = str(x)
        if(string_output!="notFond"):
            return string_output[14:len(string_output) - 2]
        return string_output

    #Function to get the send email for an email
    def get_email_send(self,db,email):
        col = db["user"]
        doc = col.find({"email": email},
                       {"_id": 0, "name": 0, "salt": 0, "password": 0, "roll": 0, "email": 0, "lastname": 0})
        string_output = "notFond"
        for x in doc:
            string_output = str(x)
        if (string_output != "notFond"):
            return string_output[15:len(string_output) - 2]
        return string_output

    #Function to get all email addresses for admin that wants mail
    def get_email_to_send_to(self,db):
        col = db["user"]
        doc = col.find({"roll": "admin","sendEmail":"yes"}, {"_id": 0, "name": 0, "salt": 0, "password": 0, "roll": 0, "lastname": 0,"sendEmail":0})
        stringoutput =[]
        for x in doc:
            temp=str(x)
            temp=temp[11:len(temp) - 2]
            stringoutput.append(temp)
        return stringoutput

    #Function to add an admin user to the database
    def save_user(self,db,name,lastName,roll,salt, password, email, sendEmail):
        col = db["user"]
        dict={"name": name, "lastname":lastName, "roll": roll, "salt": salt, "password": password, "email": email,"sendEmail": sendEmail}
        col.insert_one(dict)

    #Function to remove an user for the database
    def remove_user(self,db,name,roll,salt, password, lastname):
        col = db["user"]
        query = {"name": name, "lastname": lastname, "roll": roll, "salt": salt, "password": password}
        col.delete_many(query)

    #Function to get all user for the database
    def print_user(self,db, name, searchOn, insort, sort):
        col = db["user"]
        data =[]
        if name == "":
            for x in col.find({}, {"_id": 0, "salt": 0, "password": 0}).sort("lastname", 1):
                data.append(x)
        else:
            query = {searchOn: name }
            for x in col.find(query, {"_id": 0, "salt": 0, "password": 0}).sort(insort,sort):
                data.append(x)
        return data

    #Function to check in an user is in the database
    def check_user(self,db):
        my_col = db["user"]
        counter =0
        for x in my_col.find({}, {"_id": 0, "salt": 0, "password": 0}):
            counter=counter+1
        if(counter==0):
            return False
        else:
            return True

    #Function to change an user's name in the database
    def change_name(self,db, email, name):
        my_col = db["user"]
        my_query = {"email": email}
        new_values = {"$set": {"name": name}}

        my_col.update_one(my_query, new_values)

    #Function to change an user's last name in the database
    def change_lastname(self,db, email, lastname):
        my_col = db["user"]
        my_query = {"email": email}
        new_values = {"$set": {"lastname": lastname}}

        my_col.update_one(my_query, new_values)

    #Function to change an user's email in the databas
    def change_email(self,db, email, new_email):
      my_col = db["user"]
      my_query = {"email": email}
      new_values = {"$set": {"email": new_email}}

      my_col.update_one(my_query, new_values)

    #Function to change an user's roll in the databas
    def change_roll(self,db, email, roll):
      my_col = db["user"]
      my_query = {"email": email}
      new_values = {"$set": {"roll": roll}}

      my_col.update_one(my_query, new_values)

    #Function to change an user's password in the databas
    def change_password(self,db, email, password):
      salt = self.get_salt(db, email)
      pwd = self.hashed_function(password, salt)
      my_col = db["user"]
      my_query = {"email": email}
      new_values = {"$set": {"password": pwd}}

      my_col.update_one(my_query, new_values)

    #Function to check password
    def check_pass(self,db, email, password):
        salt=self.get_salt(db,email)
        check_pwd=self.hashed_function(password,salt)
        hashed_pwd=self.get_password(db,email)
        if(check_pwd==hashed_pwd):
            return True
        else:
            return False

    #Function to change in an admin wants email or not
    def change_state(self,db,email,state):
        my_col = db["user"]
        my_query = {"email": email}
        new_values = {"$set": {"sendEmail": state}}
        my_col.update_one(my_query, new_values)

    #Function to hash a password
    def hashed_function(self,password, salt):
        password_temp = password + salt
        hashed_password = hashlib.sha512(password_temp.encode('utf-8')).hexdigest()
        return hashed_password

    #Function to make salt
    def makeSalt(self):
        salt = uuid.uuid4().hex
        return salt

    #Function to get detalis and remove an user
    def remove(self,db,email):
        salt = self.get_salt(db,email)
        if salt=="notFond":
            return "Not removed"
        roll = self.get_roll(db,email)
        if roll=="notFond":
            return "Not removed"
        password = self.get_password(db,email)
        if password=="notFond":
            return "Not removed"
        name = self.get_name(db,email)
        if name=="notFond":
            return "Not removed"
        lastname = self.get_last_name(db,email)
        if lastname=="notFond":
            return "Not removed"
        self.remove_user(db, name, roll, salt, password,lastname)
        return name+" removed"

    #Function to make a new user
    def make_new_user(self,db, name, lastName, password, roll, email,sendEmail):
        # check if name is used
        check = self.get_salt(db, email)
        if check !="notFond":
            return False
        # make salt and hash
        salt = self.makeSalt()
        hash_password = self.hashed_function(password, salt)
        self.save_user(db, name,lastName, roll, salt, hash_password, email,sendEmail)
        return True

        #Function to get all user for the database
    def get_connection_ips(self,db,timestamp):
        print("get_connection_ips")
        my_col = db["packets_list"]
        result = my_col.distinct("ip_source", {"timestamp": {"$gte": str(timestamp)}, "status": "enter"})
        countries = []
        for x in result:
            countries.append(str(x))
        return countries

    

#db = connect()
#print(print_user(db))
#changeState(db,"u17094446@tuks.co.za","no")
#changeState(db,"u14016304@tuks.co.za","no")
#change_state(db,"u15034993@tuks.co.za","no")
#changeState(db,"u15019854@tuks.co.za","no")