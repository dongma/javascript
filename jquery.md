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

### jQuery选择器的使用，以及对包装集合操作的函数.
常用选择器：`#specialId` 匹配id为specialID的元素；`.specialClass` 匹配所有拥有CSS类specialClass的元素；`a#specialID.specialClass` 匹配id为specialID并且拥有CSS类`specialClass`的链接元素；p a.specialClass 匹配所有拥有CSS类specialClss的链接元素并且这个元素是<p>的子节点.
1. 确定包装集大小 `$(selector).size()`方法/ 从包装集中获取元素的 `$(selector).get(index)`方法.
```javascript
  $('img').size();  // 从当前上下稳重获取img元素的个数.
  $('img').get(index); // 从selector包装集中获取第n个元素.
```
2. 从包装集中查找指定的元素`eq(index)`/`first()`/`last()`,最终的返回结果还是为包装集.
```javascript
  var divWrapper = $('div').eq(1);   // 从jquery选择的集合中获取index为1的元素.
  var firstWrapper = $('div').first(); // 从选择器集合中获取第一个元素.
  var lastWrapper = $('div').last();   // 从选择器中获取最后一个元素. 
```
3. 将包装集中的元素转化为dom数组的方式.
```javascript
  // 该语句会收集页面上<label>元素后面同级节点的所有<button>元素，将它们封装成jQuery包装器，然后创建由这些<button>元素组成的JavaScript数组，将其赋值给allLabeledButtons变量.
  var allLabeledButtons = $('label+button').toArray();
```
4. 获取元素在特定包装集中的下标`index(element)`，或者返回包装集中的第一个元素在同级节点中的下标。如果没有找到该元素则返回-1。
```javascript
  var n = $('img').index($('img#findMe')[0]);
```
5. 创建包装集的副本并向其中添加由`expression`参数指定的元素。expression可以是选择器\html片段\dom元素\dom数组元素。可以使用add()方法将多个选择器链接起来，从而扩充包装集。
```javascript
  // add(expression, context),该js方法会选中拥有alt或title特性的所有图片.
  $('img[alt]').add('img[title]');  
```
6. 通过`.not(expression)`方法创建包装集的副本，从中删除那些与expression参数值指定的标准都相匹配的元素.
```javascript
  //从jquery选择器的包装集中过滤掉不包含CSS类的元素. 
  $('img').not(function() { return !$(this).hasClass('keepMe'); });
```
7. `.filter(expression)`创建包装集，并从中删除与expression参数值指定的标准不匹配的元素集合参数.
```javascript
  // 这个链式语句选择所有的图片,并对所有图片应用CSS类seeThrough，然后只保留集合中title特性包含dog文本的图片元素.
  $('img').addClass('seeThrough').filter('title*=dog').addClass('thickBorder');
```
8. `slice(begin, end)`创建并返回新包装集，此包装集包含匹配集中一个连续的部分
```javascript
  $('*').slice(0, 4);	// 返回包装集中的{0, 4}范围的元素.
  // has(test)创建并返回新包装集,此包装集只包含原始包装集中子节点匹配test表达式的元素.
  $('div').has('img[alt]');
```
9. 转换包装集中的元素`$(selector).map(callback)`和遍历包装集中的元素`$(selector).each(iterator)`
```javascript
  // 将页面中所有<div>元素的id值收集到一个JavaScript数组中. 
  var allIds = $('div').map(function() { return (this.id == undefined ? null : this.is; )}).get();
  // each(iterator)遍历匹配集里的所有的元素，为每一个元素调用传入的迭代函数; 回调函数的第一个参数为元素在集合中的下标以及元素本身。当前元素也被称作为函数的上下文this引用.
  $([1, 2, 3]).each(function() { alert(this); });
```
10. 更多处理包装集的方式，jQuery还有一些技巧来允许我们调整包装对象的集合。`find()`方法将包装集中所有元素的后代全部搜索一遍，并返回包含于传入的选择器表达式相匹配的所有元素的新包装集。
```javascript
  // 给定一个包装集变量wrappedSet，就可以获取另外一个有段落中的所有引用(`<cite>元素`)组成的包装集.
  warppedSet.find('p cite');
  // is(Selector)确定包装集中是否存在于传入的选择器表达式相匹配的元素.
  var hasImage = $('*').is('img');	// 这个语句会将变量hasImage的值设置为true，前提是当前DOM中包含图片元素.
```
11. 管理jquery调用链，`end()`和`endSelf()`方法.
```javascript
  // 语法: end()在jQuery方法链中用来将当前包装集回滚到前一个返回的包装集.
  $('img').filter('[title]').hide().end().addClass('anImage'); // filter()方法返回拥有title特定的图片集,但是调用end()方法后会回滚到前一个包装集(包含所有图片的原始集合),该包装集应用了addClass()方法.
  // 语法: endSelf()合并方法链中的前两个包装集;这个语句选择所有的<div>元素并向其添加CSS类a,然后创建一个由这个<div>元素后代中所有的<img>元素组成的新包装集,并向这些<img>元素添加CSS类.
  $('div').addClass('a').find('img').addClass('b').andSelf().addClass('c');
```

### jQuery操作获取/设置元素特性，操作元素的CSS类名/dom元素的内容.
1. 操作元素属性 `attr(name)`/设置特性的值`attr(name, value)`/移除元素的属性attr.
```javascript
  // 语法: attr(name) 返回第一个匹配元素的特性值。如果匹配为空或者第一个元素不存在此特性，则返回undefined.
  $('#myImage').attr('data-custom');  // 获取myImage元素attr上的内容. 	
  // 将包装集中所有元素的已命名的特性设置为传入的值.
  $('*').attr('title', function(index, previousValue) {
    return previousValue + ' I am element ' + index + ' and my name is: '  + (this.id || 'unset')});
  // 语法: attr(attributes) 用传入的对象执行的属性和值来设置匹配集中所有元素相应的特性值.
  $('input').attr({ value: '', title: 'please enter a value'});
  // 删除特性 removeAttr(name) 从每个匹配元素中删除指定的特性.
  $('input').removeAttr('title');
```
2. 在元素上存储自定义的数据`data(name, value)`/`data(name)`/`removeData(name)`删除之前保留的数据.
```javascript
  // data(name, value) 将传入的值添加到位所有包装元素准备的jQuery托管数据仓库中.
  $('img').data(name, value);
  // 获取所选包装集的第一个元素上保存的dataName对应的数据值.
  $('img').data(dataName);
  // 从所选包装集所有元素中移除之前保存的dataName数据.
  $('img').removeData(dataName);
```
3. 改变元素的样式可以添加或者删除一个类名，使得现有的样式表基于新的类来重新设置元素的样式。也可以操作dom元素直接为其应用样式。
```javascript
  // 语法: addClass(names) 为包装集中的所有元素添加指定的单个或者多个类名.
  $('img').addClass('border-gray');
  // 语法: removeClass(names) 从包装集中的每个元素上删除指定的单个或多个类名.
  $('img').removeClass('border-gray');
  // 语法: toggleClass(names) 如果元素不存在指定类名则为其添加此类名，如果元素已经拥有这个类名则从中删除此类名.
  function() { $('tr').toggleClass('striped'); }
  // 语法: hasClass(name) 确定匹配集中是否有元素拥有通过name参数传入的类名,如果存在则返回true否则返回false.
  $('p:first').hasClass('surpriseMe');
```
4. 设置样式`css()`
```javascript
  // 语法: css(name,value) 设置每个匹配元素的已命名css样式属性为指定的值.
  $('div.expandable').css('width', function(index, currentWidth) { return currentWidth+20; });
  // 语法: css(properties) 设置所有匹配元素的css属性为传入对象的多个键值.
  $('img').css({ cursor: 'pointer', border: '1px solid black', padding: '12px 12px 20px 12 px', backgroundColor: white});
  // 语法: css(name) 获取包装集中第一个元素的css属性的已计算值，这个css属性由name指定.
  $('img').csss('border');
  // 获取元素的width()和hight(),如果携带有参数则是设置元素的数值(下面两个语句是互相等价的).
  $('div.myElements').width(500);
  $('div.myElements').css("witdh", 500);
```
5. 设置元素的内容.
```javascript
  // html()/html(content)方法设置元素的内容为content，text()/text(content)设置所有包装元素的文本内容为传入的值，则这些字符会被替换为其相应的Html实例字符.
  // html()与text()方法的区别在于html操作元素内容可以为html代码,而text则是纯文本值.
  var text = $('#theList').text();
```
6. 移动和复制元素 `append(content)`/`prepend(content)`将传入的html片段或者元素添加到所匹配元素的内容开头；`before(content)`/`after(content)`将传入html片段或者元素插入为目标元素的兄弟节点，位于目标元素之前。
```javascript
  $('p').append('<b>some text</b>');
```
7. 移动操作集合中的所有元素*作为一个整体*添加到`targets`后面。`appendTo(targets)`/`prependTo(targets)`
```javascript
  $('img').appendTo(targets);
```
8. 包裹`wrap(wrapper)`与反包裹`wrapAll(wrapper)`. `wrapInner(wrapper)`或者`unwrap()`删除包装元素的父元素。子元素和其所有的同级节点一起替换了DOM中的父元素.
```javascript
  // 用法: 使用html标签或者元素副本将匹配集中的元素包裹起来.
  $('a.surprise').wrap($('div:first')[0]"));
  // 用法: 使用传入的html标签或者元素副本,将匹配集中的元素作为一个整体包裹起来.
  $('a.surprise').wrapAll($('div:first')[0]);
  // 使用传入的html标签或者元素的副本,将匹配集中的元素content内容包裹起来.
  $('a.surprise').wrapInner($('div:first')[0]);
```
9. 删除元素`remove(selector)`从页面dom中剔除包装集中的所有元素.
```javascript
  // 语法: remove(selector) 从页面dom中删除包装集中的所有元素.
  $('img').remove(selector);
  // 语法: detach(selector) 从页面dom中删除包装集中的所有元素，保留绑定的时间和jQuery数据.
  $('img').detach(selector);
  // empty() 删除匹配集中的所有dom元素的内容.
  $('img').empty();
```
10. 复制`clone()`与替换元素`replaceWith()`
```javascript
  // clone(copyHeaders) 创建包装集中的元素的副本,并返回包含这些副本的新包装集。这些元素和任何子节点都会被复制.
  $('img').clone().appendTo('fielfset.photo');
  $('ul').clone().insertBefore('#here');
  // replaceWith(content) 使用指定的内容替换每个匹配元素.
  $('img[alt]').each(function() { $(this).replaceWith('<span>' + $(this).attr('alt') + '</span>') });
```



