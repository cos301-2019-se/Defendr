import pymongo
import hashlib, uuid
import urllib.parse
import re

#Function to add an ip to the blacklist on the database
def add_ip(db,ip):
    col = db["blacklist"]
    data = {"adress": ip}
    col.insert_one(data)

#Function to connect
def connect():
    mongo_uri = "mongodb+srv://darknites:" + urllib.parse.quote("D@rkN1t3s") + "@defendr-1vnvv.azure.mongodb.net/test?retryWrites=true"
    client = pymongo.MongoClient(mongo_uri)
    db = client["Defendr"]
    return db

#Function to find blacklisted ip in database of blacklisted ids
def find_Blacklisted_IP(db, ip):
    col = db["blacklist"]
    doc = col.find({"ip": ip},{"_id": 0})
    string_output = "Not Found"
    for x in doc:
        string_output =str(x)
    if(string_output!="Not Found"):
        return string_output[8:len(string_output)-2]
    return string_output

#Function to remove blacklisted ip from database of blacklisted ips
def rem_Blacklisted_IP(db, ip):
    col = db["blacklist"]
    col.remove({"ip": ip})
    doc = col.find({"ip": ip},{"_id": 0})
    string_output = "Not Found"
    for x in doc:
        string_output =str(x)
    if(string_output=="Not Found"):
        return "Success"
    return "Fail"

#Function to get packets
def find_packets(db, ip):
    col = db["packets_list"]
    if ip=="":
        doc=col.find({},{"_id": 0}).sort("timestamp", -1)
    else:
        query = {"ip_source": ip}
        doc = col.find(query,{ "_id": 0}).sort("timestamp", -1)
    return doc

#Function to get the salt for an email
def get_salt(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "name": 0, "roll": 0, "password": 0, "lastname": 0,"email": 0})
    string_output = "notFond"
    for x in doc:
        string_output =str(x)
    if(string_output!="notFond"):
        return string_output[10:len(string_output)-2]
    return string_output

#Function to get the password for an email
def get_password(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "name": 0, "roll": 0, "salt": 0, "lastname": 0,"email": 0})
    string_output = "notFond"
    for x in doc:
        string_output = str(x)
    if(string_output!="notFond"):
        return string_output[14:len(string_output)-2]
    return string_output

#Function to get the roll for an email
def get_roll(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "name": 0, "salt": 0, "password": 0, "lastname": 0,"email": 0})
    string_output="notFond"
    for x in doc:
        string_output = str(x)
    if(string_output!="notFond"):
        return string_output[10:len(string_output) - 2]
    return string_output

#Function to get the name for an email
def get_name(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "roll": 0, "salt": 0, "password": 0, "lastname": 0,"email": 0})
    string_output="notFond"
    for x in doc:
        string_output = str(x)
    if(string_output!="notFond"):
        return string_output[10:len(string_output) - 2]
    return string_output

#Function to get the last name for an email
def get_last_name(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "name": 0, "salt": 0, "password": 0, "roll": 0,"email": 0})
    string_output="notFond"
    for x in doc:
        string_output = str(x)
    if(string_output!="notFond"):
        return string_output[14:len(string_output) - 2]
    return string_output

#Function to add an user to the database
def save_user(db,name,lastName,roll,salt, password, email):
    col = db["user"]
    dict={"name": name, "lastname":lastName, "roll": roll, "salt": salt, "password": password, "email": email}
    col.insert_one(dict)

#Function to remove an user for the database
def remove_user(db,name,roll,salt, password, lastname):
    col = db["user"]
    query = {"name": name, "lastname": lastname, "roll": roll, "salt": salt, "password": password}
    col.delete_many(query)

#Function to get all user for the database
def print_user(db):
    my_col = db["user"]
    lines = "-------------------------------------------------------------------------"
    for x in my_col.find({}, {"_id": 0, "salt": 0, "password": 0}):
        temp = str(x)
        array =temp.split('\'')
        name = array[3]
        last = array[7]
        roll = array[11]
        email = array[15]
        if(roll=="user"):
            roll=roll+"    "
        lines = lines + "|" + name + " \t\t| " + last + "\t\t| "+ roll + " | "+email + '\t|\n'
    lines = lines + "-------------------------------------------------------------------------"
    return lines

#Function to check in an user is in the database
def check_user(db):
    my_col = db["user"]
    counter =0
    for x in my_col.find({}, {"_id": 0, "salt": 0, "password": 0}):
        counter=counter+1
    if(counter==0):
        return False
    else:
        return True

#Function to change an user's name in the database
def change_name(db, email, name):
    my_col = db["user"]
    my_query = {"email": email}
    new_values = {"$set": {"name": name}}

    my_col.update_one(my_query, new_values)

#Function to change an user's last name in the database
def change_lastname(db, email, lastname):
    my_col = db["user"]
    my_query = {"email": email}
    new_values = {"$set": {"lastname": lastname}}

    my_col.update_one(my_query, new_values)

#Function to change an user's email in the databas
def change_email(db, email, new_email):
  my_col = db["user"]
  my_query = {"email": email}
  new_values = {"$set": {"email": new_email}}

  my_col.update_one(my_query, new_values)

#Function to change an user's roll in the databas
def change_roll(db, email, roll):
  my_col = db["user"]
  my_query = {"email": email}
  new_values = {"$set": {"roll": roll}}

  my_col.update_one(my_query, new_values)

#Function to change an user's password in the databas
def change_password(db, email, password):
  salt = get_salt(db, email)
  pwd = hashFunction(password, salt)
  my_col = db["user"]
  my_query = {"email": email}
  new_values = {"$set": {"password": pwd}}

  my_col.update_one(my_query, new_values)

#Function to check password
def check_pass(db, email, password):
    salt=get_salt(db,email)
    check_pwd=hashed_function(password,salt)
    hashed_pwd=get_password(db,email)
    if(check_pwd==hashed_pwd):
        return True
    else:
        return False

#Function to hash a password
def hashed_function(password, salt):
    password_temp = password + salt
    hashed_password = hashlib.sha512(password_temp.encode('utf-8')).hexdigest()
    return hashed_password

#Function to make salt
def makeSalt():
    salt = uuid.uuid4().hex
    return salt

#Function to get detalis and remove an user
def remove(db,email):
    salt = get_salt(db,email)
    if salt=="notFond":
        return "Not removed"
    roll = get_roll(db,email)
    if roll=="notFond":
        return "Not removed"
    password = get_password(db,email)
    if password=="notFond":
        return "Not removed"
    name = get_name(db,email)
    if name=="notFond":
        return "Not removed"
    lastname = get_last_name(db,email)
    if lastname=="notFond":
        return "Not removed"
    remove_user(db, name, roll, salt, password,lastname)
    return name+" removed"

#Function to make a new user
def make_new_user(db, name, lastName, password, roll, email):
    # check if name is used
    check = get_salt(db, email)
    if check !="notFond":
        return False
    # make salt and hash
    salt = makeSalt()
    hash_password = hashed_function(password, salt)
    save_user(db, name,lastName, roll, salt, hash_password, email)
    return True