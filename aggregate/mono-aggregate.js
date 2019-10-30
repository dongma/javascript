/**
 * 1.mongodb Aggregate pipeline
 * */
db.orders.aggregate([
    {"$match": {status: "A"}},      // stage 1: $match stage
    {"$group": {_id: "$cust_id", total:{$sum:"$amount"}}}   // stage2: $group stage
]);

// $addFields to add additional field, and using $size to calculate array.length
db.getCollection('books').aggregate([
    {$match: {_id: ObjectId("5c3cc6ce17ed628e68719072")}},
    {$addFields: {length: {$size:'$books'}}},
    // could not $project array object
    {$project : {_id: 0, length: 1}}
]);

db.getCollection('books').aggregate([
    {$sort: {_id: -1}},
    // the books.length is 3 <match all elements>
    {$match: {"books": {$size: 3}}},
    // limit the result of total size
    {$limit: 2}
]);

// $group mongodb fields with multiple field, relevant sql: [select * from monitor_entlist group by userId, uid]
db.getCollection('monitor_entlist').aggregate([{$group:{_id :{"uid":"$UID", "userId":"$USERID"}}}]);