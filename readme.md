## javascript_syntax基本语法(函数、原型继承、function)
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