/**
 * Created by dong on 18/6/1.
 */
var value = 86;     // 定义全局的value变量.
// 1.声明函数字面量与myobject对象.
var add = function(a, b) {
    console.log("arguments: " + a + " > " + b);
    return a + b;
};
var myObject = {
    value: 0,
    increment: function(inc) {
      this.value += typeof inc === 'number' ? inc : 1;
    }
};
// 当缺省参数的时候,会对形参赋值为null.
myObject.increment();
console.log("myObject.value:" + myObject.value);
myObject.increment(2);
console.log("myObject.increment(2): " + myObject.value);
var sum = add(3, 4);

// 函数的调用模式(this绑定错误的时候),给myObject增加一个double方法.
myObject.double = function() {
   var helper = function() {
       console.log("myObject.double method this.value: " + this.value);
       this.value = add(this.value, this.value);
   };
   helper();
};
// 尝试以方法的形式调用double().
myObject.double();
console.log("myObject.value: " + myObject.value);