#!/usr/bin/env bash

# 1.使用curl创建索引和映射类型 (http的put方法会创建新的索引)
curl -XPUT 'localhost:9200/new-index'
{"acknowledged":true,"shards_acknowledged":true,"index":"new-index"}

# 2.使用curl命令索引第一个聚会分组文档 (index名称为group)
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/get-together/group/1?pretty' -d '{
    "name": "Elasticsearch Denver",
    "orgnanizer": "Lee"
}'

{
  "_index" : "get-together",
  "_type" : "group",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}

# 3.使用curl获取elasticsearch的映射_mapping (elasticsearch 6.x会默认将organizer、name字段映射识别为text)
curl 'localhost:9200/get-together/_mapping/group?pretty'

{
  "get-together" : {
    "mappings" : {
      "group" : {
        "properties" : {
          "name" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "orgnanizer" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          }
        }
      }
    }
  }
}

# 4.在Url中指出查询:在get-together索引的group类型中进行查询,q参数表明需要配置的文本,fields指明了返回字段列表(name,location)
# size用于表明返回文档的数量(Elasticsearch 5.x版本与6.x版本字段限制存在不同).
curl "localhost:9200/get-together/group/_search?q=elasticsearch&fields=name,location&size=1&pretty"

curl "localhost:9200/get-together/group/_search?q=elasticsearch&_source=name,location&size=1&pretty"
{
  "took" : 96,
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
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "name" : "Elasticsearch Denver"
        }
      }
    ]
  }
}

# 通常一个查询在某个字段上运行,如q=name:elasticsearch,当在查询时不指定字段时,elasticsearch默认使用称为_all的字段,
# _source限制返回字段列表,size表示返回匹配文档的个数.
curl "localhost:9200/get-together/group/_search?q=name:elasticsearch&_source=name,location&size=1&pretty"

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
    "total" : 2,
    "max_score" : 0.87138504,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 0.87138504,
        "_source" : {
          "name" : "Elasticsearch Denver"
        }
      }
    ]
  }
}


# 5.可以通过Url中的Index名称告诉elasticsearch在那个索引进行搜索数据
curl "localhost:9200/get-together/group,event/_search?q=elasticsearch&pretty&pretty"
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
      },
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

# 6.指定在检索文档的位置,同样的可以某个索引的多个类型中搜索 (只指定了索引未指定type类型)
curl "localhost:9200/get-together/_search?q=elasticsearch&pretty"

# 可以同时在多个索引中进行数据搜索 ("type" : "index_not_found_exception")索引未创建
curl "localhost:9200/get-together,event-index/_search?q=elasticsearch&pretty"

{
  "took" : 6,
  "timed_out" : false,
  "_shards" : {
    "total" : 10,
    "successful" : 10,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 1.0114802,
    "hits" : [
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "103",
        "_score" : 1.0114802,
        "_source" : {
          "host" : "Lee",
          "title" : "Introduction to Elasticsearch",
          "description" : "An introduction to ES and each other. We can meet and greet and I will present on some Elasticsearch basics and how we use it.",
          "attendees" : [
            "Lee",
            "Martin",
            "Greg",
            "Mike"
          ],
          "date" : "2013-04-17T19:00",
          "location_event" : {
            "name" : "Stoneys Full Steam Tavern",
            "geolocation" : "39.752337,-105.00083"
          },
          "reviews" : 5
        }
      },
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
      },
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

# 可以使用Ignore_unavailable标记来忽略这种错误（在Elasticsearch 6.x中每个索引下最多只能有一个type）
curl "localhost:9200/get-together,event-index/_search?q=elasticsearch&ignore_unavailable&size=1&pretty"

{
  "took" : 3,
  "timed_out" : false,
  "_shards" : {
    "total" : 10,
    "successful" : 10,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 1.0114802,
    "hits" : [
      {
        "_index" : "event-index",
        "_type" : "event",
        "_id" : "103",
        "_score" : 1.0114802,
        "_source" : {
          "host" : "Lee",
          "title" : "Introduction to Elasticsearch",
          "description" : "An introduction to ES and each other. We can meet and greet and I will present on some Elasticsearch basics and how we use it.",
          "attendees" : [
            "Lee",
            "Martin",
            "Greg",
            "Mike"
          ],
          "date" : "2013-04-17T19:00",
          "location_event" : {
            "name" : "Stoneys Full Steam Tavern",
            "geolocation" : "39.752337,-105.00083"
          },
          "reviews" : 5
        }
      }
    ]
  }
}


# 7.如何在elasticsearch中搜索数据,虽然可以通过在Url中拼接请求的参数,但是存在安全问题.
# elasticsearch本身支持使用JSON格式指定所有的搜索条件,可以通过发送JSON查询来搜索关于所有elasticsearch的分组(group)
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "query_string": {
            "query": "elasticsearch",
            "default_field": "name",
            "default_operator": "OR"
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
      },
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


# 8.使用elasticsearch的term查询以及查询过滤器filtered,term查询是非评分查询(不会进行分词),在效率上会比较高.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "term": {
            "name": "elasticsearch"
        }
    }
}'

# 使用elasticsearch中的过滤器查询数据(查询结果与同样词条查询相同, filtered查询在elasticsearch 5.0版本中被移除)
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "filtered": {
            "filter": {
                "term": {
                    "name": "elasticsearch"
                }
            }
        }
    }
}'

curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "query": {
        "bool": {
            "filter": {
                "term": {
                    "name": "elasticsearch"
                }
            }
        }
    }
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
    "total" : 2,
    "max_score" : 0.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "2",
        "_score" : 0.0,
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
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "3",
        "_score" : 0.0,
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

# 使用elasticsearch进行应用数据聚集(词条聚集 terms aggregation),除了查询和过滤还可以通过聚集进行各种统计.
curl -H "Content-Type:application/json" 'localhost:9200/get-together/group/_search?pretty' -d '{
    "aggregations" : {
        "organizers": {
            "terms": {"field": "organizer"}
        }
    }
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
    "total" : 5,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "5",
        "_score" : 1.0,
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
      },
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
      },
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
      },
      {
        "_index" : "get-together",
        "_type" : "group",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
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
  },
  "aggregations" : {
    "organizers" : {
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

# 在elasticsearch的5.x版本后,对排序、聚合这些操作用单独的数据结构(fielddata)缓存到内存里,需要进行单独开启。
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/get-together/_mapping/group?pretty' -d '{
  "properties": {
    "organizer": {
      "type":     "text",
      "fielddata": true
    }
  }
}'

{"acknowledged": true}


# 9.最简单的通过id获取elasticsearch中的文档数据,使用Http Get请求. 如果通过elasticsearch检索到了数据,在返回结果中
# found字段的值为true,此外还包括其版本和源数据.
curl 'localhost:9200/get-together/group/1?pretty'

{
  "_index" : "get-together",
  "_type" : "group",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "_source" : {
    "name" : "Denver Clojure",
    "organizer" : [
      "Daniel",
      "Lee"
    ],
    "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
    "created_on" : "2012-06-15",
    "tags" : [
      "clojure",
      "denver",
      "functional programming",
      "jvm",
      "java"
    ],
    "members" : [
      "Lee",
      "Daniel",
      "Mike"
    ],
    "location_group" : "Denver, Colorado, USA"
  }
}


