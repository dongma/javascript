#!/usr/bin/env bash

# concept: elasticsearch的搜索是基于JSON文档或者基于URL的请求,请求被发送到服务器. 由于所有搜索请求遵循同样的格式,
# 理解对每个搜索请求所能修改的模块,是非常有帮助的.
# 1.确定搜索范围:所有rest搜索请求使用_search的rest端点,既可以是GET请求也可以是POST请求.
curl 'localhost:9200/_search' -d ''
# 搜索get-together索引中符合条件的记录
curl 'localhost:9200/get-together/_search' -d ''
# 搜索get-together索引的event类型
curl 'localhost:9200/get-together/event/_search' -d ''
# 搜索所有索引中的event类型符合条件的记录
curl 'localhost:9200/all/event/_search' -d ''
# 从所有索引中搜索event类型的记录列表
curl 'localhost:9200/*/event/_search' -d ''
# 从get-together和其它索引中搜索事件和分组类型
curl 'localhost:9200/get-together,other/event,group/_search' -d ''
# 搜索所有名字以get-together开头的索引,但是不包括get-together
curl 'localhost:9200/*get-toge*,-get-together/_search' -d ''