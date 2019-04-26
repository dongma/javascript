/**
 * map函数会对(cgzb>=30%)的受益人进行emit
 */
var map = function () {
    // 1.获取主体企业的唯一标识符、企业的名称
    var companyZsid = this.companyZsid;
    var companyName = this.companyName;

    // 2.获取受益人(full-data-branch)中受益人结点[人员节点type=2]
    var nodesList = this.data.nodes;
    for (var i = 0; i < nodesList.length; i++) {
        // 对于最终结果只需要人员节点[PERSON = 2]
        if (nodesList[i].type !== 2) {
            continue;
        }

        var properties = nodesList[i].properties;
        // 对投资关系受益人进行emit(cgzb >= 30%并且 isSYR=true)
        if (properties['isSYR'] !== undefined && properties['isSYR'] === "true") {
            // 获取受益人的cgzb属性值,并将其中大于30%的数据进行emit
            if (properties['cgzb'] !== undefined && properties['cgzb'].trim() !== '') {
                var cgzbValue = parseFloat(properties['cgzb']);
                if (cgzbValue >= 30) {
                    // 获取人员的个人标识码(唯一标识)作为分组标识
                    var palgorithmid = properties['palgorithmid'];
                    // 组装要进行emit的数据,其中包括{companyId, companyName, palgorithmid, personName}
                    var item = {
                        "palgorithmid": palgorithmid,
                        "beneficiaryName": nodesList[i].name,
                        "totalInv": cgzbValue,
                        "companyZsid": companyZsid,
                        "companyName": companyName
                    };
                    emit(palgorithmid, {data: [item]});
                }
            }
        }
    }
};

/**
 * reduce函数主要用于对根据个人标识码分类后的数组进行组合
 * */
var reduce = function (key, values) {
    var result = {data: []};
    for (var i = 0; i < values.length; i++) {
        result.data.push(values[i].data[0]);
    }
    return result;
};

/***
 * 定义finalize函数对归类后的数据进行过滤.
 * 用于指定过滤分类结果的筛选条件(data数量大于2)
 */
var finalize = function(key, result) {
    if (result.data.length >= 3) {
        return result;
    }
};

/**
 * 定义map-reduce分类统计,out指定聚合结果在mongo中的表名.
 * mention:对于finalize方法，其并不能在内部过滤掉不符合条件的reduce结果, 如果不返回默认会使用null进行替代.
 * @see https://stackoverflow.com/questions/18062351/mongodb-map-reduce-finalize-to-skip-some-results
 * */
var options = {
    out: "statistic_over30_beneficiary",
    finalize: finalize
};


// 对数据库中所有的受益人记录进行map-reduce操作
db.beneficiary.mapReduce(map, reduce, options);

// 查找受益人全量mongo库中,Node节点cgzb属性不为空的记录
db.beneficiary.find({"data.nodes": {$elemMatch: {"properties.cgzb": {$nin: ["", null]}}}}).limit(40);
