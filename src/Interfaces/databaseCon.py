import pymongo
import hashlib, uuid
import urllib.parse

def addIp(db,ip):
    col = db["blacklist"]
    data = {"adress": ip}
    col.insert_one(data)

def connect():
    mongo_uri = "mongodb+srv://darknites:" + urllib.parse.quote("D@rkN1t3s") + "@defendr-1vnvv.azure.mongodb.net/test?retryWrites=true"
    client = pymongo.MongoClient(mongo_uri)
    db = client["Defendr"]
    return db

def findPackets(db, ip):
    col = db["packets_list"]
    if ip=="":
        doc=col.find({},{"_id": 0}).sort("timestamp", -1)
    else:
        query = {"ip_source": ip}
        doc = col.find(query,{ "_id": 0}).sort("timestamp", -1)
    return doc

def getSalt(db,name):
    col = db["user"]
    doc = col.find({"name": name},{ "_id": 0, "name": 0, "roll": 0, "password": 0})
    stringoutput = "notFond"
    for x in doc:
        stringoutput =str(x)
    if(stringoutput!="notFond"):
        return stringoutput[10:len(stringoutput)-2]
    return stringoutput

def getPassword(db,name):
    col = db["user"]
    doc = col.find({"name": name},{ "_id": 0, "name": 0, "roll": 0, "salt": 0})
    stringoutput = "notFond"
    for x in doc:
        stringoutput = str(x)
    if(stringoutput!="notFond"):
        return stringoutput[14:len(stringoutput)-2]
    return stringoutput

def getRoll(db,name):
    col = db["user"]
    doc = col.find({"name": name},{ "_id": 0, "name": 0, "salt": 0, "password": 0})
    stringoutput="notFond"
    for x in doc:
        stringoutput = str(x)
    if(stringoutput!="notFond"):
        return stringoutput[10:len(stringoutput) - 2]
    return stringoutput

def saveUser(db,name,roll,salt, password):
    col = db["user"]
    dict={"name": name, "roll": roll, "salt": salt, "password": password}
    col.insert_one(dict)

def removeUser(db,name,roll,salt, password):
    col = db["user"]
    query = {"name": name, "roll": roll, "salt": salt, "password": password}
    col.delete_one(query)

def printUsers(db):
    mycol = db["user"]
    lines = "---------------------\n"
    for x in mycol.find({}, {"_id": 0, "salt": 0, "password": 0}):
        temp = str(x)
        name = temp.split('\'')[3]
        if (len(name) < 7):
            name = name + '\t'
        roll = temp.split('\'')[7]
        lines = lines + "|" + name + "\t|" + roll + "\t|" + '\n'
    lines = lines + "---------------------"
    return lines

#sign in function class
def checkPass(db, name, password):
    salt=getSalt(db,name)
    checkPwd=hashFunction(password,salt)
    hashedPwd=getPassword(db,name)
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

def remove(db,name):
    salt = getSalt(db,name)
    if salt=="notFond":
        return name + " not removed"
    roll = getRoll(db,name)
    if roll=="notFond":
        return name+" not removed"
    password = getPassword(db,name)
    if password=="notFond":
        return name+" not removed"
    removeUser(db, name, roll, salt, password)
    return name+" removed"

def makeNewUser(db, name, password, roll):
    # check if name is used
    check = getSalt(db, name)
    if check !="notFond":
        return name+" is an use"
    # make salt and hash
    salt = makeSalt()
    hashpassword = hashFunction(password, salt)
    saveUser(db, name , roll, salt, hashpassword)
    return name+" succefully added"
