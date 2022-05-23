db.arts.aggregate([
    {$match: {"product/price": "unknown"}},
    {$group: {_id: "$product/productId"}},
    {$count: "numNoPrice"}
])