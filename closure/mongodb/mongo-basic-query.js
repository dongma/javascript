// 1.mongo中最简单的查询操作
db.articles.find({name:'鲁迅'},{'name':1, '_id':0});

// 2.查找成绩不为90分的学生
db.score.find({score: {$ne:90}});

// 3.$in & $nin operator
db.score.find({score: {$in:[90,80]}});
db.score.find({score: {$nin:[100, 70]}});

// 4.$or & $type operator(double value type)
db.score.find({$or: [{score:90},{score:100}]});
db.score.find({score: {$type:1}});

// 5. $not && $and operator
db.score.find({score: {$not:{$type:1}}});
db.score.find({$and: [{score:{$gt:98}},{score:{$let:100}}]});
// another usage $and operator
db.score.find({score: {$gte:90, $lte:100}});

// 6.mongo中集合的备份(Robo 3T中使用)
db.createCollection('articles_20180114');
db.articles.find().forEach(function(article) {
    db.articles_20180114.insert(article);
});

/**
 * mongodb query part2:
 */
// 7.mongodb null query condition.
db.articles.find({name:null}); // (will find all result)
// add exist filter(only when field exist)
db.articles.find({flag:{$in:[null], $exists:true}});

// 8.mongodb query regex expression
db.articles.find({name:/^(hello)(.[a-zA-Z0-9])+/i});

// 9.mongodb array query
db.books.find({'books':'三国演义'});
// $all in array query
db.books.find({'books':{$all:['三国演义', '红楼梦']}});
// match exactly
db.books.find({'books':["三国演义","红楼梦", "水浒传"]});
// match array postion element
db.books.find({'books.2':'红楼梦'});
// match array length == 3
db.books.find({'books': {$size:3}});
// mongodb slice operate
db.books.find({},{books:{$slice:2}});

// 10.mongo value scope
db.books.find({x:{$lt:20, $gt:10}});
// $elemMatch
db.books.find({x:{$elemMatch:{$lt:20, $gt:10}}});

// 11.innner document query
db.books.find({"y.z":2, "y.x":5});

// 9.使用map-reduce统计invtype类型
var map = function() {
    var sourceData = this.sourceData;
    var nodesList = sourceData.data.nodes;
//     emit(this._id, nodesList);

    for(var i=0; i<nodesList.length; i++) {
//         emit(this._id, nodesList[i]);
        var property = nodesList[i].properties;
//         emit(this._id, property);
        if(property['invtype'] != undefined && property['invtype_desc'] != undefined) {
            emit(property['invtype'], this._id);
        }
    }

    // resolve beneficiary node
    var beneficiaryList = this.beneficiary;
//     emit(this._id, beneficiaryList);
    if(beneficiaryList != undefined) {
        for(var i = 0; i < beneficiaryList.length; i++) {
            emit(beneficiaryList[i].invtype, this._id);
        }
    }
};

/**
 * @param key :field which to group by
 * @param values :array contains group field
 * @returns {{key: *, value: *}}
 */
var reduce = function(key, values) {
    return {'key':key, 'value': values.join(',')};
};

var recuce_v2 = function(key, values) {
    var uniqueArr = [];
    return values.join(',');
};
var options = {out: 'invtypes'};
db.record.mapReduce(map, reduce, options);

// statistic node which invtype:"88"(mongoDB, #elemMatch)
db.getCollection('record').find({'sourceData.data.nodes':{$elemMatch:{'properties.invtype':'88'}}});
db.getCollection('record').find({'beneficiary':{$elemMatch:{invtype:'88'}}});

db.getCollection('record').find({'beneficiary':{$elemMatch:{invtype:'',invtype_desc:''}}, 'sourceData.data.nodes':{$elemMatch:{'properties.invtype':'','properties.invtype_desc':''}}});

// beneficiary exist empty, or sourceData.data.nodes exist empty
db.getCollection('record').find({$or: [
        {'beneficiary':{$elemMatch:{invtype:'',invtype_desc:''}}},
        {'sourceData.data.nodes':{$elemMatch:{'properties.invtype':'','properties.invtype_desc':''}}}
    ]
});