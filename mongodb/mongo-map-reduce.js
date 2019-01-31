db.getCollection('articles').find({})

db.articles.insertMany([
    {"_id" : ObjectId("59fa71d71fd59c3b2cd908d7"),"name" : "鲁迅","book" : "呐喊","price" : 38.0,"publisher" : "人民文学出版社"},
    {"_id" : ObjectId("59fa71d71fd59c3b2cd908d8"),"name" : "曹雪芹","book" : "红楼梦","price" : 22.0,"publisher" : "人民文学出版社"},
    {"_id" : ObjectId("59fa71d71fd59c3b2cd908d9"),"name" : "钱钟书","book" : "宋诗选注","price" : 99.0,"publisher" : "人民文学出版社"},
    {"_id" : ObjectId("59fa71d71fd59c3b2cd908da"),"name" : "钱钟书","book" : "谈艺录","price" : 66.0,"publisher" : "三联书店"},
    {"_id" : ObjectId("59fa71d71fd59c3b2cd908db"),"name" : "鲁迅","book" : "彷徨","price" : 55.0,"publisher" : "花城出版社"}
]);

// 1.map-reduce实现,按照author查询其书籍的总价格.
var map = function(){emit(this.name, this.price)};
var reduce = function(key, value){return Array.sum(value)};
var options = {out: 'totalPrice'}
db.articles.mapReduce(map, reduce, options);
db.totalPrice.find();

// 2.map-reduce实现,统计每位作者书目的数量
var map = function() {emit(this.name, 1)};
var reduce = function(key, value){return Array.sum(value)};
var options = {out: 'booknums'};
db.articles.mapReduce(map, reduce, options);
db.booknums.find();

// 3.map-reduce实现,列出每位作者的书籍
var map = function(){emit(this.name, this.book)};
var reduce = function(key, value) {return value.join(',')};
var option = {out: 'books'};
db.articles.mapReduce(map, reduce, option);
db.books.find();

// 4.map-reduce实现,查询每个人售价在40元以上的书籍
var map = function(){emit(this.name, this.book)};
var reduce = function(key, value){return value.join(',')};
var option = {query:{price: {$gt : 40}}, out:'books'};
db.articles.mapReduce(map, reduce, option);
db.books.find();

// 5.使用runcommand的方式执行map-reduce
var map = function(){emit(this.name, this.book)};
var reduce = function(key, value){return value.join(',')};
db.runCommand({mapReduce:'articles', map:map, reduce:reduce, out:'books', limit:4, verbose:true});
db.books.find();

// 6.map-reduce中finalize函数的使用
var finalize = function(key, reduceResult){var obj={}; obj.author=key; obj.books=reduceResult; return obj;}
var map=function() {emit(this.name, this.book)};
var reduce=function(key,value){return value.join(',')};
db.runCommand({mapReduce:'articles', map:map, reduce:reduce, out:'books', finalize:finalize});
db.books.find();

// 7.map-reduce中的scope属性使用
var finalize = function(key, reduceResult){var obj={}; obj.author=key; obj.books=reduceResult; obj.node=newyork; return obj;}
var map=function() {emit(this.name, this.book)};
var reduce=function(key,value){return value.join('#'+ newyork +'#')};
db.runCommand({mapReduce:'articles', map:map, reduce:reduce, out:'books', finalize:finalize, scope:{newyork:"newyork"}});
db.books.find();

//  8.使用$group统计invtype类型
db.getCollection('record').aggregate([
    {$unwind: "$sourceData.data.nodes"},
    {$group: {_id:'$properties.invtype', num_of_invtype:{$sum:1}}}
]);

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
            emit(property['invtype'], 1);
        }
    }

    // resolve beneficiary node
    var beneficiaryList = this.beneficiary;
//     emit(this._id, beneficiaryList);
    if(beneficiaryList != undefined) {
        for(var i = 0; i < beneficiaryList.length; i++) {
            emit(beneficiaryList[i].invtype, 1);
        }
    }
};
var reduce = function(key, value) {
    return {'key':key, 'value': value.length };
};

/*var reduce = function(key, value) {
    return Array.sum(value);
};*/
var options = {out: 'invtypes'};
db.record.mapReduce(map, reduce, options);