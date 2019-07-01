#!/usr/bin/env bash

# {concept}: elasticsearch的搜索是基于JSON文档或者基于URL的请求,请求被发送到服务器. 由于所有搜索请求遵循同样的格式,
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

# 2.基于URL的搜索请求,基于URL的搜索请求对于快速的curl请求而言是非常有用的,并非所有的搜索特性都是可以用在基于URL的搜索中.
curl 'localhost:9200/get-together/_search?from=2&size=1&pretty'

{
  "took" : 7,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 5,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "name" : "Boulder/Denver big data get-together",
          "organizer" : "Andy",
          "description" : "Come learn and share your experience with nosql & big data technologies, no experience required",
          "created_on" : "2010-04-02",
          "tags" : [
            "big data",
            "data visualization",
            "open source",
            "cloud computing",
            "hadoop"
          ],
          "members" : [
            "Greg",
            "Bill"
          ],
          "location_group" : "Boulder, Colorado, USA"
        }
      }
    ]
  }
}

# 3.改变搜索结果的顺序(按照created_on字段进行降序排序),在不设置大小的时候默认获取数量为10个
curl 'localhost:9200/get-together/_search?sort=created_on:asc&size=1&pretty'

{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 5,
    "max_score" : null,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "5",
        "_score" : null,
        "_source" : {
          "name" : "Enterprise search London get-together",
          "organizer" : "Tyler",
          "description" : "Enterprise search get-togethers are an opportunity to get together with other people doing search.",
          "created_on" : "2009-11-25",
          "tags" : [
            "enterprise search",
            "apache lucene",
            "solr",
            "open source",
            "text analytics"
          ],
          "members" : [
            "Clint",
            "James"
          ],
          "location_group" : "London, England, UK"
        },
        "sort" : [
          1259107200000
        ]
      }
    ]
  }
}

# 在elasticsearch的返回的_source中限制字段,请求匹配所有的文档(可以在url中限制返回的字段).因为在请求的url进行了限制,
# 因而_source字段列表中返回包含created_on,name,organizer字段.
curl 'localhost:9200/get-together/_search?sort=created_on:asc&_source=created_on,name,organizer&size=1&pretty'

{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 5,
    "max_score" : null,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "5",
        "_score" : null,
        "_source" : {
          "created_on" : "2009-11-25",
          "organizer" : "Tyler",
          "name" : "Enterprise search London get-together"
        },
        "sort" : [
          1259107200000
        ]
      }
    ]
  }
}

# 4.更改结果的排序,请求匹配了所有标题中含有elasticsearch字样的活动(在_source字段中限制name字段值包含elasticsearch的文档).
curl 'localhost:9200/get-together/_search?sort=created_on:asc&_source=created_on,name,organizer&q=name:elasticsearch&size=1&pretty'

{
  "took" : 59,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : null,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : null,
        "_source" : {
          "created_on" : "2012-08-07",
          "organizer" : "Mik",
          "name" : "Elasticsearch San Francisco"
        },
        "sort" : [
          1344297600000
        ]
      }
    ]
  }
}

# 5.之前所有的请求都是基于Url的参数请求,如果使用命令行这是一种很好的交互方式.当执行更多高级搜索的时候,
# 采用基于请求主体的搜索会使得你拥有更多的灵活性和选择性(即使是使用某些基于请求主体的搜索,某些模块同样也可以通过url来提供).
# _source字段可以限制source字段返回的字段列表{"organizer", "name", "created_on"}.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/_search' -d '{
    "query": {
        "match_all": {}
    },
    "_source": ["organizer", "name", "created_on"],
    "from": 2,
    "size": 1
}'

# 使用_source限制返回的字段列表{"organizer", "name", "created_on“}
{"took":3,"timed_out":false,"_shards":{"total":5,"successful":5,"skipped":0,"failed":0},
 "hits":{"total":5,"max_score":1.0,"hits":[{"_index":"get-together","_type":"group","_id":"4","_score":1.0,
 "_source":{"created_on":"2010-04-02","organizer":"Andy","name":"Boulder/Denver big data get-together"}}]}
}

# 对于_source中国的字段列表,可以使用include字段匹配要返回的字段{"name", "organizer"},使用exclude剥离不返回的字段exclude{"created_on", "members"}.
# 在elasticsearch的文档字段列表中包含organizer和name字段,未包含的字段不会记性返回.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/_search' -d '{
    "query": {
        "match_all": {}
    },
    "_source": {
        "include": ["name", "organizer"],
        "exclude": ["created_on", "members"]
    },
    "from": 2,
    "size": 1
}'

{"took":4,"timed_out":false,"_shards":{"total":5,"successful":5,"skipped":0,"failed":0},"hits":{"total":5,"max_score":1.0,
"hits":[{"_index":"get-together","_type":"group","_id":"4","_score":1.0,
"_source":{"organizer":"Andy","name":"Boulder/Denver big data get-together"}}]}
}

# 在elasticsearch中大多数搜索涉及的元素都是结果的排序(sort),如果没有指定sort排序选项,elasticsearch返回匹配文档的时候,按照_score
# 取值的降序来排序,这样最为相关的(得分最高的文档)的文档就会排在前面(按照日期asc、名称desc、_score来排序的结果).
curl -H "Content-Type:application/json" 'localhost:9200/get-together/_search' -d '{
    "query": {
        "match_all": {}
    },
    "sort": [
        {"created_on": "asc"},
        {"name": "desc"},
        "_score"
    ],
    "from": 0,
    "size": 1,
    "_source": ["name", "organizer"]
}'

{"took":3,"timed_out":false,
"_shards":{"total":5,"successful":5,"skipped":0,"failed":0},
"hits":{"total":5,"max_score":null,"hits":[{"_index":"get-together","_type":"group","_id":"5","_score":1.0,
"_source":{"organizer":"Tyler","name":"Enterprise search London get-together"},"sort":[1259107200000,"together",1.0]}]}
}

# 开启get-together索引上启用name字段的fielddata属性(true).
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/get-together/_mapping/group' -d '{
    "group": {
        "properties": {
            "name": {
                "type": "text",
                "fielddata": true
            }
        }
    }
}'

{"acknowledged":true}

# 6.使用查询和过滤器dsl,最基础的match查询和term过滤器
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search' -d '{
    "query": {
        "match": {
            "name": "elasticsearch"
        }
    }
}'

{"took":6,"timed_out":false,"_shards":{"total":5,"successful":5,"skipped":0,"failed":0},
"hits":{"total":2,"max_score":0.87138504,"hits":[{"_index":"get-together","_type":"group","_id":"2","_score":0.87138504,
"_source":{
  "name": "Elasticsearch Denver",
  "organizer": "Lee",
  "description": "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
  "created_on": "2013-03-15",
  "tags": ["denver", "elasticsearch", "big data", "lucene", "solr"],
  "members": ["Lee", "Mike"],
  "location_group": "Denver, Colorado, USA"
}},{"_index":"get-together","_type":"group","_id":"3","_score":0.2876821,"_source":{
  "name": "Elasticsearch San Francisco",
  "organizer": "Mik",
  "description": "Elasticsearch group for ES users of all knowledge levels",
  "created_on": "2012-08-07",
  "tags": ["elasticsearch", "big data", "lucene", "open source"],
  "members": ["Lee", "Igor"],
  "location_group": "San Francisco, California, USA"
}}]}}

