/**
 * mongodb aggregation data
 */
db.createCollection('zipcodes');
db.zipcodes.insertOne({"_id": "10280", "city": "NEW YORK", "state": "NY", "pop": 5574, "loc": [-74.016323, 40.710537]});

/**
 * 1. return all states with total population greater than 10 million
 */
db.getCollection('zipcodes').aggregate([
    {$group: {_id: '$state', totalPop: {$sum: '$pop'}}},
    {$match: {totalPop: {$gte: 5500}}}
]);

/**
 * 2.return the average populations for cities in each state
 */
db.getCollection('zipcodes').aggregate([
    {$group: {_id: {state: "$state", city: "$city"}, pop: {$sum: "$pop"}}},
    {$group: {_id: '$_id.state', avgPop: {$avg: '$pop'}}}
]);

/**
 * 3.return largest cities and smallest cities by state
 */
db.getCollection('zipcodes').aggregate([
    {$group: {_id: {state: "$state", city: "$city"}, pop: {$sum: '$pop'}}},
    {$sort: {pop: 1}},
    {$group: {_id: "$_id.state", biggestCity:{$last: "$_id.city"}, biggestPop:{$last: "$pop"}, smallestCity:{$first: "$_id.city"}, smallestPop:{$first: "$pop"}}},
    {
        $project:{
            "_id": 0,
            "state": "$_id",
            biggestCity: {name:"$biggestCity", pop:"$biggestPop"},
            smallestCity: {name:"$smallestCity", pop:"$smallestPop"}
        }
    }
]);

/**
 * mongodb users aggregation [name: users]
 */
db.createCollection('users');

/**
 * 4.find all users name(Uppercase), sort by name in alphabetical order
 */
db.getCollection('users').aggregate([
    {$project: {name:{$toUpper:'$_id'}, _id: 0}},
    {$sort: {name:1}}
]);

/**
 * 5.return username ordered by join month
 */
db.getCollection('users').aggregate([
    {$project: {name: '$_id', month_joined:{$month:'$joined'}, _id:0}},
    {$sort: {'month_joined': 1}}
]);

/**
 * 6. return total number of joins per month
 */
db.getCollection('users').aggregate([
    {$project:{month_joined:{$month:'$joined'}}},
    {$group: {_id: {month_joined:'$month_joined'}, number:{$sum:1}}},
    {$sort: {'_id.month_joined': 1}}
]);

/**
 * 7.return five most common 'likes'
 */
db.getCollection('users').aggregate([
    {'$unwind': '$likes'},
    {$group: {_id:'$likes',number:{$sum:1}}},
    {$sort: {number:-1}},
    {$limit: 5}
]);
