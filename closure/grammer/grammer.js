/**
 * Created by dong on 18/5/14.
 */

// 对于空格开说,var于that之间的空格是不能够被省略的.
// 分析原因为var为关键字,当省略中间的空格,关键字不能够解析为正常的语法.
var that = this;

/** 1.注释部分:
 *  >javascript语言提供了两种注释的格式:
 *      第一种是以"//"表示的单行注释. 第二种是以两个反斜线和*拼接起来的多行注释.
 *  > javascript基本的数据类型为: 数字、字符串、布尔值(true or false)、null、undefined(这5种基本的数据类型).
 *  其它的都是对象,当然也包括函数function、正则表达式regex和数组array也是对象.
 *  javascript包含一种原型链的特性,允许对象继承另一个对象的属性(正确的使用能够减少初始化使用的内存和时间).
 */
var stooge = {
    // warning: 对于对象字面量来说,如果属性名是一个合法的Javascript标识符而且不是保留字,则并不强制要求用引号括住
    // 属性名.但是对于"first-name"必须使用引号进行修饰,因为"-"在javascript中变量的命名规范中是不合法的.
    "first-name": "jerome",
    "last-name": "howard"
};
// 在console.log()中输出的是对象类型[Object object]
console.log("first-name attribute: " + stooge["first-name"])

// 2.属性的值尅从包括另一个对象字面量在内的任意表达式中获得.
var flight = {
    airline: "Oceanic",
    number: 815,
    departure: {
        IATA: "SYD",
        time: "2004-09-22 14:55",
        city: "Sydney"
    },
    arrival: {
        IATA: "LAX",
        time: "2004-09-22 10:42",
        city: "los angeles"
    }
};

// 3.检索retrieval,从对象里面读取出给定属性的值;如果对象的属性不是由规范的命名规范组成,
// 则必须使用[]来获取得到其属性值;当其符合单词的命名规范时候,在属性内部可以进行执行的引用.
console.log("stooge[\"first-name\"]: " + stooge["first-name"]);
console.log("flight.departure.IATA:" + flight.departure.IATA)
// 返回undefined
console.log("undefined value: " + stooge["middle-name"]);
console.log("undefined value: " + flight.status);
// 一个比较好的技巧是可以使用"||"对对象填充默认值.
var status = flight.status || "unknown";
console.log("status value: " + status);
// 从undefined属性中进行读取property会返回TypeError异常类型.可以通过&&运算符来避免错误.
console.log("flight.equipment:" + flight.equipment);    // 返回的值为undefined.
console.log("flight.equipment.model:" + flight.equipment.model);    // 会抛出"TypeError异常类型"
// 表达式计算之后的结果值为Undefined.
console.log("&& operator避免throw异常类型: " + flight.equipment.model&&flight.equipment);
