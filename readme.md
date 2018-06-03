## javascript_syntax基本语法(函数、原型继承、function)
1. javascript语言基本的数据类型以及对象字面量.
> javascript基本数据类型: 数字、字符串、布尔值`(true & false)`、null值和undefined.其它所有的值都是对象，数字、字符串和布尔值貌似对象，因为它们拥有方法，但是它们是不可变的。javascript中的对象是可变的键控集合(keyed collections)。在javascript中，数组是对象，函数也是对象、正则表达式也是对象，当然，对象也是对象。 
> 对象字面量：对象字面量是一种非常方便地创建对象值得表示法，一个对象字面量就是包围在一堆花括号中的零个或者多个"名/值"对。
```javascript
var stooge = {
  // 关于属性名的命名规范,如果属性名称是一个合法的js标识符,则可以进行直接的使用。
  // 对于不合法的"-"符号则需要使用""双引号进行包含.
  firstName : "Jerome",
  "last-name": "Howard"
};
```
> 关于对象属性的检索retrieval，可以直接使用object.property进行获取。如果属性名称符合变量的命名规范，则可以使用property直接可以使用.进行获取`如flight.department.IATA`；否则就需要使用`[]`进行包装进行提取`stooge["last-name"]`；
如果要删除对象的某个属性值得时，可以直接使用delete操作符 `delete stooge.firstName`，删除之后若需要再重新去检索该属性，则会在对象的原型链中进行查询；
2. 关于javascript中的函数(function).
>javascript中的函数就是对象，对象是“名/值”对的集合并且拥有一个连接到原型对象的隐藏连接。函数对象连接到`Function.prototype`(该原型对象本身连接到`Object.prototype`)。每个函数在创建的时候会附加两个隐藏属性:函数的上下文和实现该函数的代码；<br/>
>javascript中函数的调用方式主要有4种：方法调用模式(函数作为对象的属性)、函数调用模式、构造器调用模式(使用new操作符)、apply调用模式。`()`充当函数调用运算符，在操作符中传入实际的参数。与强编译型语言不同的是，当调用javascript函数时，如果实际参数的数量与声明时的形参个数不同，多余的实参会被忽略不足个实参会使用undefined进行补充。不同的方法调用方式关于this绑定的形式：在方法中this绑定发生在方法被调用的时期；普通的函数调用时其`this`是默认绑定到全局对象，如果将函数声明在其它函数的内部，this被绑定了错误的值，所以不能共享该方法对对象的访问权；如果使用构造器调用方法时，js会在背后创建一个连接到该函数的prototype成员的新对象，同时this会被绑定到那个新对象上；apply方法允许我们创建一个参数数组传递给调用函数。它允许我们选择`this`值，第二个参数就是一个参数数组。
```javascript
/**
 *statusObject并没有继承自Quo.prototype,但我们可以在statusObject上调用get_status方法，尽管statusObject并没有一个名为get_status的方法.
 */
var statusObject = {status: 'A-OK'};
// 通过apply指定get_status方法调用的上下文为statusObject对象，因而其获取到的是statusObject的status属性值.
var status = Quo.prototype.get_status.apply(statusObject);  // status的值为'A-OK'
```