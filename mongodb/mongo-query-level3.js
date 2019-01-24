/**
 * 1. mongodb query cursor
 */
var cursor = db.getCollection('record').find();
// iterator cursor by hasNext() and next() method
while(cursor.hasNext()) {
    print(cursor.next());
}

// only want some field
while(cursor.hasNext()) {
    print(cursor.next().companyId);
}

// use Javascript iterator interface
cursor.forEach(function(item) {print(item);});

/**
 * cursor limit() && skip() && sort() method
  */
var cursorLimit = db.getCollection('record').find().limit(3);
// fetch range records
var cursorSkip = db.getCollection('record').find().skip(2).limit(4);
// sort by target field {targetField: negative desc}
var cursorSort = db.getCollection('record').find().sort({companyId:-1});


/**
 * 2. mongodb pipeline operator
 */
db.getCollection('record').aggregate([{$match:{'companyId':'c79e289a33d1b80c8c92c422a7cf8c6b'}}]);

// mongodb $project
db.getCollection('record').aggregate([{$project:{_id:1, companyId:0}}]);
// return special field
db.getCollection('record').aggregate([{$project:{'_id':0, 'companyZsid':1}}]);

/*{
    "_id" : ObjectId("59f841f5b998d8acc7d08863"),
    "orderAddressL" : "ShenZhen",
    "prodMoney" : 45.0,
    "freight" : 13.0,
    "discounts" : 3.0,
    "orderDate" : ISODate("2017-10-31T09:27:17.342Z"),
    "prods" : [
    "可乐",
    "奶茶"
    ]
}*/
// mongodb mathematical expression
db.getCollection('cup').aggregate([{$project:{totalMoney:{$add:['$prodMoney','$freight']}}}]);

// minus expression
db.getCollection('cup').aggregate([{$project:{totalPay:{$subtract:[{$add:['$prodMoney','$freight']},'$discounts']}}}]);

// $multiply $divide && $mod
db.getCollection('cup').aggregate([{$project:{result:{$multiply:['$prodMoney', '$freight', '$discounts']}}}]);

db.getCollection('cup').aggregate([{$project:{result:{$divide:['$prodMoney', '$freight']}}}]);

db.getCollection('cup').aggregate([{$project:{result:{$mod:['$prodMoney', '$freight']}}}]);

/**
 * date expression
 */
db.sang_collect.aggregate({$project:{
    "year":{$year:"$orderDate"},
    "month":{$month:"$orderDate"},
    "week of year":{$week:"$orderDate"},
    "date":{$dayOfMonth:"$orderDate"},
    "week":{$dayOfWeek:"$orderDate"},
    "day of year":{$dayOfYear:"$orderDate"},
    "hour":{$hour:"$orderDate"},
    "minute":{$minute:"$orderDate"},
    "seconds":{$second:"$orderDate"},
    "millius":{$millisecond:"$orderDate"},
    "custom date":{$dateToString:{format:"%Y year %m month %d %H:%M:%S",date:"$orderDate"}}}});

/**
 * string expression
 */
db.getCollection('cup').aggregate([{$project:{substr:{$substr:['$orderAddressL', 0, 4]}}}]);

db.getCollection('cup').aggregate([{$project:{concat:{$concat:['$orderAddressL', {$dateToString:{format:'%Y-%m-%d', date:'$orderDate'}}]}}}]);

db.getCollection('cup').aggregate([{$project:{lowercase:{$toLower:'$orderAddressL'}}}]);

/**
 * logical expression
 */
db.getCollection('cup').aggregate([{$project:{compare:{$cmp:['$freight', '$prodMoney']}}}]);

db.getCollection('cup').aggregate([{$project:{result:{$and:[{'$eq':['$freight', '$prodMoney']}, {'$eq':['$freight', '$discounts']}]}}}]);

// $cond && $ifNull
db.getCollection('cup').aggregate([{$project:{condition:{$cond:[false, 'true expre', 'false expre']}}}]);

// $ifNull expression
db.getCollection('cup').aggregate([{$project:{ifCondtion:{$ifNull: [null, 'not null']}}}]);

db.getCollection('record').find({'beneficiary':{$elemMatch:{invtype:'', invtype_desc:''}}});


/**
 * 3.MongoDB pipeline operator
 */
db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', count:{$sum: 1}}}]);

// calculate total $freight price
db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', totalFreight:{$sum:'$freight'}}}]);

// calculate average $freight price
db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', avgFreight:{$avg:'$freight'}}}]);

// most expensive freight price
db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', maxFreightPrice:{$max:'$freight'}}}]);

// most cheapest freight price
db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', minFreightPrice:{$min:'$freight'}}}]);

// group by $orderAddressL, find first order
db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', firstFreight:{$first:'$freight'}}}]);

// group by $orderAddressL, find last $freight record
db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', lastFreight:{$last:'$freight'}}}]);

/**
 * $group by $orderAddressL, add to set(Remove duplicate data) or list
 */
db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', freights:{$addToSet:'$freight'}}}]);

db.getCollection('cup').aggregate([{$group: {_id:'$orderAddressL', freights:{$push:'$freight'}}}]);

/**
 * $unwind operate
 */
db.getCollection('record').aggregate([{$unwind: '$sourceData.data.nodes'}]);

/**
 * $sort operate
 */
db.getCollection('record').aggregate([{$sort: {'_id': 1}}]);

// sort by project field
db.getCollection('cup').aggregate([{$project:{address:'$orderAddressL'}}, {$sort:{address:1}}]);

// limit mongodb record
db.getCollection('cup').aggregate([{$project:{address:'$orderAddressL'}}, {$limit:3}]);

// mongodb page query, skip 2 record
db.getCollection('cup').aggregate([{$project:{address:'$orderAddressL'}}, {$skip:2}]);

/**
 * 4. mongodb index
 */
db.getCollection('record').getIndexes();
// mongoDB create index
db.getCollection('record').ensureIndex({'companyId':1});

// find all indexes [totalIndexSize]
db.getCollection('record').totalIndexSize();
// delete mongodb index
db.getCollection('record').dropIndexes();
// delete target mongodb index
db.getCollection('record').dropIndex('companyId');

