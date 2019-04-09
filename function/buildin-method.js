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
console.log("shiftArray.shift method, shiftChar: [" + shiftChar + "], unshiftArray: [" + shiftArray + "]");

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
variousItem.sort(function (prev, next) {
    if (prev === next) {
        return 0;
    }
    if (typeof prev === typeof next) {
        return prev < next ? -1 : 1;
    }
    return typeof prev < typeof next ? -1 : 1;
});
console.log("various item sort: [" + variousItem + "]");

// 可以对象数组进行排序,使用对象的某个属性对其进行排序.
var sortedBy = function (name) {
    return function (prev, next) {
        // 如果prev和Next对象都为object类型,并且prev和next对象都非undefined
        if (typeof prev === 'object' && typeof next === 'object' && prev && next) {
            var prevValue = prev[name];
            var nextValue = next[name];

            if (prevValue === nextValue) {
                return 0;
            }
            // 如果属性值类型相同,则根据属性名称比较属性的值.
            if (typeof prevValue === typeof nextValue) {
                return prevValue < nextValue ? -1 : 1;
            }
            return typeof prevValue < typeof nextValue ? -1 : 1;
        } else {
            throw {
                name: 'Error',
                message: 'Expected an object when sorting by ' + name
            };
        }
    };
};

var objectArray = [
    {first: 'Joe', last: 'Besser'},
    {first: 'Moe', last: 'Howard'},
    {first: 'Joe', last: 'DeRita'},
    {first: 'Shemp', last: 'Howard'},
    {first: 'Larry', last: 'Fine'},
    {first: 'Curly', last: 'Howard'}
];

// 排序的稳定性是指:排序后数组中的相等值的相对位置没有发生改变,而不稳定行排序则会改变相等值的相对位置.
objectArray.sort(sortedBy("first")).sort(sortedBy("last"));
console.log("Sorted object array by first field, objectArray: [" + objectArray + "]");

// by函数接受一个成员名字符串和一个可选的次要比较函数作为参数,并返回一个可以用来对包含该成员的对象数组进行排序的比较函数.
// 当prev[name]和next[name]相等时,次要比较函数被用来表决高下.
var stableSortedBy = function (name, minor) {
    return function (prev, next) {
        if (prev && next && typeof prev === 'object' && typeof next === 'object') {
            var prevValue = prev[name];
            var nextValue = next[name];

            if (prevValue === nextValue) {
                return typeof minor === 'function' ? minor(prev, next) : 0;
            }
            if (typeof prevValue === typeof nextValue) {
                return prevValue < nextValue ? -1 : 1;
            }
            return typeof prevValue < typeof nextValue ? -1 : 1;
        } else {
            throw {
                name: 'Error',
                message: 'Expected an object when sorting by ' + name
            };
        }
    };
};

objectArray.sort(stableSortedBy('last', stableSortedBy('first')));
console.log("stableSortedBy array: [" + objectArray + "]");

/***
 * Array.splice(start, deleteCount, item...)
 * Array的slice方法会从start位置开始删除deleteCount的元素,同时使用item..数组中的元素对其进行替换.
 */
var sliceArray = ["a", "b", "c"];
var removeItem = sliceArray.splice(1, 1, "ache", "bug");
console.log("slice method result array: [" + sliceArray + "], remove Item: [" + removeItem + "]");

// Array.splice() method方法实现
Array.method('splice', function (start, deleteCount) {
    var max = Math.max,
        min = Math.min,
        delta,
        element,
        // 通过arguments.length计算本次插入元素的数量.
        insertCount = max(arguments.length - 2, 0),
        k = 0,
        // len当前数组的长度,new_len表示replace元素之后的数组长度.
        len = this.length,
        new_len,
        result = [],
        shift_count;

    // 判断是否指定了start元素,如果未指定则默认从0位置开始.
    start = start || 0;
    if (start < 0) {
        start += len;
    }
    start = max(min(start, len), 0);
    // 用于计算从start位置开始需要移除元素的个数.
    deleteCount = max(min(typeof deleteCount === 'number' ? deleteCount : len, len - start), 0);
    delta = insertCount - deleteCount;
    // delta的数值为本次新增元素的个数,将其加上length构成新的数组长度.
    new_len = len + delta;

    while (k < deleteCount) {
        element = this[start + k];
        if (element !== undefined) {
            result[k] = element;
        }
        k += 1;
    }

    shift_count = len - start - deleteCount;
    if (delta < 0) {
        k = start + insertCount;
        while (shift_count) {
            this[k] = this[k - delta];
            k += 1;
            shift_count -= 1;
        }
        this.length = new_len;
    } else if (delta > 0) {
        k += 1;
        while (shift_count) {
            this[new_len - k] = this[len - k];
            k += 1;
            shift_count -= 1;
        }
        this.length = new_len;
    }

    for (k = 0; k < insertCount; k += 1) {
        this[start + k] = arguments[k + 2];
    }
    return result;
});


/**
 * array.unshift() method功能和push方法类似,用于把元素添加到数组中,其会将Item添加到数组的头部而不是尾部。
 * */
var unshiftArray = ["a", "b", "c"];
var length = unshiftArray.unshift("?", "@");
console.log("unshift array is: [" + unshiftArray + "], result.length: [" + length + "]");
// Array.shift()函数的实现逻辑如下
/*Array.method("unshift", function () {
    this.splice.apply(this,
        // this.splice方法参数含义:从位置为0的位置(start),移除0个元素并且用arguments数组进行补充.
        [0, 0].concat(Array.prototype.slice.apply(arguments)));
    return this.length;
});*/


