#!/usr/bin/env bash

# 1.在elasticsearch中通常是不用担心字段映射,因为elasticsearch会自动识别字段,并相应的调整字段.
curl 'localhost:9200/get-together/group/_mapping?pretty'

{
  "get-together" : {
    "mappings" : {
      "group" : {
        "properties" : {
          "created_on" : {
            "type" : "date"
          },
          "description" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "location_group" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "members" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "name" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "organizer" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            },
            "fielddata" : true
          },
          "organizers" : {
            "type" : "text",
            "fielddata" : true
          },
          "tags" : {
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

# 创建一个新的索引类型,在索引中创建新的type
curl -XPUT 'localhost:9200/mapping_events?pretty'
{"acknowledged":true,"shards_acknowledged":true,"index":"mapping_events"}

# 使用elasticsearch索引一个新文档(new-events)类型,然后elasticsearch会自动地创建映射.
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/mapping_events/new-events/1?pretty' -d '{
    "name": "Late Night with Elasticsearch",
    "date": "2013-10-25T19:00"
}'

# 使用restful接口获取索引当前映射(对于新插入的文档,elasticsearch主动将date识别日期类型,将name识别为text类型)
curl 'localhost:9200/mapping_events/_mapping/new-events?pretty'

{
  "mapping_events" : {
    "mappings" : {
      "new-events" : {
        "properties" : {
          "date" : {
            "type" : "date"
          },
          "name" : {
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

# 可以通过put方法定义新的映射,需要在请求体中指定JSON格式的映射,格式和获取的映射相同
# (如果在现有基础上再设置一个映射,elasticsearch会将两者进行合并),在elasticsearch 5.x版本以上已经不存在string类型(使用text进行替换).
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/mapping_events/_mapping/new-events' -d '{
    "new-events": {
        "properties": {
            "host": {
                "type": "text",
                "index": false
            }
        }
    }
}'

{"acknowledged":true}

curl -XPUT 'localhost:9200/mapping_weekly-events?pretty'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "mapping_weekly-events"
}

# 在elasticsearch中使用默认的和定制的时间格式,通过_mapping自定义日期格式(其它日期格式是自动检测的,无需显示定义)
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/mapping_weekly-events/_mapping/weekly-events' -d '{
    "weekly-events": {
        "properties": {
            "next_event": {
                "type": "date",
                "format": "MMMM DD YYYY"
            }
        }
    }
}'

{"acknowledged":true}

# 对于weekly-events类型新创建的映射,使用put方法新增记录(next_event日期格式会按照"MMMM DD YYYY"进行格式化).
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/mapping_weekly-events/weekly-events/1' -d '{
    "name": "elasticsearch news",
    "first_occurence": "2011-04-03",
    "next_event": "Oct 25 2013"
}'

{"_index":"mapping_weekly-events","_type":"weekly-events","_id":"1","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}

curl "localhost:9200/mapping_weekly-events/weekly-events/1?pretty"


# elasticsearch中的数组(存在字段值类型为数组)和多字段(字段数据结构嵌套)
curl -XPUT 'localhost:9200/multi_field_mapping?pretty'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "multi_field_mapping"
}

curl -H "Content-Type:application/json" -XPUT 'localhost:9200/multi_field_mapping/posts/1' -d '{
    "tags": ["first", "initial"]
}'

{"_index":"multi_field_mapping","_type":"posts","_id":"1","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}

# 查看multi_field_mapping中posts类型的字段映射,本质上tags标签也是映射为text类型,与单值对象插入相同
curl 'localhost:9200/multi_field_mapping/_mapping/posts?pretty'

{
  "multi_field_mapping" : {
    "mappings" : {
      "posts" : {
        "properties" : {
          "tags" : {
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

# 无需重新索引数据,就能将单字段升级到多字段,对于已经创建了string类型的标签字段,那么自动升级就会触发.
curl -H "Content-Type:application/json" -XPUT 'localhost:9200/multi_field_mapping/posts/2' -d '{
    "tags": "second"
}'

{"_index":"multi_field_mapping","_type":"posts","_id":"2","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}

curl -H "Content-Type:application/json" -XPUT 'localhost:9200/multi_field_mapping/_mapping/posts' -d '{
    "posts": {
        "properties": {
            "tags": {
                "type": "text",
                "index": true,
                "fields": {
                    "verbatim": {
                        "type": "text",
                        "index": false
                    }
                }
            }
        }
    }
}'

{"acknowledged":true}

# 2.控制如何存储和搜索文档,_source存储原有内容信息._source字段的enabled可以设置为false或者true,来指定是否想要存储原始的文档(默认情况下为true).
# 对于索引数据的策略,_all是索引所有的信息 当搜索_all字段的时候,elasticsearch将在不考虑是哪个字段匹配成功的情况下,返回命中的文档.
curl 'localhost:9200/mapping_weekly-events/weekly-events/1?pretty'

{
  "_index" : "mapping_weekly-events",
  "_type" : "weekly-events",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "_source" : {
    "name" : "elasticsearch news",
    "first_occurence" : "2011-04-03",
    "next_event" : "Oct 25 2013"
  }
}

# 对于识别文档,elasticsearch使用_uid中的文档类型和ID结合体进行检索文档._uid字段由_id和_type字段组成,当搜索或者检索文档的时候总是能够获得这两项信息.
curl 'localhost:9200/mapping_weekly-events/weekly-events/1?_source&pretty'
{
  "_index" : "mapping_weekly-events",
  "_type" : "weekly-events",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "_source" : {
    "name" : "elasticsearch news",
    "first_occurence" : "2011-04-03",
    "next_event" : "Oct 25 2013"
  }
}

# 3.需要为插入的文档提供id,为了让elasticsearch来生成唯一的id,使用Http post请求并省去id(创建新的索引mapping_logs_autoid).
curl -XPUT 'localhost:9200/mapping_logs_autoid?pretty'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "mapping_logs_autoid"
}

# 在通过auto_id生成的文档中,在返回结果中_id是任意生成并返回给rest client.
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/mapping_logs_autoid/auto_id/?pretty' -d '{
    "message": "I have an automatic id"
}'

{
  "_index" : "mapping_logs_autoid",
  "_type" : "auto_id",
  "_id" : "LTryp2sBZDfSKX83lxIR",
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

# 在文档中存储索引的名称,通过索引URL来搜索属于特定索引的文档可能很容易,但是在更为复杂的用例中_index字段可能体现出其价值.
curl 'localhost:9200/_search?q=_index:mapping_weekly-events'
{"took":4,"timed_out":false,"_shards":{"total":54,"successful":49,"skipped":0,"failed":0},"hits":{"total":1,"max_score":1.0,"hits":[{"_index":"mapping_weekly-events","_type":"weekly-events","_id":"1","_score":1.0,"_source":{
    "name": "elasticsearch news",
    "first_occurence": "2011-04-03",
    "next_event": "Oct 25 2013"
}}]}}


# 4.使用文档更新api,通过发送部分文档,增加或替换现有文档的一部分(使用_update的api,更新mapping_events文档中内容).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/mapping_events/new-events/1/_update' -d '{
    "doc": {
        "name": "Late Night with Elasticsearch update api",
        "date": "2013-10-25T19:00"
    }
}'

{"_index":"mapping_events","_type":"new-events","_id":"1","_version":2,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":1,"_primary_term":2}

# 使用curl GET重新查看之前更新过的文档信息(可以看到_version更新到了2.0)
curl 'localhost:9200/mapping_events/new-events/1?pretty'

{
  "_index" : "mapping_events",
  "_type" : "new-events",
  "_id" : "1",
  "_version" : 2,
  "found" : true,
  "_source" : {
    "name" : "Late Night with Elasticsearch update api",
    "date" : "2013-10-25T19:00"
  }
}

# 使用upsert来创建尚不存在的文档,从字面意思看其是update和insert两个单词的混成词(在通过upsert操作后可以看到新插入的文档).
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/mapping_events/new-events/2/_update' -d '{
    "doc": {
        "name": "Late Night with Elasticsearch update api item 2",
        "date": "2013-10-25T19:00"
    },
    "upsert": {
        "name": "Elasticsearch upasert operation",
        "date": "2013-10-25T19:10"
    }
}'

{"_index":"mapping_events","_type":"new-events","_id":"2","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":2}

curl 'localhost:9200/mapping_events/new-events/2?pretty'
{
  "_index" : "mapping_events",
  "_type" : "new-events",
  "_id" : "2",
  "_version" : 1,
  "found" : true,
  "_source" : {
    "name" : "Elasticsearch upasert operation",
    "date" : "2013-10-25T19:10"
  }
}

# 5.通过版本来实现并发控制(index名称online-shop),可以通过版本来管理两个并发的更新(其中一个失败了).
curl -XPUT 'localhost:9200/online-shop?pretty'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "online-shop"
}

curl -H "Content-Type:application/json" -XPUT 'localhost:9200/online-shop/shirts/1?pretty' -d '{
    "caption": "Learning ES",
    "price": 1
}'

{
  "_index" : "online-shop",
  "_type" : "shirts",
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

curl -H "Content-Type:application/json"  -XPOST 'localhost:9200/online-shop/shirts/1/_update' -d '{
    "script": "Thread.sleep(10000); ctx._source.price=2"
}' &
curl -H "Content-Type:application/json"  -XPOST 'localhost:9200/online-shop/shirts/1/_update' -d '{
    "script": "ctx._source.caption=\"Knowing Elasticsearch\""
}'
{"_index":"online-shop","_type":"shirts","_id":"1","_version":2,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":1,"_primary_term":1}

# 冲突发生时自动重试更新操作(可以使用retry_on_conflict进行失败重试)
curl -H "Content-Type:application/json" -XPOST 'localhost:9200/online-shop/shirts/1/_update?retry_on_conflict=3' -d '{
    "script": "ctx._source.price = 2"
}'
{"_index":"online-shop","_type":"shirts","_id":"1","_version":3,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":2,"_primary_term":1}

# 使用elasticsearch查看更新过的文档信息,对于并发控制的文档可以通过版本号version进行检索
curl 'localhost:9200/online-shop/shirts/1?pretty'
{
  "_index" : "online-shop",
  "_type" : "shirts",
  "_id" : "1",
  "_version" : 3,
  "found" : true,
  "_source" : {
    "caption" : "Knowing Elasticsearch",
    "price" : 2
  }
}

curl -H "Content-Type:application/json" -XPUT 'localhost:9200/online-shop/shirts/1?version=3' -d '{
    "caption": "I Know about Elasticsearch Version",
    "price": 5
}'
{"_index":"online-shop","_type":"shirts","_id":"1","_version":4,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":3,"_primary_term":1}


# 6.通过elasticsearch删除数据(通过文档id删除单个文档或者一组文档/删除整个索引/关闭整个索引)
curl -XDELETE 'localhost:9200/online-shop/shirts/1'
{"_index":"online-shop","_type":"shirts","_id":"1","_version":5,"result":"deleted","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":4,"_primary_term":1}

# 可以通过shirts删除整个映射类型,包括映射类型以及查询匹配的文档.
curl -XDELETE 'localhost:9200/online-shop/shirts'
# 删除在online-shop索引中存在关键字elasticsearch的所有文档.
curl -XDELETE 'localhost:9200/online-shop/_query?q=elasticsearch'

# 删除整个索引,需要发送一个DELETE请求到该索引的URL中.通过提供以逗号分隔的列表,还可以删除多个索引(如果将索引名称改为_all,甚至可以删除全部的索引).
# 删除索引是很快的,因为它基本上就是移除了和索引分片相关的文件.和删除单独的文档相比,删除文件系统中的文件更快.
curl -XDELETE 'localhost:9200/online-shop/'

# 关闭索引除了删除索引还可以选择关闭它们.如果关闭了一个索引,就无法通过elasticsearch来读取和写入其中的数据,直到再次打开它.
curl -XPOST 'localhost:9200/online-shop/_close'
# 为了再次将之前关闭的索引打开,只需要将端点换为_open
curl -XPOST 'localhost:9200/online-shop/_open'


