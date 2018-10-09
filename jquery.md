## jquery前端框架的一些常用函数

概述：在该markdown文档中主要整理一些jquery操作数据集合/ajax发起异步请求/操作dom元素的函数；后期可能会加上jquery选择器的内容；
- 关于操作数据集合部分data：
1. 对于jquery前端库与其它使用到$符号的库解决冲突的函数：
```javascript
  $.noConflict();	// 当使用此函数之后，调用jquery的方法的时候只能使用jQuery前缀符号.
```
2. 对javascript对象的字符串进行修剪，返回的结果为去除字符串开头和结尾的空白字符。
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