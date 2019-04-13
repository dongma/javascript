/**
 * function.apply(thisArg, argArray)
 * */
// apply方法调用function,传递一个会被绑定到this上的对象和一个可选的数组作为参数,
// apply方法被调用在apply调用模式(apply invocation pattern)中.
/*Function.method('bind', function(that) {
    // 返回一个函数,调用这个函数就像调用那个对象的一个方法.
    var method = this,
        slice = Array.prototype.slice,
        args = slice.apply(arguments, [1]);
    return function() {
        return method.apply(that, args.concat(slice.apply(arguments, [0])));
    };
});*/

var bindFunction = function() {
    return this.value;
}.bind({value: 666});

console.log("bind function: [ " + bindFunction() + " ]");

/**
 * Number常用函数:
 * number.toExponential(fractionDigits)
 * */
console.log("Math.PI.toExponential(0): [ " + Math.PI.toExponential(0) + " ]");
// 3.14e+0
console.log("Math.PI.toExponential(2): [ " + Math.PI.toExponential(2) + " ]");
// 3.1415927e+0
console.log("Math.PI.toExponential(7): [ " + Math.PI.toExponential(7) + " ]");

console.log("Math.PI.toExponential(16): [ " + Math.PI.toExponential(16) + " ]");

/**
 * number.toFixed(fractionDigits)
 * toFixed方法把这个number转换成为一个十进制的字符串,可选参数fractionDigits控制其小数点后的数字位数(它的值必须在0~20).
 * */
console.log("Math.PI.toFixed(0): [" + Math.PI.toFixed(0) + "]");
// 3.14
console.log("Math.PI.toFixed(2): [" + Math.PI.toFixed(2) + "]");
// 3.1415927
console.log("Math.PI.toFixed(2): [" + Math.PI.toFixed(7) + "]");
// 3
console.log("Math.PI.toFixed(): [" + Math.PI.toFixed() + "]");

/**
 * number.toPrecision(precision)
 * toPrecision方法用于控制可选参数precision控制数字的精度,它的值必须在0~21之间.
 * */
console.log("Math.PI.toPrecision(2): [" + Math.PI.toPrecision(2) + "]");
// [3.141593]
console.log("Math.PI.toPrecision(7): [" + Math.PI.toPrecision(7) + "]");
// [3.141592653589793]
console.log("Math.PI.toPrecision(16): [" + Math.PI.toPrecision(16) + "]");
// [3.141592653589793]
console.log("Math.PI.toPrecision(): [" + Math.PI.toPrecision() + "]");

/**
 * number.toString(radix)
 * toString方法把这个number转化成为一个字符串,可选参数radix控制基数(其值必须在2~36之间)
 * */
console.log("Math.PI.toString(2): [" + Math.PI.toString(2) + "]");
// [3.1103755242102643]
console.log("Math.PI.toString(8): [" + Math.PI.toString(8) + "]");
// [3.243f6a8885a3]
console.log("Math.PI.toString(16): [" + Math.PI.toString(16) + "]");
// default basic radix[3.141592653589793]
console.log("Math.PI.toString(): [" + Math.PI.toString() + "]");


/***
 * Javascript中的String类型
 * charAt(pos)方法返回在string中pos位置处的字符,如果pos小于0或者大于等于字符串的长度string.length,它会返回空字符串.
 */
var name = "Curly";
var initial = name.charAt(0);
console.log("initial character is: [" + initial + "]");
// charAt method的默认实现,default implement
/*
String.method('charAt', function(pos) {
    return this.slice(pos, pos + 1);
});
*/

/**
 * string.charCodeAt(pos)
 * 该方法返回string中对应位置字符pos在string中pos位置处字符的ascii码
 * */
var initialCode = name.charCodeAt(0);
console.log("initial ascii code: [" + initialCode + "]");

/**
 * string.concat(string)
 * 该方法把其他的字符串连接在一起来构造一个新的字符串,但是平时使用+的机会会比较多.
 * */
var concat = 'C'.concat('a', 't');
console.log("concat value is : [" + concat + "]");

/**
 * string.indexOf(searchString, position)
 * indexOf方法在string内查找另一个字符串searchString,如果它被找到则返回1个匹配字符的位置(否则返回-1).
 * */
var text = 'Mississippi';
var pos = text.indexOf("ss");
console.log("ss indexOf text position is: [" + pos + "]");
// 可以在indexOf的第二个参数中指定开始搜索的下标索引
pos = text.indexOf("ss", 3);
console.log("ss text indexOf 3, position is: [" + pos + "]");
// 在indexOf的第二个参数指定下标索引为6.
pos = text.indexOf("ss", 6);
console.log("ss text indexOf 6, position is: [" + pos + "]");


