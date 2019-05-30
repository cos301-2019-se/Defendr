import pymongo
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


