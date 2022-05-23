import datetime
import pymongo
import pprint
import datetime
from pymongo import MongoClient

#____________________________________________________________________________

f = open('Arts.txt', 'r')

docList = []
tempDoc = {}

for line in f:
	if line.startswith("product/productId"):
		tempDoc["product/productId"] = line.lstrip("product/productId:").strip()
	elif line.startswith("product/title"):
		tempDoc["product/title"] = line.lstrip("product/title:").strip()
	elif line.startswith("product/price"):
		price = line.lstrip("product/price:").strip()
		if (price != "unknown"): price = float(price)
		tempDoc["product/price"] = price
	elif line.startswith("review/userId"):
		tempDoc["review/userId"] = line.lstrip("review/userId:").strip()
	elif line.startswith("review/profileName"):
		tempDoc["review/profileName"] = line.lstrip("review/profileName:").strip()
	elif line.startswith("review/helpfulness"):
		tempDoc["review/helpfulness"] = line.lstrip("review/helpfulness:").strip()
	elif line.startswith("review/score"):
		tempDoc["review/score"] = float(line.lstrip("review/score:").strip())
	elif line.startswith("review/time"):
		time = float(line.lstrip("review/time:").strip())
		tempDoc["review/time"] = datetime.datetime.fromtimestamp(time)
	elif line.startswith("review/summary"):
		tempDoc["review/summary"] = line.lstrip("review/summary:").strip()
	elif line.startswith("review/text"):
		tempDoc["review/text"] = line.lstrip("review/text:").strip()
	elif line == "\n":
		docList.append(tempDoc)
		tempDoc = {}
f.close()

#____________________________________________________________________________


client = MongoClient(username='root', password='rootnmbp')

db = client["projekt3"]

collection = db["arts"]

result = collection.insert_many(docList)

print(result.inserted_ids)
pprint.pprint(collection.find_one())
