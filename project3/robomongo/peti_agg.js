db.arts.aggregate([
    {$group: {_id: "$product/productId", product_prices: {$addToSet: "$product/price"}}},
    {$match: {"product_prices.1": {$exists: true}}},
    //{$count: "cntAll"}
]) .forEach(product => 
       db.arts.remove({"product/productId": product._id})
   )