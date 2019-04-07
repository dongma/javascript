/**
 * 1. create array syntax:
 * 在Javascript中一个数组字面量是在一对方括号中包围零个或多个用逗号分隔的值的表达式.
 * */
var empty = [];
// 创建包含10个元素的数组对象,数组的下标索引默认从0开始计数.
var numbers = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nice"];

console.log("empty[0]: " + empty[1] + " , numbers[0]:" + numbers[1] + " , numbers.length: " + numbers.length);

// 创建对象字面量，numbers是继承自Array.prototype numbers_object继承自Object.prototype,同时numbers_object不具备length方法
var numbers_object = {
    '0': 'zero',
    '1': 'one',
    '2': 'two',
    '3': 'three',
    '4': 'four',
    '5': 'five',
    '6': 'six',
    '7': 'seven'
};
console.log("numbers_object['1'] value: " + numbers_object['1']);

// 在Javascript中数组可以包含任意类型的元素
var misc = ['string', 98.6, true, false, null, undefined, ['nested', 'array'], {object: true}, NaN];
console.log("misc.length: " + misc.length + " , misc[1]: " + misc[1]);

/**
 * 2. Javascript array length
 * */
var customArray = [];
console.log("customArray.length: " + customArray.length);

// length属性的值为这个数组的最大整数属性名加上1,其并不一定等于数组中属性的个数.
customArray[20] = true;
console.log("set position[20] element customArray.length: " + customArray.length);

// 设置数组length属性的值,如果设置更大的length值不会给数组分配更多的空间,而length设置小将导致所有下标等于新length的属性被删除.
numbers.length = 5;
console.log("after set numbers.length property, numbers array item is: [" + numbers + "]");

// 可以通过数组的length属性向数组的末尾添加元素
numbers[numbers.length] = "eleven";
console.log("after append element to the end of numbers array, numbers: [" + numbers + "]");

// 可以使用更简洁的push()方法向numbers添加元素
numbers.push("twelve");
console.log("after called push method: all items: [" + numbers + "]");

/**
 * 3. remove item from Javascript array
 */
delete numbers[2];
// 与对象Object类似,delete运算符可以用来从数组中移除元素.
console.log("delete numbers[2], total array item is: [" + numbers + "]");

// 通过splice方法可以对真个数组做手术,删除一些元素并将它们替换为其它的元素(param1: 元素在数组中的一个序号, param2: 表示要进行删除的元素个数).
numbers.splice(2, 1);
console.log("using splice method to remove item: [" + numbers + "]");

// 使用for-each对数据元素进行遍历时并不能保证按照下标索引进行访问.
var unorderArray = [];
for (var item in numbers) {
    unorderArray.push(numbers[item]);
}
console.log("iterate array using foreach, unorderArray: [" + unorderArray + "]");

// 使用传统的for循环去遍历数组的元素,使用下标索引进行遍历.
var orderArray = [];
for (var i = 0; i < numbers.length; i++) {
    orderArray.push(numbers[i]);
}
console.log("iterate array using for statement, orderArray:[" + orderArray + "]");

// typeof运算符在识别Array时会将其类型认定为Object(但这是没有任何意义),可以通过Object.prototype.toString获取object的对象.
var is_array = function (value) {
    return Object.prototype.toString.apply(value) === '[object Array]';
};

console.log("numbers.is_array方法判断object对象类型是否为数组: " + is_array(numbers));

/**
 * 3.Array.prototype扩展Array的默认方法.
 * */
Object.prototype.method = function (name, func) {
    if (!this.prototype[name]) {
        this.prototype[name] = func;
    }
    return this;
};

Array.method('reduce', function (func, value) {
    for (var index = 0; i < this.length; i += 1) {
        value = func(this[index], value);
    }
    return value;
});

var dataArray = [4, 8, 15, 16, 23, 42];

// 定义两个简单函数,一个是把两个数字相加,另一个是把两个数字相乘.
var add = function (a, b) {
    return a + b;
};

var multi = function (a, b) {
    return a * b;
};

// 调用data的reduce方法，传入add函数进行调用.
var sum = dataArray.reduce(add, 0);
// 使用reduce方法对所有的元素进行multi相乘.
var product = dataArray.reduce(multi, 1);

// 再次调用reduce方法，因为数组其实就是对象，所以我们可以直接给一个单独的数组添加方法.
console.log("reduce method,  add method: " + sum + " , multi method:" + product);

// 其实数组就是对象,可以直接给一个单独的数组添加方法.
dataArray.total = function() {
    return this.reduce(add, 0);
};
console.log("dataArray.total method result: " + dataArray.total());

// 自定函数设置Array数组元素的默认值
Array.dim = function (dimension, initial) {
    var array = [], i;
    for (i = 0; i < dimension; i += 1) {
        array[i] = initial;
    }
    return array;
};

// 通过Array.dim函数创建一个包含10个0的数组
var myArray = Array.dim(10, 0);
console.log("myArray item initial with 0 : " + myArray);

// Javascript并没有提供创建多维数组的方式,你必须自己创建第二个维度的数组.
Array.matrix = function(m, n, initial) {
    var array, i, j, mat = [];

    for (i = 0; i < m; i += 1) {
        array = [];
        for (j = 0; j < n; j += 1) {
            array[j] = initial;
        }
        mat[i] = array;
    }
    return mat;
};

// 使用matrix创建一个4*4的矩阵
var myMatrix = Array.matrix(4, 4, 0);
console.log("custom myMatrix array: " + myMatrix[3][3]);
