/**
 * function.apply(thisArg, argArray)
 * */
// apply方法调用function,传递一个会被绑定到this上的对象和一个可选的数组作为参数,
// apply方法被调用在apply调用模式(apply invocation pattern)中.
Function.method('bind', function(that) {
    // 返回一个函数,调用这个函数就像调用那个对象的一个方法.
    var method = this,
        slice = Array.prototype.slice,
        args = slice.apply(arguments, [1]);
    return function() {
        return method.apply(that, args.concat(slice.apply(arguments, [0])));
    };
});

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
console.log("Math.PI.toExponential(0): [ " + Math.PI.toExponential(2) + " ]");
// 3.1415927e+0
console.log("Math.PI.toExponential(0): [ " + Math.PI.toExponential(7) + " ]");

console.log("Math.PI.toExponential(0): [ " + Math.PI.toExponential(16) + " ]");

