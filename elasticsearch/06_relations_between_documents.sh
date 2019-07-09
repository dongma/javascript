#!/usr/bin/env bash

# 1.使用curl创建索引和映射类型 (http的put方法会创建新索引类型event-object-index)
curl -XPUT 'localhost:9200/event-object-index'
{"acknowledged":true,"shards_acknowledged":true,"index":"event-object-index"}

curl -H "Content-Type:application/json" 'localhost:9200/event-object-index/event-object/1' -d '{
    "title": "Introduction to objects",
    "location": {
        "name": "Elasticsearch in Action book",
        "address": "chapter 8"
    }
}'
{"_index":"event-object-index","_type":"event-object","_id":"1","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}

# 通过curl查看event-object对象的映射类型(_mapping).
curl 'localhost:9200/event-object-index/_mapping/event-object?pretty'
{
  "event-object-index" : {
    "mappings" : {
      "event-object" : {
        "properties" : {
          "location" : {
            "properties" : {
              "address" : {
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
              }
            }
          },
          "title" : {
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


# 统计elasticsearch中entid字段的最大长度(通过对属性字段长度进行排序得出结果).
# "script": "doc['"'members'"'].values.length"
curl -H "Content-Type:application/json" '192.168.207.23:9210/entdatasource_20190517/doc/_search?pretty' -d '{
    "query": {
        "match_all": {}
    },
    "sort": {
        "_script": {
            "script": "doc['"'creditcode'"'].value.length()",
            "type": "number",
            "order": "desc"
        }
    },
    "_source": ["creditcode", "name"]
}'

# 2.映射并索引嵌套文档,嵌套文档和对象映射看上去差不多(不过其type不是object,而必须是nested).
curl -XPUT 'localhost:9200/group-nested-index'
{"acknowledged":true,"shards_acknowledged":true,"index":"group-nested-index"}

curl -H "Content-Type:application/json" -XPUT 'localhost:9200/group-nested-index/_mapping_group-nested' -d '{
    
}'







