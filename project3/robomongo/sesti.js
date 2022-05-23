db.arts.aggregate([
    {$group: {
            _id: "$product/productId",
            title: {$first: "$product/title"},
            price: {$first: "$product/price"},
            
            reviews: {$addToSet: {
                    helpfulness: "$review/helpfulness",
                    profileName: "$review/profileName",
                    score: "$review/score",
                    summary: "$review/summary",
                    text: "$review/text",
                    time: "$review/time",
                    userId: "$review/userId"
                }}
        }
    },
    {$out: {db: "projekt3", coll: "products"}}
])