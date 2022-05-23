db.products.find(
    {"reviewStats.reviewsCount": {$gte: 200},
     "reviewStats.avgReviewScore": {$gte: 4.5},
     price: {$gt: 20},
     
    }
)