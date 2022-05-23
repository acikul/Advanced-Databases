import datetime
import pymongo
import pprint
import datetime
from pymongo import MongoClient


client = MongoClient(username='root', password='rootnmbp')

db = client["projekt3"]
#db.drop_collection('firstInsert')

collection = db["firstInsert"]

print(collection.count_documents({}))

pprint.pprint(db.command("collstats", "arts"))
