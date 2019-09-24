from emailSender import email
from databaseCon import database
import sys

database = database()
db_connection = database.connect()
smpt = email()
smpt_connection = smpt.connect_To_SMTP_server()

smpt.email_for_attack(db_connection,database,smpt_connection,sys.argv[1])
