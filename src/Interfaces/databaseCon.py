import pymongo
import hashlib, uuid
import urllib.parse
import re

def addIp(db,ip):
    col = db["blacklist"]
    data = {"adress": ip}
    col.insert_one(data)

def connect():
    mongo_uri = "mongodb+srv://darknites:" + urllib.parse.quote("D@rkN1t3s") + "@defendr-1vnvv.azure.mongodb.net/test?retryWrites=true"
    client = pymongo.MongoClient(mongo_uri)
    db = client["Defendr"]
    return db

def findBlacklist(db, ip):
    col = db["blacklist"]
    doc = col.find({"ip": ip}, {"_id": 0, "ip": 0})
    stringoutput = "Not Found"
    for x in doc
        stringoutput = str(x)
    if stringoutput != "Not Found"
        return stringoutput[8:len(stringoutput)-2]
    return stringoutput


def findPackets(db, ip):
    col = db["packets_list"]
    if ip=="":
        doc=col.find({},{"_id": 0}).sort("timestamp", -1)
    else:
        query = {"ip_source": ip}
        doc = col.find(query,{ "_id": 0}).sort("timestamp", -1)
    return doc

def getSalt(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "name": 0, "roll": 0, "password": 0, "lastname": 0,"email": 0})
    stringoutput = "notFond"
    for x in doc:
        stringoutput =str(x)
    if(stringoutput!="notFond"):
        return stringoutput[10:len(stringoutput)-2]
    return stringoutput

def getPassword(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "name": 0, "roll": 0, "salt": 0, "lastname": 0,"email": 0})
    stringoutput = "notFond"
    for x in doc:
        stringoutput = str(x)
    if(stringoutput!="notFond"):
        return stringoutput[14:len(stringoutput)-2]
    return stringoutput

def getRoll(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "name": 0, "salt": 0, "password": 0, "lastname": 0,"email": 0})
    stringoutput="notFond"
    for x in doc:
        stringoutput = str(x)
    if(stringoutput!="notFond"):
        return stringoutput[10:len(stringoutput) - 2]
    return stringoutput

def getName(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "roll": 0, "salt": 0, "password": 0, "lastname": 0,"email": 0})
    stringoutput="notFond"
    for x in doc:
        stringoutput = str(x)
    if(stringoutput!="notFond"):
        return stringoutput[10:len(stringoutput) - 2]
    return stringoutput

def getLastname(db,email):
    col = db["user"]
    doc = col.find({"email": email},{ "_id": 0, "name": 0, "salt": 0, "password": 0, "roll": 0,"email": 0})
    stringoutput="notFond"
    for x in doc:
        stringoutput = str(x)
    if(stringoutput!="notFond"):
        return stringoutput[14:len(stringoutput) - 2]
    return stringoutput

def saveUser(db,name,lastName,roll,salt, password, email):
    col = db["user"]
    dict={"name": name, "lastname":lastName, "roll": roll, "salt": salt, "password": password, "email": email}
    col.insert_one(dict)

def removeUser(db,name,roll,salt, password, lastname):
    col = db["user"]
    query = {"name": name, "lastname": lastname, "roll": roll, "salt": salt, "password": password}
    col.delete_many(query)

def printUsers(db):
    mycol = db["user"]
    lines = "-------------------------------------------------------------------------"
    for x in mycol.find({}, {"_id": 0, "salt": 0, "password": 0}):
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

def checkUsers(db):
    mycol = db["user"]
    counter =0
    for x in mycol.find({}, {"_id": 0, "salt": 0, "password": 0}):
        counter=counter+1
    if(counter==0):
        return False
    else:
        return True

def changeName(db, email, name):
    mycol = db["user"]
    myquery = {"email": email}
    newvalues = {"$set": {"name": name}}

    mycol.update_one(myquery, newvalues)

def changeLastname(db, email, lastname):
    mycol = db["user"]
    myquery = {"email": email}
    newvalues = {"$set": {"lastname": lastname}}

    mycol.update_one(myquery, newvalues)

def changeEmail(db, email, newEmail):
  mycol = db["user"]
  myquery = {"email": email}
  newvalues = {"$set": {"email": newEmail}}

  mycol.update_one(myquery, newvalues)

def changeRoll(db, email, roll):
  mycol = db["user"]
  myquery = {"email": email}
  newvalues = {"$set": {"roll": roll}}

  mycol.update_one(myquery, newvalues)

def changePassword(db, email, password):
  salt = getSalt(db, email)
  pwd = hashFunction(password, salt)
  mycol = db["user"]
  myquery = {"email": email}
  newvalues = {"$set": {"password": pwd}}

  mycol.update_one(myquery, newvalues)

#sign in function class
def checkPass(db, email, password):
    salt=getSalt(db,email)
    checkPwd=hashFunction(password,salt)
    hashedPwd=getPassword(db,email)
    if(checkPwd==hashedPwd):
        return True
    else:
        return False

def hashFunction(password, salt):
    passwordtemp = password + salt
    hashedPassword = hashlib.sha512(passwordtemp.encode('utf-8')).hexdigest()
    return hashedPassword

def makeSalt():
    salt = uuid.uuid4().hex
    return salt

def remove(db,email):
    salt = getSalt(db,email)
    if salt=="notFond":
        return "Not removed"
    roll = getRoll(db,email)
    if roll=="notFond":
        return "Not removed"
    password = getPassword(db,email)
    if password=="notFond":
        return "Not removed"
    name = getName(db,email)
    if name=="notFond":
        return "Not removed"
    lastname = getLastname(db,email)
    if lastname=="notFond":
        return "Not removed"
    removeUser(db, name, roll, salt, password,lastname)
    return name+" removed"

def makeNewUser(db, name, lastName, password, roll, email):
    # check if name is used
    check = getSalt(db, email)
    if check !="notFond":
        return False
    # make salt and hash
    salt = makeSalt()
    hashpassword = hashFunction(password, salt)
    saveUser(db, name,lastName, roll, salt, hashpassword, email)
    return True