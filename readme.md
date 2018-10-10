## Javascript_syntax基本语法(函数、原型继承、Array、正则表达式)
关于[jQuery常用函数](https://github.com/SamMACode/javascript_syntax/blob/master/jquery.md)用法
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
>扩展类型的功能(Augmenting types)：javascript允许给语言的基本类型扩充功能，可以通过Object.prototype添加方法，可以让该方法对所有的对象都可用。同理也可以通过添加方法使得该方法对所有函数可用。通过给Function.prototype增加一个method方法，我们下次给对象添加方法的时候就不必键入prototype这几个字符，省略掉一些麻烦。
```javascript
Function.prototype.method = function(name, func) {
  if(!this.prototype[name]) {
    this.prototype[name] = func;
  }
  return this;
};
// 对Number添加一个integer方法，它会根据数字的正负值来判断是使用Math.ceiling还是Math.floor
Number.method('integer', function() {
  return Math[this < 0 ? 'ceil' : 'floor'](this);
});
console.log((-10/3).integer());   // value is -3,在调用integer()方法的时候this做为参数传递给integer方法.
// 对String添加trim方法用来移除字符串首位的空格字符.
Stirng.method('trim', function() {
  return this.replace(/^\s+|\s+$/g, '');
});
// 在trim和integer方法中都对this传递，在integer中由于要判断this值的大小，其是作为参数的形式传递到方法内.
// 而trim方法则是直接调用this.replace方法,是否需要判断this值而采用了两种不同的方式
console.log('"' + "  neat  ".trim() + '"');  // "neat"
```
>函数关系的闭包(closure)：函数字面量可以出现在任何表达式出现的地方。函数也可以被定义在其它函数中，一个内部函数除了可以访问自己的参数和变量，同时它也能自由访问把它嵌套在其中的父函数中的参数和变量。通过函数字面量创建的函数对象包含一个连接到外部上下文的连接。这被称为闭包(closure){函数可以访问它被创建时所处的上下文环境}。<br/>
>{知乎专栏解释}：闭包创建一个词法作用域，这个作用域里面的变量被访问之后可以在这个词法作用域外面被自由访问，是一个函数与其所声明环境组合；还有一种解释为：闭包就是引用了自由变量的函数，这个自由变量与函数一同存在，即使脱离了创建它的环境。通常所说的闭包就是绑定函数创建上下文就是这个意思。

```javascript
// 创建一个名为quo的构造函数，它构造出带有get_status方法和status私有属性的一个对象.
var quo = function(status) {
  return {
    get_status: function() {
      return status;
    }
  };
};
// 创建一个quo实例,myQuo引用的是匿名对象,它包含有get_status方法用来访问status属性.
var myQuo = quo("amazed");
// 不能通过myQuo.status直接访问属性值.
console.log("myQuo.get_status(): " + myQuo.get_status());
```
>该函数被设计成无需再前面加上new来使用，所以名字也没有首字母大写。即是quo方法已经返回了，但是get_status方法仍然享有访问quo对象的status属性的特权。get_status方法并不是访问该参数的一个副本，它访问的就是该参数本身。这是可能的，因为该函数可以访问它被创建时所处的上下文环境，这被称为闭包。关于闭包需要说明的：生成闭包的形式可以是返回一个内部函数，或者在外面声明变量在函数内部对外部变量进行实例化，这样外部变量也就保存有一个对内部匿名变量的引用，两种形式的最终效果都是一致的；同一个调用函数创建同一个闭包环境，闭包换环境里面的函数对自由变量具有共享的作用；创建闭包环境的构造函数每次在执行之后都会创建不同的闭包环境；在循环里面创建闭包，创建一个新的闭包环境，这样每个闭包对象里面变量就不互相影响。
```javascript
var add_the_handler = function() {
  var helper = function(i) {return function(e) {alert(i)};};
  var i;
  for(int i=0; i<nodes.length; i+=1)
    nodes[i].onclick=helper(i);
};
// 另外一种形式是使用自执行函数,外部的匿名函数会立即执行,并把i作为它的参数,此时v获取的是i变量值得拷贝,而且这个值在循环内是不会被改变的.
var add_the_handler = function() {
  for(int i=0; i<nodes.length; i+=1)
    (function(v){
      nodes[v].onclick = function() {alert(v);};
    })(i);
};
```
>函数的柯里化：柯里化允许我们把函数与传递给它的参数相结合，产生一个新的函数。curry方法通过创建一个保存着原始函数和要被套用的参数的闭包来工作。它返回另一个函数，该函数被调用时会返回原始函数的结果，并传递调用curry时的参数加上当前调用的参数，它使用Array和concat方法连接连个参数数组的slice方法.
```javascript
Function.method('curry', function(){
  var slice = Array.prototype.slice,
  args = slice.apply(arguments),
  that = this;
  return function() {
    return that.apply(null, args.concat(slice.apply(arguments)));
  };
});
```
>js的闭包比较强大，通过函数的闭包可以将函数的属性值设置为私有(只能通过返回的方法引用进行获取其属性值)，此外，在闭包中也可以对函数计算的结果进行缓存减少了函数的运算量。此外，函数的模块化指的是：对外隐藏函数实现细节。
3. 继承(inheritance)用法
>在一些基于类的语言(比如java)中，继承提供了两个有用的服务：继承的出现是为了解决面向对象编程中的代码重用问题。另外，继承的出现也引入了类型系统的概念，父类与子类之间的继承关系，在进行编码的时候不需要进行显示的类型转换，子类可以进行安全的向上的类型转换。javascript是一门基于原型的语言，这意味着对象可以直接从其他对象继承。<br/>
>伪类(pseudoclassical)的概念：javascript不直接让对象从其它对象进行继承，反而插入了一个多余的间接层：通过构造器函数产生对象。当一个函数对象被创建的时候，Function构造器产生的函数对象会运行类似这样的一段代码：` this.prototype = {constructor:this}; `新函数对象被赋予一个prototype属性，它的值是一个包含constructor属性且属性值为该新函数的对象。这个`prototype`属性是存放继承特征的地方。因为javascript语言没有提供一个方法去确定那个函数是用来打算做构造器的，所以每一个函数都会得到一个`prototype`对象。{将一个对象的`prototype`属性值替换为一个函数的实例，这样该函数也就默认继承了该实例的方法}.
```javascript
// 创建一个构造器并且扩充它的原型.
var Mammal = function(name) {this.name=name;};
Mammal.prototype.get_name = function() {return this.name; };
Mammal.prototype.says = function() {return this.saying || '';};
// 可以通过new操作符构建一个实例，并调用其方法.
var myMammal = new Mymmal('herb the mammal');
var name = myMammal.get_name();  // 'herb the mammal'
// 接着我们构造一个伪类来继承Mammal，方式为通过定义它的constructor函数并替换它的prorotype为一个Mammal的实例来实现的:
var Cat = function(name) {
  this.name = name;
  this.saying = 'meow';
};
Cat.prototype = new Mammal();    // 替换Cat.prototype为一个新的Mammal实例.
// 扩充新原型对象,增加get_name方法.
Cat.prototype.get_name = function() {
  return this.says() + ' ' + this.name + ' ' + this.says();
};
var myCat = new Cat('Henrietta');
var says = myCat.says();	// 'meow'
var name = myCat.get_name();	// 'meow Henrietta meow'
/**
 * 伪类模式本意是想向面向对象靠拢，但是看起来格格不入。可以隐藏一些实现的细节，使用method方法来定义一个inherits方法实现。
 */
Function.method('inherits', function(Parent){
  this.prototype = new Parent();
  return this;
});
// 由于method和inherits方法都返回this,这样允许我们可以采用级联的形式编程。
var Cat = function(name) {
  this.name = name;
  this.saying = 'meow';
}.inherits(Mammal)
.method('purr', function(n){
  var i, s = '';
  for(i=0; i<n; i+=1)
  	if(s) s += '-';
  	s += 'r';
  return s;
})
.method('get_name', function(){
  return this.says() + ' ' + this.name + ' ' + this.says();
});
```
> 通过隐藏那些无畏的prototype操作细节，现在它看起来没有那么怪异了。存在的问题：没有私有环境，所有的属性都是公开的，无法访问super（父类）的方法；更糟糕的是使用构造器存在一个危害，如果你在调用构造器函数时忘记了在前面加上`new`前缀，那么this将不会绑定到一个新对象上。悲剧的是this将会绑定到全局对象上，所以你不但没有扩充新对象，反而破坏了全局变量环境。
> 对象说明符：当构造器中参数比较多的时候，给构造器传递参数需要记住参数的顺序是非常困难的。在这种情况下，可以通过简单的对象说明符进行简化：
```javascript
var myObject = maker(f, i, m, c, s);
// 使用对象说明符的方式,显然第二种方式更为简化。
var myObject = maker({
  first: f,
  middle: m,
  last: l,
  state: s,
  city: c
});
```
>函数化(functional)：迄今为止我们看到的继承模式的一个弱点就是没法保护隐私。对象的所有属性都是可见的，我们没法得到私有变量和私有函数。通过函数化对对象的属性和方法进行私有化：步骤可以分为4部分：1.创建一个对象，有很多种方式去构造一个对象。它可以构造一个对象字面量或者可以使用new前缀调用一个构造函数。2.有选择的去定义私有变量和方法。3.给这个新对象扩充方法，这些方法拥有特权去访问参数以及在第二步中通过var声明的变量。4.返回那个新的对象；
```javascript
var cat = function(spec) {
    spec.saying = spec.saying || 'meow';
    var that = mammal(spec);
    that.purr = function(n) {
      var i, s = '';
      for(i = 0; i < n; i+=1) {
          if(s) s += '-';
          s += 'r';
      }
      return s;
  };
  that.get_name = function() {
      return that.says() + ' ' + spec.name + '  ' + that.says();
  };
  return that;
};
var myCat = cat({name: 'Henrietta'});
/**
 * 函数化模式还给我们提供了一个处理父类方法的方法,我们会构造一个superior方法,它取得一个方法名并返回
 * 调用那个方法的函数,该函数会调用原来的方法,尽管属性已经变化了.
 * */
Object.method('superior', function (name) {
    var that = this,
      method = that[name];	// 通过对象的属性引用符得到name对应的Method对象
    return function() {
        return method.apply(that, arguments);
    };
});
// 我们在coolcat上试验一下,coolcat就像cat一样,除了它有一个更酷的调用父类方法的get_name外,在coolcat中的父类方法指的是cat(spec)中的get_name方法.
// 我们会声明一个super_get_name变量并且把调用superior方法所返回的结果赋值给它.
var coolcat = function(spec) {
    var that = cat(spec),
        super_get_name = that.superior('get_name');
    that.get_name = function(n) {
        return 'like ' + super_get_name() + ' baby';
    }
    return that;
};
var myCoolCat = coolcat({name: 'Bix'});
var name = myCoolCat.get_name();
console.log('myCoolCat.get_name: ' + name);
```
4. 关于javascript中的数组对象
>数组是一段线性分配的内存，它通过整数计算偏移并访问其中的元素，数组由于内存连续因而其操作是非常快速的。但是javascript并没有类似数组的结构，它提供的是一种类数组特性的对象。在大多数语言中，一个数组中的所有元素都要求必须是同一种类型，但是javascript允许数组元素包含任意混合类型的值。
```javascript
var numbers = ['zero', 'one', 'tow', 'three'];
var numbers_object = {'0':'zero', '1':'one', '2':'two', '3':'three'};
```
>numbers和numbers_obejct操作看起来是一致的，但是其也有一些显著的不同：numbers继承自`Array.prototype`而numbers_object继承自`Object.prototype`，因而numbers继承了大量有用的方法。同时numbers包含length属性而numbers_object没有；<br/>
>如何删除javascript中数组的元素是一个有趣的问题：可以通过使用`delete`运算符从数组中删除元素：` delete numbers[2] `不过在numbers[2]处的元素数值为`undefined`而并不是所期望的删除元素的空间，后边的元素append到被删除元素之前的元素。javascript也提供了一个splice方法，该方法用来删除一些元素并将它们替换为其他的元素。被删除属性后面的每个属性必须被移除，并且以一个新的键值重新插入。
```javascript
numbers.splice(2, 1);	// numbers为['zero', 'one', 'shi', 'go']
```
> 可以使用for.in循环进行迭代数组中的元素，但是迭代的结果会是无序的。如果通过for循环打印元素的值会按照正常的顺序显示出来；如何判断一个对象是数组还是普通的对象：
```javascript
var is_array = function(value) {
  return Object.prototype.toString.apply(value) === '[Object Array]';
};
```
>此外可以通过Array.prototype原型对数组的方法进行扩充：通过给`Array.prototype`扩充一个函数，每个数组都继承了这个方法。在这个例子中，我们定义了一个`reduce`方法它接受一个参数和一个初始值作为参数。它遍历这个数组，以当前元素和该初始值为参数调用这个函数，并计算出一个新值，此外数组中元素的默认值为undefined值。
```javascript
Array.method('reduce', function(f, value){
  var i;
  for(i = 0; i < this.length; i+=1)
    value = f(this[i], value);
  return value;
});
```
