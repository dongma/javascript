/**
 * Created by dong on 18/6/1.
 */
var value = 86;     // 定义全局的value变量.
// 1.声明函数字面量与myobject对象(方法调用模式).
var add = function (a, b) {
    return a + b;
};
var myObject = {
    value: 0,
    increment: function (inc) {
        this.value += typeof inc === 'number' ? inc : 1;
    }
};
// 当缺省参数的时候,会对形参赋值为null.
myObject.increment();
console.log("myObject.value:" + myObject.value);
myObject.increment(2);
console.log("myObject.increment(2): " + myObject.value);
var sum = add(3, 4);
console.log("add(3, 4) value:" + sum);

/*// 函数的调用模式(this绑定错误的时候),给myObject增加一个double方法.
myObject.double = function() {
   // helper方法的this绑定被绑定到全局对象,使用该方式this绑定存在问题.
   // 所以不能共享该方法对对象的访问权,在内部的定义方法中,this指向的是全局的Object对象,而不是外部方法中的this对象.
    var helper = function() {
       // myObject.double method this.value: undefined {this object}:[object global]
       console.log("myObject.double method this.value: " + value + " {this object}:" + this);
       this.value = add(this.value, this.value);
   };
   helper();
};*/

myObject.double = function () {
    var that = this;
    var helper = function () {
        console.log("global value: " + value + " {this object}:" + this + " {that object}:" + that);
        // that与外部函数的context进行了绑定,that.value的值为myObject.value属性
        that.value = add(that.value, that.value);
    };
    helper();
};

// 2.另一中方式,函数调动模式(当一个函数并非一个对象的属性时,那么它就是被当做一个函数来调用的).
myObject.double();
console.log("after called myObject.double method, global value: " + value + ", myObject.value: " + myObject.value);

// 3.构造器调用模式(the constructor invocation pattern)
// 创建一个名为Quo的构造函数,它构造以个带有status属性的对象.
var Quo = function (string) {
    this.status = string;
};
// 给Quo的所有实例提供一个名为get_status的公共方法(通过原型Quo.prototype添加属性).
Quo.prototype.get_status = function () {
    return this.status;
};
// 构造一个Quo实例然后调用实例的方法myQuo.get_status().通过new操作符创建函数对象的时候,其
// 在背后会创建一个连接到该函数prototype成员的新对象.同时this会被绑定到那个新的对象.
var myQuo = new Quo("confused");
console.log("myQuo.get_status: " + myQuo.get_status());

// 4.apply调用模式(apply方法让我们构建一个参数数组传递给调用函数,它也允许我们选择this的值).
// apply方法接收两个参数,第一个参数要绑定给this的值,第二个就是一个参数数组.
var statusObject = {
    status: 'A-OK'
};
var statusValue = Quo.prototype.get_status.apply(statusObject);
console.log("statusObject.status: " + statusValue);

// algorithm 汉诺塔问题(数学家的问题).
/** 算法的核心:
 *   1.首先其将较小的盘子移动到辅助圆盘上,从而露出下面较大的盘子.
 *   2.移动下面的圆盘到目标柱子上.
 *   3.最后将较小的盘子从从辅助柱子移动到目标柱子上.
 *  hanoi(2, src=src, aux=aux, dst=dst) disc=3
 *  hanoi(2, src=src, aux=dst, dst=aux) disc=2
 *  hanoi(1, src=src, aux=aux, dst=dst) disc=1
 */
var hanoi = function (disc, src, aux, dst) {
    if (disc > 0) {
        hanoi(disc - 1, src, dst, aux);
        console.log("move disc " + disc + " from " + src + " to " + dst);
        hanoi(disc - 1, aux, src, dst);
    }
};
hanoi(3, 'src', 'aux', 'dst');

// 4.柯里化curry,扩充类型的功能.符合条件时才增加方法.通过给Function.prototype增加一个Method方法,
// 我们下次给对象添加方法的时候就不必键入prototype这几个字符,缺省掉一些麻烦.
Function.prototype.method = function (name, func) {
    if (!this.prototype[name]) {
        this.prototype[name] = func;
    }
    return this;
};
Function.method('curry', function () {
    var slice = Array.prototype.slice,
        args = slice.apply(arguments),
        that = this;
    return function () {
        return that.apply(null, args.concat(slice.apply(arguments)));
    };
});
var addCurryFunc = add.curry(1);
// 在curry柯里化函数中多余的参数会被忽略.
console.log("CurryFunc: " + addCurryFunc(2));

/**
 * 5.记忆(memoization).我们在一个名为memo的数组里面存放我们的存储结果,存储结果可以隐藏在闭包中.
 * 当函数被调用的时候,先去检查结果是否存在,如果已经存在,就立即返回这个结果.
 */
var fibonacci = function () {
    var memo = [0, 1];
    var fib = function (n) {
        var result = memo[n];
        if (typeof result !== 'number') {
            result = fib(n - 1) + fib(n - 2);
            memo[n] = result;
        }
        return result;
    };
    return fib;
} ();
for (var i = 0; i <= 10; i++) {
    console.log("fibonacci[" + i + "] " + fibonacci(i));
}