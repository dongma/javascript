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





