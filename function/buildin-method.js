/**
 * Array method: build methods in Array type
 * */
var array = ["a", "b", "c"];
var anotherArray = ["x", "y", "z"];
// array.concat方法会将anotherArray中的所有元素附加到array数组的末尾.
var concat = array.concat(anotherArray, true);
console.log("concat array: [" + concat + "]");

// array.join(char)方法会将数组中的元素使用char进行拼接
var joinArray = ["a", "b", "c"];
joinArray.push("d");
var charSequence = joinArray.join('');
console.log("called array.join() method, result:[" + charSequence + "]");

// array.pop()方法会使用像Stack栈一样工作,pop方法会移除array的最后一个元素并返回该元素.如果array为empty,则其会返回undefined;
var popArray = ["a", "b", "c"];
var character = popArray.pop();
console.log("pop item is: [" + character + "], popArray is : [" + popArray + "]");
// array.splice(position, num)
var item = anotherArray.splice(anotherArray.length - 1, 1);
console.log("splice item: [" + item + "], anotherArray array item: [" + anotherArray + "]");
// Array.pop()方法的实现,splice的第一个参数为要删除元素的位置,第二个参数为要删除元素的个数.
/*Array.method('pop', function () {
    return this.splice(this.length - 1, 1);
});*/

// array.push方法会把一个或多个参数Item附加到一个数组的尾部,和concat方法不同的是它会修改array.
// 如果Item是一个数组,它会把参数数组作为单个元素添加到数组中,并返回这个array的新长度.
var length = array.push(anotherArray, true);
console.log("array push method: [" + array + "], length:" + length);

Array.method('push', function() {
    this.splice.apply(this, [this.length, 0].concat(Array.prototype.slice.apply(arguments)));
    return this.length;
});
