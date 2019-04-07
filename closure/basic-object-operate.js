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
// console.log("flight.equipment.model:" + flight.equipment.model);    // 会抛出"TypeError异常类型"
// 表达式计算之后的结果值为Undefined.
// console.log("&& operator避免throw异常类型: " + flight.equipment.model && flight.equipment);

// 4.对于属性的更新可以通过赋值语句来执行,如果属性名已经存在于对象里,那么这个属性的值就会被替换.
stooge['first-name'] = 'Jerome';
// 如果该属性在原有对象中并不存在,则该属性就会被添加到原有队形内部.
stooge['middle-name'] = 'Lester';
// 在js中对象通过引用来进行传递,它们永远都不会被赋值.
var x = stooge;
stooge.nickname = 'Curly';
var nick = x.nickname;  // nick的值为Curly.
// 另外一种类型,a、b、c 3个对象都指向相同的对象.
var a = b = c = {};

// 5.prototype原型属性(每个对象都有一个连接到原型对象),并且它可以从中继承属性.多有对象通过字面量创建的对象都连接到
// Object.prototype,它是Javascript中的标配对象.给Object对象创建一个create()方法,该方法创建一个使用原型对象作为其原型的新对象.
if (typeof Object.beget !== 'function') {
    Object.create = function (o) {
        var F = function () {
        };
        F.prototype = o;
        return new F();
    };
}
var another_stooge = Object.create(stooge);
// 原型链接在更新的时候是不起作用的,当我们对某个对象作出改变的时候,不会触及该对象的原型.
another_stooge['first-name'] = 'Harry';
another_stooge['middle-name'] = 'Moses';
another_stooge.nickname = 'Moe';
console.log('prototype type {stooge.nickname}: ' + stooge.nickname);
// 当给stooge对象设置属性之后,在another_stooge可以通过原型链获取得到该属性.
stooge.prefession = 'actor';
console.log("another_stooge.prefession:" + another_stooge.prefession);

// 6.js也通过类似的reflection机制检查对象的属性值(使用typeof关键字).
typeof flight.number        // 'number'
typeof flight.status        // 'string'
typeof flight.arrival       // 'object'
// 如果是原型链中的对象也会产生值.
typeof flight.toString      // 'function'
typeof flight.constructor   // 'function'
// 如果执行检测对象自身而不去检测原型中的属性值,则可以使用hasOwnProperty方法.
console.log('flight.number property: ' + flight.hasOwnProperty('number'));
console.log('flight.constructor: ' + flight.hasOwnProperty('constructor'));
// 如果要列出对象所有的属性则可以使用for.in来进行遍历;在使用for.in对对象属性进行遍历的时候,对象的属性是不确定的.
// 如果要明确对象属性的值最好使用数组的形式进行表示,对象的属性作为数组的元素通过for循环从中取出元素.
var name;
for (name in another_stooge) {
    if (typeof another_stooge[name] !== 'function') {
        console.log(name + ":" + another_stooge[name]);
    }
}
var i;
var properties = ['first-name', 'middle-name', 'last-name', 'profession'];
for (i = 0; i < properties.length; i++) {
    console.log(properties[i] + ": " + another_stooge[properties[i]]);
}
// delete运算符可以删除对象的某属性,如果对象包含有该属性那么该属性就会被移除,它不会触及原型链中的任何对象
// (如果对象的属性被删除,如果原型链中包含有同名属性,则会显示同名属性的值).
delete another_stooge.nickname
console.log('delete another_stooge.nickname: ' + another_stooge.nickname);

/**
 * 比较好的建议:减少全局变量污染(global abatement)
 * javascript可以很随意地定义全局变量来容纳你的应用程序的所有资源,遗憾的是全局变量削弱了程序的灵活性,应避免使用。
 * 只要把全局性的资源都纳入一个名称空间之下,你的应用程序与其他应用程序、组件和类库之间发生冲突的可能性就会显著降低。
 * 你的应用程序变得更易阅读,因为很明显.我们会看到使用必报来进行信息隐藏的方式,是一种有效减少全局污染的方法.
 * */
var MYAPP = {};
MYAPP.stooge = {
    'first-mame': "Joe",
    "last-name": "Howard"
};
MYAPP.flight = {
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