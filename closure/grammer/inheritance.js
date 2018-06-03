/**
 * Created by dong on 18/6/3.
 */
// document.write("<script language='javascript' src='function.js'></script>");
// warning:在js中没法引入另外一个Js文件,只能将用到的js代码拷贝过来.
Function.prototype.method = function(name, func) {
    if(!this.prototype[name]) {
        this.prototype[name] = func;
    }
    return this;
};

/**
 * 1.javascript中的伪类,
 *    定义一个构造器并且扩充其函数的原型.
 * */
var Mammal = function(name) {
    this.name = name;
};
Mammal.prototype.get_name = function() {
    return this.name;
};
Mammal.prototype.says = function() {
    return this.saying || '';
};
// 现在构造一个实例
var myMammal = new Mammal('herb the Mammal');
var name = myMammal.get_name();
console.log('myMammal.get_name(): ' + name);

// 2.我们可以构造另一个伪类来继承Mammal,这是通过定义它的constructor函数并替换它的prototype为一个Mammal的实例来实现的.
var Cat = function(name) {
    this.name = name;
    this.saying = 'meow';
};
// 替换Cat.prototype为一个新的Mammal实例.
Cat.prototype = new Mammal();
// 扩充新的原型对象,增加purr和get_name方法.
Cat.prototype.purr = function(n) {
    var i, s = '';
    for(i=0; i < n; i+=1) {
        if (s) { s += '-'; }
        s += 'r';
    }
    return s;
};
Cat.prototype.get_name = function() {
    return this.says() + ' ' + this.name + ' ' + this.says();
};
var myCat = new Cat('Henrietta');
var says = myCat.says();    // 'meow'
var purr = myCat.purr(5);   // 'r-r-r-r-r'
var name = myCat.get_name();    // 'meow Henrietta meow'
console.log('says: ' + says + ' | purr: ' + purr + ' | name: ' + name);

/**
 * 2.伪类模式的本意是想向面向对象靠拢，但它看起来格格不入。我们可以隐藏一些丑陋的细节，通过使用method方法来定义一个
 * inherits方法的实现.我们的inherits和method方法都返回this,这样允许我们可以采用级联的形式编程.
 * */
Function.method('inherits', function (Parent) {
    this.prototype = new Parent();
    return this;
});
var Cat = function (name) {
    this.name = name;
    this.saying = 'meow';
}.inherits(Mammal)
    .method('purr', function(n) {
        var i, s = '';
        for(i = 0; i < n; i+=1) {
            if(s) s += '-';
            s += 'r';
        }
        return s;
    })
    .method('get_name', function () {
       return this.says + ' ' + this.name + ' ' + this.says();
    });

/**
 * 3.原型prototype：在一个纯粹的原型模式中,我们会摒弃类,转而专注于类.基于原型的继承相比较于基于类的继承更容易理解.
 * 你通过构造一个有用的对象开始,接着可以构造更过和那个对象类似的对象.这就可以完全避免把一个应用拆解成一系列嵌套抽象类的分类过程.
 * */
var myMammal = {
    name: 'Herb the Mammal',
    get_name: function() {
        return this.name;
    },
    says: function () {
        return this.saying || '';
    }
};
// 当有了一个想要的对象,我们就可以利用第3章介绍过的Object.create方法构造出更多的实例.通过制定一个新的对象,
// 我们指明了它与基于的基本对象之间的区别.
var myCat = Object.create(myMammal);
myCat.name = 'Henrietta';
myCat.saying = 'meow';
myCat.purr = function () {
  var i, s= '';
  for(i = 0; i < n; i++) {
      if(s) s += '-';
      s += 'r';
  }
  return s;
};
myCat.get_name = function () {
    return this.says + ' ' + this.name + ' ' + this.says;
};

/**
 * 4.函数化(functional):目前为止我们所看到的继承模式的一个弱点就是没法保护隐私,对象的所有属性都是可
 * 见的,我们没法得到私有变量和私有函数.
 * */
var mammal = function (spec) {
    var that = {};
    that.get_name = function() {
        return spec.name;
    };
    that.says = function () {
        return spec.saying || '';
    };
    return that;
};
var myMammal = mammal({name: 'Herb'});

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
        method = that[name];
    return function() {
        return method.apply(that, arguments);
    };
});
// 我们在coolcat上试验一下,coolcat就像cat一样,除了它有一个更酷的调用父类方法的get_name外,
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

/**
 * 5.部件part.
 * */
var eventuality = function (that) {
    var registry = {};
    that.fire = function(event) {
        /**
         * 在一个对象上触发一个事件,该事件可以是一个包含事件名称的字符串,或者是一个拥有包含事件名称的type属性的对象.
         * 通过'on'方法注册的事件处理程序中匹配事件名称中的函数将被调用.
         * */
      var array, func, handler, i, type = typeof event === 'string' ? event : event.type;
      // 如果这个事件存在一组事件处理程序,那么就遍历它们并按照顺序依次执行.
      if(registry.hasOwnProperty(type)) {
          array = registry[type];
          for(i = 0; i < array.length; i+=1) {
              handler = array[i];
              // 每个处理程序包含一个方法和一组可选的参数,如果该方法是一个字符串形式的名字,那么寻找到该函数.
              func = handler.method;
              if(typeof func === 'string') {
                  func = this[func];
              }
              // 调用一个处理程序,如果该条目包含参数,那么传递它们过去,否则,传递该事件对象.
              func.apply(this, handler.parameterNames || [event]);
          }
      }
      return this;
    };
    that.on = function(type, method, parameters) {
        // 注册一个事件构造一条处理程序条目,将它插入到处理程序数组中,如果这种类型的事件还不存在,那构造一个.
        var handler = {
            method: methodcd 
            parameters: parameters
        };
        if(registry.hasOwnProperty(type)) {
            registry[type].push(handler);
        } else {
            registry[type] = [handler];
        }
        return this;
    };
    return that;
};