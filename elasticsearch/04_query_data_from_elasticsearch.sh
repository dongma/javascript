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

# 6.使用查询和过滤器dsl,最基础的match查询和term过滤器(在评分机制和搜索行为的性能上有所不同,不像查询会为特定的词条计算得分)
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


# 7.过滤器可以比普通的查询更快,而且还可以被缓存,使用过滤器的搜索和使用查询的普通搜索是非常相似的,但需要将查询替换为"filtered"映射
# 在elasticsearch 5.x中filtered过滤器已经被禁用,需使用bool/must/filter进行替换.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": {
                "match": {
                    "name": "elasticsearch"
                }
            },
            "filter": {
                "match": {
                    "organizer": "Lee"
                }
            }
        }
    }
}'

# warning:在elasticsearch中term与match的区别:在查询中term是精确查询、match是模糊查询(term表示完全匹配,也就是精确匹配.
# 搜索前不会再对搜索词进行分词);
# 而match类查询会先对搜索词进行分词,对于基本的Match搜索来说,只要搜索到分词集合中的一个或者多个存在于文档中即可.
{
  "took" : 20,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 0.87138504,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 0.87138504,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  }
}

# term级别查询将按照存储在倒排索引中确切字词进行操作,这些查询通常用于数字、日期和枚举等结构化数据,而不是全文本字段.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": {
                "match": {
                    "name": "elasticsearch"
                }
            },
            "filter": {
                "term": {
                    "created_on": "2012-08-07"
                }
            }
        }
    }
}'

{
  "took" : 3,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 0.2876821,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      }
    ]
  }
}


# 8. elasticsearch中常用的基础查询和过滤器:对于match_all查询,它会匹配所有的文档.主要应用场景:希望使用过滤器(可能完全不关心文档得分)
# 或者是希望返回被搜索的索引和类型中的全部文档(使用match_all会返回get-together索引下group类型的全部文档).
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "match_all": {}
    }
}'

# 使用match_all中的过滤器查询,在搜索中使用过滤器,而不是普通的查询.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": {
                "match_all": {}
            },
            "filter": {
                "term": {
                    "created_on": "2012-08-07"
                }
            }
        }
    }
}'

{
  "took" : 3,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      }
    ]
  }
}

# query_string查询:一个query_string查询既可以通过URL来执行也可以通过请求主体来发送.
curl -XGET 'localhost:9200/get-together/group/_search?q=2013-03-15&pretty'

{
  "took" : 4,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  }
}

# 通过请求主体查询created_on的日期为"2013-03-15"中符合条件的记录(在query_string中指定默认的搜索字段).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "query_string": {
            "query": "2013-03-15",
            "default_field": "created_on"
        }
    }
}'

{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  }
}

# 使用term查询和term过滤器(其可以让你指定需要搜索的文档字段和词条)
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "term": {
            "name": "elasticsearch"
        }
    },
    "size": 1
}'

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
    "total" : 2,
    "max_score" : 0.87138504,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 0.87138504,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  }
}

# 与term查询相类似,还可以使用term过滤器来限制结果文档.使其包含特定的词条,不过无需计算得分(使用term filter后文档得分是常数1.0).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": {
                "match_all": {}
            },
            "filter": {
                "term": {
                    "organizer": "lee"
                }
            }
        }
    },
    "size": 1
}'

{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  }
}

# terms查询:和term查询类似,terms查询可以搜索某个文档字段中锁哥词条(例如搜索了标签含有jvm和hadoop的分组)
# 目前在terms查询中暂时不支持minimum_should_match配置.
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "terms": {
            "members": ["Lee", "Daniel", "Mike", "Igor"],
            "minimum_should_match": 2
        }
    },
    "_source": ["name", "members"]
}'


# 9.match查询和term过滤器: 和term查询类似,match查询时一个散列映射,包含了希望搜索的字符串(返回字段列表["name", "organizer"]).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "match": {
            "name": "elasticsearch"
        }
    },
    "size": 1,
    "_source": ["name", "organizer"]
}'

{
  "took" : 4,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 0.87138504,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 0.87138504,
        "_source" : {
          "organizer" : "Lee",
          "name" : "Elasticsearch Denver"
        }
      }
    ]
  }
}


# 默认情况下,match查询使用布尔行为和OR操作符,对于搜索"elasticsearch denver"词条,其会将elasticsearch和denver词条分开,
# 使用它分别进行搜索匹配的记录(使用And操作符其会将匹配的词拼接起来).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "match": {
            "name": {
                "query": "elasticsearch denver",
                "operator": "and"
            }
        }
    },
    "_source": ["name", "organizer"]
}'

{
  "took" : 15,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.1005893,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.1005893,
        "_source" : {
          "organizer" : "Lee",
          "name" : "Elasticsearch Denver"
        }
      }
    ]
  }
}

# 词组查询行为(pharse):phrase查询时非常有用的,每个单词的位置之间可以留有余地(slop),用于标识词组中多个分词之间的距离.
# 在elasticsearch 6.x版本已经不再支持"match"中使用"type"类型,可以使用"match_phrase"进行替换.
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "match_phrase": {
            "name": {
                "query": "enterprise london",
                "slop": 1
            }
        }
    },
    "_source": ["name", "description"]
}'

{
  "took" : 16,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 0.37229446,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "5",
        "_score" : 0.37229446,
        "_source" : {
          "name" : "Enterprise search London get-together",
          "description" : "Enterprise search get-togethers are an opportunity to get together with other people doing search."
        }
      }
    ]
  }
}


# 使用phrase_prefix查询搜索词组,不过它是和词组中最后一个词条进行前缀匹配(对于提供搜索框中自动完成功能而言,这个行为是非常有用的).
# 可以使用max_expansions来设置最大的前缀扩展数量,这样就可以在合理的时间范围内返回搜索的结果(phrase查询对于接受用户输入来说是很好的选择).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "match_phrase_prefix": {
            "name": {
                "query": "Elasticsearch den",
                "max_expansions": 1
            }
        }
    },
    "_source": ["name"]
}'

{
  "took" : 26,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 2.2011786,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 2.2011786,
        "_source" : {
          "name" : "Elasticsearch Denver"
        }
      }
    ]
  }
}


# multi_match查询和搜索单字段中多个匹配的词条查询,它们的行为表现会非常相像(在文档中搜索name和description字段).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "multi_match": {
            "query": "Elasticsearch hadoop",
            "fields": ["name", "description"]
        }
    },
    "_source": ["name", "description"]
}'

{
  "took" : 74,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 0.87138504,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 0.87138504,
        "_source" : {
          "name" : "Elasticsearch Denver",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 0.2876821,
        "_source" : {
          "name" : "Elasticsearch San Francisco",
          "description" : "Elasticsearch group for ES users of all knowledge levels"
        }
      }
    ]
  }
}


# 10.bool查询允许在单独的查询中组合任意数量的查询,执行的查询子句表明哪些部分是必须(must)匹配、应该匹配(should)、不能匹配(must_not).
# 对于符合should筛选条件可以使用("minimum_should_match":1)进行判定.
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": [
                {
                    "term": {
                        "organizer": "tyler"
                    }
                }
            ],
            "should": [
                {
                    "term": {
                        "organizer": "client"
                    }
                },
                {
                    "term": {
                        "organizer": "andy"
                    }
                }
            ],
            "must_not": [
                {
                    "range": {
                        "created_on": {
                            "lt": "2005-11-25"
                        }
                    }
                }
            ]
        }
    }
}'

{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "5",
        "_score" : 0.2876821,
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
        }
      }
    ]
  }
}

# 11.bool查询过滤器版本和查询版本基本一致,只是它组合的是过滤器而不是查询.
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": [
                {
                    "term": {
                        "organizer": "tyler"
                    }
                },
                {
                    "range": {
                        "created_on": {
                            "gte": "2005-11-25"
                        }
                    }
                }
            ]
        }
    }
}'

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
    "total" : 1,
    "max_score" : 1.287682,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "5",
        "_score" : 1.287682,
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
        }
      }
    ]
  }
}


# 12.range查询和range过滤器(使用range查询查找created_on在"2012-06-01“~"2016-09-01")的文档
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "range": {
            "created_on": {
                "gt": "2012-06-01",
                "lt": "2016-09-01"
            }
        }
    },
    "_source": ["created_on", "name"]
}'

{
  "took" : 21,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "created_on" : "2013-03-15",
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "created_on" : "2012-06-15",
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "created_on" : "2012-08-07",
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  }
}

# 使用filter的range过滤器,查找文档创建时间在(2012-06-01~2016-09-01)的所有文档.
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": {
                "match_all": {}
            },
            "filter": {
                "range": {
                    "created_on": {
                        "gt": "2012-06-01",
                        "lt": "2016-09-01"
                    }
                }
            }
        }
    },
    "_source": ["name", "created_on"]
}'

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
    "total" : 3,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "created_on" : "2013-03-15",
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "created_on" : "2012-06-15",
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "created_on" : "2012-08-07",
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  }
}


# prefix查询和过滤器,和term查询类似:prefix查询和过滤器允许你根据指定的前缀搜索词条
# (对于event-index的索引,匹配所有以liber开头的文档).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/event-index/event/_search?pretty' -d '{
    "query": {
        "prefix": {
            "title": "liber"
        }
    }
}'

# 使用event-index索引过滤器进行检索文档(使用bool/must/filter组合检索文档).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/event-index/event/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": {
                "match_all": {}
            },
            "filter": {
                "prefix": {
                    "title": "liber"
                }
            }
        }
    }
}'

{
  "took" : 14,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "100",
        "_score" : 1.0,
        "_source" : {
          "host" : [
            "Lee",
            "Troy"
          ],
          "title" : "Liberator and Immutant",
          "description" : "We will discuss two different frameworks in Clojure for doing different things. Liberator is a ring-compatible web framework based on Erlang Webmachine. Immutant is an all-in-one enterprise application based on JBoss.",
          "attendees" : [
            "Lee",
            "Troy",
            "Daniel",
            "Tom"
          ],
          "date" : "2013-09-05T18:00",
          "location_event" : {
            "name" : "Stoneys Full Steam Tavern",
            "geolocation" : "39.752337,-105.00083"
          },
          "reviews" : 4
        }
      }
    ]
  }
}


# 使用elsticsearch中的wildcard通配符查询(创建新类型的索引,然后使用wildcard查询文档).
curl -XPUT 'localhost:9200/wildcard-test'
{"acknowledged":true,"shards_acknowledged":true,"index":"wildcard-test"}

curl -H "Content-Type:application/json" -XPOST 'localhost:9200/wildcard-test/doc/1' -d '{
    "title": "The Best Bacon Ever"
}'
{"_index":"wildcard-test","_type":"doc","_id":"1","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}

curl -H "Content-Type:application/json" -XPOST 'localhost:9200/wildcard-test/doc/2' -d '{
    "title": "How to raise a barn"
}'
{"_index":"wildcard-test","_type":"doc","_id":"1","_version":2,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":1,"_primary_term":1}

# 分别使用*和?通配符匹配文档内容.
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/wildcard-test/doc/_search?pretty' -d '{
    "query": {
        "wildcard": {
            "title": {
                "wildcard": "ba*n"
            }
        }
    }
}'

{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "wildcard-test",
        "_type" : "doc",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "title" : "How to raise a barn"
        }
      },
      {
        "_index" : "wildcard-test",
        "_type" : "doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "title" : "The Best Bacon Ever"
        }
      }
    ]
  }
}

curl -H "Content-Type:application/json" -XPOST 'localhost:9200/wildcard-test/doc/_search?pretty' -d '{
    "query": {
        "wildcard": {
            "title": {
                "wildcard": "ba?n"
            }
        }
    }
}'

{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "wildcard-test",
        "_type" : "doc",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "title" : "How to raise a barn"
        }
      }
    ]
  }
}

# 13.使用过滤器查询字段的存在性,exist过滤器可以用于查找缺乏某个字段或者确实某个字段值的全部文档.
# 也可以使用missing过滤器进行筛选文档内容(缺失某个字段或者字段值为null的记录),可以使用_cache选项缓存过滤器查询后的结果.
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/_search?pretty' -d '{
    "query": {
        "bool": {
            "must": {
                "match_all": {}
            },
            "filter": {
                "exists": {"field": "location_group"}
            }
        }
    },
    "_source": ["location_group", "name"]
}'

{
  "took" : 6,
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
        "_id" : "5",
        "_score" : 1.0,
        "_source" : {
          "location_group" : "London, England, UK",
          "name" : "Enterprise search London get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "location_group" : "Denver, Colorado, USA",
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "location_group" : "Boulder, Colorado, USA",
          "name" : "Boulder/Denver big data get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "location_group" : "Denver, Colorado, USA",
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "location_group" : "San Francisco, California, USA",
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  }
}

# 在elasticsearch 6.x中对filter查询结果进行cache(仍待研究).
#curl -H "Content-Type:application/json" -XPOST 'localhost:9200/get-together/_search?pretty' -d '{
#    "query": {
#        "bool": {
#            "must": {
#                "match_all": {}
#            },
#            "filter": {
#                "query_string": {
#                    "name": "denver clojure"
#                },
#                "_cache": true
#            }
#        }
#    },
#    "_source": ["location_group", "name"]
#}'

