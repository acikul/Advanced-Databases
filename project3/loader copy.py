import datetime
import pymongo
import pprint
import datetime
from pymongo import MongoClient

#____________________________________________________________________________

f = open('/Users/Luka/Desktop/diplomski1/nbp/projekt3/Arts.txt', 'r')

docList = []
tempDoc = {}

for line in f:
	if line.startswith("product/productId"):
		tempDoc["product_productId"] = line.lstrip("product/productId:").strip()
	elif line.startswith("product/title"):
		tempDoc["product_title"] = line.lstrip("product/title:").strip()
	elif line.startswith("product/price"):
		price = line.lstrip("product/price:").strip()
		if (price != "unknown"): price = float(price)
		tempDoc["product_price"] = price
	elif line.startswith("review/userId"):
		tempDoc["review_userId"] = line.lstrip("review/userId:").strip()
	elif line.startswith("review/profileName"):
		tempDoc["review_profileName"] = line.lstrip("review/profileName:").strip()
	elif line.startswith("review/helpfulness"):
		tempDoc["review_helpfulness"] = line.lstrip("review/helpfulness:").strip()
	elif line.startswith("review/score"):
		tempDoc["review_score"] = float(line.lstrip("review/score:").strip())
	elif line.startswith("review/time"):
		time = float(line.lstrip("review/time:").strip())
		tempDoc["review_time"] = datetime.datetime.fromtimestamp(time)
	elif line.startswith("review/summary"):
		tempDoc["review_summary"] = line.lstrip("review/summary:").strip()
	elif line.startswith("review/text"):
		tempDoc["review_text"] = line.lstrip("review/text:").strip()
	elif line == "\n":
		docList.append(tempDoc)
		tempDoc = {}
f.close()

#____________________________________________________________________________


client = MongoClient(username='root', password='rootnmbp')

db = client["projekt3"]

collection = db["arts2"]

result = collection.insert_many(docList)
print(result.inserted_ids)

pprint.pprint(collection.find_one())
