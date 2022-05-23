db.products.aggregate([
    //{$match: { $text: { $search: "wonderful"}}},
    {$match: {"reviews.text": {$regex: "wonderful"}}},
    {$match: {"reviewStats.reviewsCount": {$gte: 200}}},
    {$match: {"reviewStats.avgReviewScore": {$gte: 4.5}}},
    {$match: {price: {$gt: 20}}}
])