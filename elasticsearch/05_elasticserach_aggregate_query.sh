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

