import pymongo
import urllib.parse

def addIp(db,ip):
    col = db["blacklist"]
    data = {"Adress": ip}
    col.insert_one(data)

def connect():
    mongo_uri = "mongodb+srv://darknites:" + urllib.parse.quote("D@rkN1t3s") + "@defendr-1vnvv.azure.mongodb.net/test?retryWrites=true"
    client = pymongo.MongoClient(mongo_uri)
    db = client["Defendr"]
    return db

def findPackets(db, ip):
    col = db["packets_list"]
    query = {"Ip_source": ip}
    doc = col.find(query,{ "_id": 0,"Server":0,"Ip_destination":0}).sort("Timestamp", -1)
    return doc


