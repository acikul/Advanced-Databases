db.products.aggregate([
    {$unwind: "$reviews"},
    {$match: {"reviews.userId": {$ne: "unknown"}}},
    {$group: {_id: "$reviews.userId", numOfReviews: {$sum: 1}}},
    {$sort: {numOfReviews: -1}},
    {$group: {
            _id: null,
            topReviewer: {$first: "$$ROOT"},
            worstReviewer:  {$last: "$$ROOT"}
        }}
])