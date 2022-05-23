db.products.aggregate([
    {$project: {
            _id: 1, title: 1, 
            numOfReviews: {$size: "$reviews"}
        }
    }, 
    {$facet: //starta dva pipelinea
        {"10mostReviews": [{$sort: {numOfReviews: -1}},
                           {$limit: 10}],
         "10leastReviews": [{$sort: {numOfReviews: 1}},
                            {$limit: 10}]              
        }
    }
])