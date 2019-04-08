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
/*Array.method('push', function() {
    this.splice.apply(this,
        // todo:
        [this.length, 0].concat(Array.prototype.slice.apply(arguments)));
    return this.length;
});*/

// array.reverse()方法反转array元素的顺序，并返回array本身
var reverseArray = joinArray.reverse();
console.log("reverse array: [" + reverseArray + "]");

// array.shift()方法会移除array中第1个元素并返回该元素,如果这个数组为空的则会返回undefined,shift通常比pop慢得多.
var shiftArray = ["a", "b", "c"];
var shiftChar = shiftArray.shift();
console.log("shiftArray.shift method, shiftChar: [" + shiftChar + "], shiftArray: [" + shiftArray + "]");

// slice方法会对array中的一段做浅复制,首先复制array[start],一致复制到array[end]为止.
var sliceArray = ["a", "b", "c"];
var b = sliceArray.slice(0, 1);
var c = sliceArray.slice(1);
var d = sliceArray.slice(1, 2);
console.log("position(0,1): [" + b + "], position(1): [" + c + "], position(1, 2): [" + d + "]");

// 使用array.sort(comparefn)对item进行排序,其不能正确地给一组数字排序.
var arrayItem = [4, 8, 15, 16, 23, 42];
arrayItem.sort();
console.log("sort item in array: [" + arrayItem + "]");
// 使用array的integer元素进行进行排序.
arrayItem.sort(function (a, b) {
    return a - b;
});
console.log("Use custom array compare: [" + arrayItem + "]");
// 如果对array中的所有元素进行排序,但其不能使字符串排序. 如果我们想要给任何包含简单值的数组排序,必须要做更多的工作.
var variousItem = ["aa", "bb", "a", 4, 8, 15, 16, 23, 42];
variousItem.sort(function(prev, next) {
    if (prev === next) {
        return 0;
    }
    if (typeof prev === typeof next) {
        return prev < next ? -1 : 1;
    }
    return typeof prev < typeof next ? -1 : 1;
});
console.log("various item sort: [" + variousItem + "]");


