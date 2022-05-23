db.arts2.mapReduce (
        `function() {
                emit(this.product_productId, this.product_price)
            };`,
        `function(key, values) {
            return values
        };`,
        {   out: "mr_arts",
            finalize: `function(key, reducedValue) {
                reducedValue = reducedValue.filter(rv => rv.length>1)
            };`
        }
);