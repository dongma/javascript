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

