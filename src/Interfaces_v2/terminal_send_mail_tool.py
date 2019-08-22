from emailSender import email
from databaseCon import database
import sys

database = database()
db_connection = database.connect()
smpt = email()
smpt_connection = smpt.connectToSMTPserver()

smpt.emailForAttack(db_connection,database,smpt_connection,sys.argv[1])