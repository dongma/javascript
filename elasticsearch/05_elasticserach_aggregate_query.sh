#!/usr/bin/env bash

# 1.使用aggregation对elasticsearch中的文档进行索引,指定聚集类型的词条organizer,限制_source返回的字段包含"organizer"和"name"
# 在请求体内指定要进行聚合的索引名称为top_tags,在返回的结果中最终的聚集索引名称与其相同.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "top_tags": {
            "terms": {
                "field": "organizer"
            }
        }
    },
    "_source": ["organizer", "name"]
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
    "total" : 5,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "5",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Tyler",
          "name" : "Enterprise search London get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Lee",
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Andy",
          "name" : "Boulder/Denver big data get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Mik",
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  },
  "aggregations" : {
    "top_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "lee",
          "doc_count" : 2
        },
        {
          "key" : "andy",
          "doc_count" : 1
        },
        {
          "key" : "daniel",
          "doc_count" : 1
        },
        {
          "key" : "mik",
          "doc_count" : 1
        },
        {
          "key" : "tyler",
          "doc_count" : 1
        }
      ]
    }
  }
}


# 2.运行在查询结果集上的聚集关系,首先检索文档name字段中包含"denver"的文档,然后按照文档的organizer属性对查询到的结果进行分组.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "match": {
            "name": "denver"
        }
    },
    "aggregations": {
        "top_tags": {
            "terms": {
                "field": "organizer"
            }
        }
    },
    "_source": ["organizer", "name"]
}'

{
  "took" : 48,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 0.22920427,
        "_source" : {
          "organizer" : "Lee",
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "4",
        "_score" : 0.1513613,
        "_source" : {
          "organizer" : "Andy",
          "name" : "Boulder/Denver big data get-together"
        }
      }
    ]
  },
  "aggregations" : {
    "top_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "lee",
          "doc_count" : 2
        },
        {
          "key" : "andy",
          "doc_count" : 1
        },
        {
          "key" : "daniel",
          "doc_count" : 1
        }
      ]
    }
  }
}

# 3.统计数据:为了获取请求活动中参与者的数量统计,可以使用doc['members'].values获取参与者数组.对其添加上length属性就会返回参与者数量.
# search_type=count在elasticsearch 6.x中已经被移除,可以使用size:0进行替换.在返回结果中包含了members的最大值、最小值以及平均值.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "members_stats": {
            "stats": {
                "script": "doc['"'members'"'].values.length"
            }
        }
    },
    "size": 0
}'

{
  "took" : 89,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 5,
    "max_score" : 0.0,
    "hits" : []
  },
  "aggregations" : {
    "members_stats" : {
      "count" : 5,
      "min" : 2.0,
      "max" : 3.0,
      "avg" : 2.2,
      "sum" : 11.0
    }
  }
}

# 设置members字段的fielddata属性值为true,在restful结果中返回更新后的metadata内容.
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/get-together/_mapping/group' -d '{
    "group": {
        "properties": {
            "members": {
                "type": "text",
                "fielddata": true
            }
        }
    }
}'

{"acknowledged":true}


# 4.获取文档中活动成员的平均数量,求出文档中members成员数量的平均值.同时还可以使用extended_stats聚集进行高级统计.
# 查询生成了与其匹配的文档集合,二是所有这些统计数据都是通过该文档集合中的数量计算而来的.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "members_avg": {
            "avg": {
                "script": "doc['"'members'"'].values.length"
            }
        }
    },
    "size": 0
}'

{
  "took" : 8,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 5,
    "max_score" : 0.0,
    "hits" : []
  },
  "aggregations" : {
    "members_avg" : {
      "value" : 2.2
    }
  }
}

curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "members_extended_stats": {
            "extended_stats": {
                "script": "doc['"'members'"'].values.length"
            }
        }
    },
    "size": 0
}'

{
  "took" : 5,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 5,
    "max_score" : 0.0,
    "hits" : []
  },
  "aggregations" : {
    "members_extended_stats" : {
      "count" : 5,
      "min" : 2.0,
      "max" : 3.0,
      "avg" : 2.2,
      "sum" : 11.0,
      "sum_of_squares" : 25.0,
      "variance" : 0.16000000000000014,
      "std_deviation" : 0.4000000000000002,
      "std_deviation_bounds" : {
        "upper" : 3.0000000000000004,
        "lower" : 1.4
      }
    }
  }
}

# 使用近似统计计算:考虑每篇文档的人数,使用百分比percentage进行统计[80%~90%]的文档分布数量.
# 在elasticsearch中存在相反的percentile_ranks进行反向操作.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "members_percentiles": {
            "percentiles": {
                "script": "doc['"'members'"'].values.length",
                "percents": [80, 99]
            }
        }
    },
    "size": 0
}'

{
  "took" : 30,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 5,
    "max_score" : 0.0,
    "hits" : [ ]
  },
  "aggregations" : {
    "members_percentiles" : {
      "values" : {
        "80.0" : 2.5,
        "99.0" : 3.0
      }
    }
  }
}


curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "members_percentile_ranks": {
            "percentile_ranks": {
                "script": "doc['"'members'"'].values.length",
                "values": [4, 5]
            }
        }
    },
    "_source": ["members", "name"]
}'

{
  "took" : 5,
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
          "members" : [
            "Clint",
            "James"
          ],
          "name" : "Enterprise search London get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "members" : [
            "Lee",
            "Mike"
          ],
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "members" : [
            "Greg",
            "Bill"
          ],
          "name" : "Boulder/Denver big data get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "members" : [
            "Lee",
            "Igor"
          ],
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  },
  "aggregations" : {
    "members_percentile_ranks" : {
      "values" : {
        "4.0" : 100.0,
        "5.0" : 100.0
      }
    }
  }
}

# 使用cardinality基数对get-together索引进行聚集统计(cardinality).可以在_source字段中设置检索返回的字段列表.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "members_cardinality": {
            "cardinality": {
                "field": "members"
            }
        }
    },
    "_source": ["name", "members"]
}'

{
  "took" : 9,
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
          "members" : [
            "Clint",
            "James"
          ],
          "name" : "Enterprise search London get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "members" : [
            "Lee",
            "Mike"
          ],
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "members" : [
            "Greg",
            "Bill"
          ],
          "name" : "Boulder/Denver big data get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "members" : [
            "Lee",
            "Igor"
          ],
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  },
  "aggregations" : {
    "members_cardinality" : {
      "value" : 8
    }
  }
}


# 5.在elsaticsearch中进行分组查询,根据文档的organizer字段值进行分组(和sql语句中group by语法一致).
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "tags": {
            "terms": {
                "field": "organizer",
                "order": {
                    "_term": "asc"
                }
            }
        }
    },
    "_source": ["name", "organizer"]
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
    "total" : 5,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "5",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Tyler",
          "name" : "Enterprise search London get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Lee",
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Andy",
          "name" : "Boulder/Denver big data get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Mik",
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  },
  "aggregations" : {
    "tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "andy",
          "doc_count" : 1
        },
        {
          "key" : "daniel",
          "doc_count" : 1
        },
        {
          "key" : "lee",
          "doc_count" : 2
        },
        {
          "key" : "mik",
          "doc_count" : 1
        },
        {
          "key" : "tyler",
          "doc_count" : 1
        }
      ]
    }
  }
}

# 返回只包含search的词条创建桶,在进行检索的organizer字段中,对包含有search字段的文档进行分组(其中依据字段为name).
# 对name值中包含有search部分的文档进行分组,创建Bucket对象.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "tags": {
            "terms": {
                "field": "name",
                "include": ".*search.*",
                "order": {
                    "_term": "asc"
                }
            }
        }
    },
    "_source": ["name", "organizer"]
}'

{
  "took" : 10,
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
          "organizer" : "Tyler",
          "name" : "Enterprise search London get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Lee",
          "name" : "Elasticsearch Denver"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Andy",
          "name" : "Boulder/Denver big data get-together"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "name" : "Denver Clojure"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "organizer" : "Mik",
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  },
  "aggregations" : {
    "tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "elasticsearch",
          "doc_count" : 2
        },
        {
          "key" : "search",
          "doc_count" : 1
        }
      ]
    }
  }
}


# 6.显著词条significant_terms聚集就非常有用了,significant_terms聚集更像是terms聚集,它会统计词频.
# 但是结果桶是按照分数来排序的,该分数代表了front文档和background文档之间的百分比差异.
# param mentions: {"attendees": "lee"}前台文档是lee所参加的活动, field需要在文档中相对于整体而言出现更频繁的参与者.
curl -H "Content-Type:application/json" 'localhost:9200/event-index/event/_search?pretty' -d '{
    "query": {
        "match": {
            "attendees": "lee"
        }
    },
    "aggregations": {
        "significant_attendees": {
            "significant_terms": {
                "field": "attendees",
                "min_doc_count": 2,
                "exclude": "lee"
            }
        }
    }
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
    "total" : 3,
    "max_score" : 0.45315093,
    "hits" : [
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "100",
        "_score" : 0.45315093,
        "_source" : {
          "attendees" : [
            "Lee",
            "Troy",
            "Daniel",
            "Tom"
          ]
        }
      },
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "103",
        "_score" : 0.45315093,
        "_source" : {
          "attendees" : [
            "Lee",
            "Martin",
            "Greg",
            "Mike"
          ]
        }
      },
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "102",
        "_score" : 0.2876821,
        "_source" : {
          "attendees" : [
            "Lee",
            "Tyler",
            "Daniel",
            "Stuart",
            "Lance"
          ]
        }
      }
    ]
  },
  "aggregations" : {
    "significant_attendees" : {
      "doc_count" : 3,
      "bg_count" : 4,
      "buckets" : []
    }
  }
}

## error: Set fielddata=true on [attendees] in order to load fielddata in memory by uninverting the inverted index
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/event-index/_mapping/event' -d '{
    "event": {
        "properties": {
            "attendees": {
                "type": "text",
                "fielddata": true
            }
        }
    }
}'

{"acknowledged":true}

## range聚集: range能解决按照数值范围对文档进行分组,文档范围不必是连续的,它们可以是分离的或者是重叠的
# (大多数情况下覆盖所有取值更合理,但是你不一定要那么做).
curl -H "Content-Type:application/json" 'localhost:9200/event-index/event/_search?pretty' -d '{
    "aggregations": {
        "attendees_breakdown": {
            "range": {
                "script": "doc['"'attendees'"'].values.length",
                "ranges": [
                    {"to": 4},
                    {"from": 4, "to": 6},
                    {"from": 6}
                ]
            }
        }
    },
    "_source": ["attendees", "name"]
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
    "total" : 4,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "100",
        "_score" : 1.0,
        "_source" : {
          "attendees" : [
            "Lee",
            "Troy",
            "Daniel",
            "Tom"
          ]
        }
      },
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "101",
        "_score" : 1.0,
        "_source" : {
          "attendees" : [
            "Daniel",
            "Michael",
            "Sean"
          ]
        }
      },
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "103",
        "_score" : 1.0,
        "_source" : {
          "attendees" : [
            "Lee",
            "Martin",
            "Greg",
            "Mike"
          ]
        }
      },
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "102",
        "_score" : 1.0,
        "_source" : {
          "attendees" : [
            "Lee",
            "Tyler",
            "Daniel",
            "Stuart",
            "Lance"
          ]
        }
      }
    ]
  },
  "aggregations" : {
    "attendees_breakdown" : {
      "buckets" : [
        {
          "key" : "*-4.0",
          "to" : 4.0,
          "doc_count" : 1
        },
        {
          "key" : "4.0-6.0",
          "from" : 4.0,
          "to" : 6.0,
          "doc_count" : 3
        },
        {
          "key" : "6.0-*",
          "from" : 6.0,
          "doc_count" : 0
        }
      ]
    }
  }
}

# date_range聚集和range聚集一样运作,除了放在范围定义中的是日期字符串.由于这一点你应该定义日期格式,这样elasticsearch才知道如何翻译
# 你所提供的字符串,并将其转换为日期字符串所存储的形式.
curl -H "Content-Type:application/json" 'localhost:9200/event-index/event/_search?pretty' -d '{
    "aggregations": {
        "date_breakdown": {
            "date_range": {
                "field": "date",
                "format": "YYYY.MM",
                "ranges": [
                    {"to": "2013.07"},
                    {"from": "2013.07"}
                ]
            }
        }
    },
    "_source": ["attendees", "name"],
    "size": 0
}'

{
  "took" : 36,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 4,
    "max_score" : 0.0,
    "hits" : []
  },
  "aggregations" : {
    "date_breakdown" : {
      "buckets" : [
        {
          "key" : "*-2013.07",
          "to" : 1.3726368E12,
          "to_as_string" : "2013.07",
          "doc_count" : 1
        },
        {
          "key" : "2013.07-*",
          "from" : 1.3726368E12,
          "from_as_string" : "2013.07",
          "doc_count" : 3
        }
      ]
    }
  }
}


# 嵌套多桶聚集:为了将一个聚集和另一个嵌套起来,只需要在父聚集类型的同一层,使用aggregations或者aggs键.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations": {
        "top_tags": {
            "terms": {
                "field": "tags.verbatim"
            },
            "aggregations": {
                "groups_per_month": {
                    "date_histogram": {
                        "field": "created_on",
                        "interval":"1M"
                    },
                    "aggregations": {
                        "number_of_members": {
                            "range": {
                                "script": "doc['"'members'"'].values.length",
                                "ranges": [
                                    {"to": 3},
                                    {"from": 3}
                                ]
                            }
                        }
                    }
                }
            }
        }
    },
    "_source": ["attendees", "name"],
    "size": 0
}'

{
  "took" : 8,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 4,
    "max_score" : 0.0,
    "hits" : []
  },
  "aggregations" : {
    "top_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : []
    }
  }
}

# 通过嵌套聚集获得结果分组(想按照特定的分类将排名靠前的结果进行分组时,结果分组是很有用处的).
curl -H "Content-Type:application/json" 'localhost:9200/event-index/event/_search?pretty' -d '{
    "aggregations": {
        "frequent_attendees": {
            "terms": {
                "field": "attendees",
                "size": 2
            },
            "aggregations": {
                "recent_events": {
                    "top_hits": {
                        "sort": {
                            "date": "desc"
                        },
                        "_source": {
                            "include": ["title"]
                        },
                        "size": 1
                    }
                }
            }
        }
    },
    "_source": ["attendees", "name"],
    "size": 0
}'


{
  "took" : 56,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 4,
    "max_score" : 0.0,
    "hits" : []
  },
  "aggregations" : {
    "frequent_attendees" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 10,
      "buckets" : [
        {
          "key" : "daniel",
          "doc_count" : 3,
          "recent_events" : {
            "hits" : {
              "total" : 3,
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "event-index",
                  "_type" : "event",
                  "_id" : "100",
                  "_score" : null,
                  "_source" : {
                    "title" : "Liberator and Immutant"
                  },
                  "sort" : [
                    1378404000000
                  ]
                }
              ]
            }
          }
        },
        {
          "key" : "lee",
          "doc_count" : 3,
          "recent_events" : {
            "hits" : {
              "total" : 3,
              "max_score" : null,
              "hits" : [
                {
                  "_index" : "event-index",
                  "_type" : "event",
                  "_id" : "100",
                  "_score" : null,
                  "_source" : {
                    "title" : "Liberator and Immutant"
                  },
                  "sort" : [
                    1378404000000
                  ]
                }
              ]
            }
          }
        }
      ]
    }
  }
}

# 使用单桶聚集:global聚集帮助我们展示整体的热门标签(单桶聚集还包括filter聚集、missing聚集).
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "match": {
            "name": "elasticsearch"
        }
    },
    "aggregations": {
        "all_documents": {
            "global": {},
            "aggregations": {
                "top_tags": {
                    "terms": {
                        "field": "organizer"
                    }
                }
            }
        }
    },
    "_source": ["name", "organizer"]
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
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 0.2876821,
        "_source" : {
          "organizer" : "Mik",
          "name" : "Elasticsearch San Francisco"
        }
      }
    ]
  },
  "aggregations" : {
    "all_documents" : {
      "doc_count" : 5,
      "top_tags" : {
        "doc_count_error_upper_bound" : 0,
        "sum_other_doc_count" : 0,
        "buckets" : [
          {
            "key" : "lee",
            "doc_count" : 2
          },
          {
            "key" : "andy",
            "doc_count" : 1
          },
          {
            "key" : "daniel",
            "doc_count" : 1
          },
          {
            "key" : "mik",
            "doc_count" : 1
          },
          {
            "key" : "tyler",
            "doc_count" : 1
          }
        ]
      }
    }
  }
}


