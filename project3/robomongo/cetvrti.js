db.arts.find({"review/score": 1.0}, {_id: 0, "product/title": 1, "product/price": 1, "review/time":1})
       .skip(db.arts.count({"review/score": 1.0})-20)
       .limit(10)
       .sort({"review/time":-1, _id:1})