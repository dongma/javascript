## jquery前端框架的一些常用函数

> 概述：在该markdown文档中主要整理一些jquery操作数据集合/ajax发起异步请求/操作dom元素的函数；后期可能会加上jquery选择器的内容；

1. 对于jquery前端库与其它使用到$符号的库解决冲突的函数：
```javascript
  $.noConflict();	// 当使用此函数之后，调用jquery的方法的时候只能使用jQuery前缀符号.
```
2. 对javascript对象的字符串进行修剪(`trim`)，返回的结果为去除字符串开头和结尾的空白字符。
```javascript
  var trimstring = $.trim($('#someField').val());
```
3. 对数组或者对象属性进行遍历处理的方法.
```javascript
  $.each(container, callback);	// container表示进行数据操作的上下文，callback为回调函数
  // 回调函数第一个参数为数组元素下标或者对象属性的名称。第二个参数为数组项或者对象属性值.
  var anArray = ['one', 'tow', 'three'];
  $.each(anArray, function(index, ele) { console.log("item " + index + ": value:" + ele); });
```
4. 如果需要对数据中的元素进行筛选(`filter`)，则使用`$.grep()`方法.
```javascript
  // 语法: $.grep(array, callback, invert); 找出anArray中大于2的所有元素.
  var resultArray = $.grep(anArray, function(value) { return value >2; });
```
5. 对数组中的元素进行转换(有些类似java 8中lambda中的数据计算).
```javascript
  var oneBased = $.map([0, 1, 2, 3], function(value) {return value + 1; });
```
6. 判断某个元素是否存在于数组中/将传入的类似数组的对象转换为Javascript数组(DOM元素集合).
```javascript
  // $.inArray(value, array) 返回元素第一次出现时的下标.
  var index = $.inArray(2, [1, 2, 3, 4, 5]);
  // 将dom元素的NodeList转换成为array数组对象.
  var images = document.getElementByTagName("img");
  var imageArray = $.makeArray(images);
```
7. 对dom数组中的元素进行去重`unique()`/对数组进行合并`merge()`.
```javascript
  var uniqueArray = $.unique([1, 3, 4, 5, 3]);  // 最终结果之后包含一个3
  var mergeArray = $.merge(anArray, [2, 4, 6]); // anArray会包含2,4,6的元素
```










