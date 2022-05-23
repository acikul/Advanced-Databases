db.products.aggregate([
    {$addFields: {
            reviewStats: {
                    avgReviewScore: {$avg: "$reviews.score"},
                    reviewsCount: {$size: "$reviews"},
                    reviewScoreDistrib: {
                            "1": {$size: {$filter: {input: "$reviews.score", as: "score", cond: {$eq: ["$$score", 1]}}}},
                            "2": {$size: {$filter: {input: "$reviews.score", as: "score", cond: {$eq: ["$$score", 2]}}}},
                            "3": {$size: {$filter: {input: "$reviews.score", as: "score", cond: {$eq: ["$$score", 3]}}}},
                            "4": {$size: {$filter: {input: "$reviews.score", as: "score", cond: {$eq: ["$$score", 4]}}}},
                            "5": {$size: {$filter: {input: "$reviews.score", as: "score", cond: {$eq: ["$$score", 5]}}}}
                        }
                }
        }
    },
    {$out: "products"}
])