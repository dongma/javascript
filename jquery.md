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
8. 扩展对象/通过该方法可以对javascript对象执行复制的操作，将后续对象的属性复制到target对象上.
```javascript
  // 语法: $.extend(deep, target, source1, source2,...sourceN) deep表示是否执行深复制默认为false,最终的结果会将sourceN的属性复制到target对象上.
  var target = { a:1, b:2, c:3};
  var source1 = { c:4, d:5, e:6};
  var source2 = { e:7, f:8, g:9};
  $.extend(target, source1, source2); // 最终target会包含source1和source2的属性,且属性值为最后复制的属性的值.
```
9. 在ajax与后台交互的时候，通常需要将传递的参数进行序列化放置乱码.
```javascript
  // 语法: $.param(params, traditional) params的值可以为json字符串或者jquery包装集, traditional为可选参数默认为false.
  $.param({"a thing":'id&s=value', "another thing": 'another value', "weired characters": '*+=='});
```
10. 测试一个元素是否包含在另一个元素内部时，就可以使用jQuery提供的`$.contains()`使用函数.
```javascript
  // 语法: $.contains(container, containee) 如果container中包含containee则返回true否则为false.
  $.contains(target, source2);
```
11. 对于获取了dom元素引用的情况下，可以使用底层的`$.data()`对元素进行`name`属性进行赋值；也可以通过一个实用的函数来删除name属性.
```javascript
  // 语法: $.data(element, name, value) element表示dom元素,name表示元素上的属性名称.
  $.data(textNode, propertyName, value);
  // 语法: 将元素的name属性从element元素上进行移除.
  $.removeData(element, name);
```
12. jquery解析`json`字符串，原生的javascript使用`eval()`对json进行解析.
```javascript
  // 语法:解析传入的json字符串并返回计算值.
  $.parseJSON(json);
```

### jquery发起异步请求ajax的使用.
ajax是新一波dom脚本应用程序的关键部分，jquery也非常乐意提供了一组丰富工具集供我们使用。对于加载Html内容到DOM元素，提供了`load()`方法，使用`GET`还是`POST`方法取决于如何提供传递到服务器的参数数据。
1. 使用`$.load()`从服务器端加载资源内容.
```javascript
  // 语法: $.load(url, parameters, callback) parameters可以为字符串或者对象，如果是指定为对象或者数组，则使用POST方法发起请求。如果省略或者指定为字符串则默认使用GET请求.
  $('.injectMe').load('/jqia2/action/fetchProductDetails', {style: $(event.target).val()}, function() {$('[value=""]', event.target).remove(); });
```
2. 如果作为请求发送的数据来自于*表单控件*，则用来帮助创建查询字符串的jQuery方法为`serialize()`；如果想要以JavaScript数组的形式来获取表单数据，则可以使用jQuery的`serializeArray()`方法.
```javascript
  // 语法: serialize() 根据包装集中所有成功元素或者包装集表单中所有成功的表单元素，创建正确格式化和编码的查询字符串.
  var queryString = $('form').serialize();
  // 使用serializeArray()将查询的表单组件转换为Array.
  var queryArray = $('form').serializeArray();
```
3. 当需要`GET`方法的时候，jQuery提供了实用函数`$.get()`和`$.getJSON()`；如果从服务器端返回JSON数据，那后者会非常有用。为了强制发起`POST`方法，可以使用`$.post()`使用函数。
```javascript
  // 语法: $.get(url, parameters, callback, type); callback一个可选的回调函数，在请求成功完成时调用。传入回调函数的第一个参数为响应主体(根据设置的type参数来解析响应主体)，第二个参数是文本信息，第三个参数包含对XHR实例的引用。
  // type表示如何解析指定的响应主体(html/text/xml/json或者jsonp)
  $('#bootChooserControl').change(function(event) {
    $.get('/jqia2/action/fetchProductService', { style: $(event.target).val()},
    function(response) { $('#productDetailPane').html(response); })
  });
```
4. 使用指定的URL和作为查询字符串的任何传入的参数来向服务器发起`GET`请求。把响应解析为`JSON`字符串，并且把结果数据传递给回调函数。
```javascript
  // 语法: $.getJSON(url, parameters, callback) callback函数第一个参数是把响应主体作为JSON表示法解析所得到的数据值。第二个参数是状态文本。第三个参数提供了一个队XHR实例的引用.
  $.getJSON('/jqia2/action/fetchProductService', {}, function(response) {console.log('返回的json响应结果为: ' + response);})
```
5. 使用指定的URL和作为请求主体的任何传入参数来向服务器发起POST请求.
```javascript
  // 语法: $.post(url, parameters. callback, type) callback当请求完成时调用的函数。传入回调的第一个参数为响应主体，第二个参数为状态文本，第三个参数提供了对XHR实例的引用。
  $.post('/jqia2/action/updateProductService', {'productdId': 12344, 'productQuantity': 30}, 
  function(response) { console.log('请求服务之后返回的结果为: ' + response); }, 'json');
```
6. 如果想要控制Ajax请求的各种细节，可以利用jQuery提供的名为`$.ajax()`的通用函数进行调用。jQuery同样也提供了一些用于简化ajax调用的方法，`$.ajaxSetup()`对ajax赋予默认值。
```javascript
  // $.ajax(options) 使用传入的选项来发起Ajax请求，以便控制如何创建请求以及如何通知回调.
  $.ajax({'url': '/jquery/action/getProduct', 'type': 'json', 'success': function(response, status){ console.log('响应的status为:' + status + ' ,返回的响应为: response'); } })
  $.ajaxSetup(options);
```












