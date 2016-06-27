#!/bin/bash

# Defining env variables
if [ -z "$ELASTICSEARCH_URL"  ] 
then
    echo >&2 'warning: missing ELASTICSEARCH_PORT_9200_TCP or ELASTICSEARCH_URL'
    echo >&2 '  Did you forget to --link some-elasticsearch:elasticsearch'
    echo >&2 '  or -e ELASTICSEARCH_URL=http://some-elasticsearch:9200 ?'
    echo >&2
    exit 1
fi

# Based on https://www.elastic.co/guide/en/kibana/current/getting-started.html
echo "Starting index mapping"

curl -XPUT $ELASTICSEARCH_URL/shakespeare -d '
{
 "mappings" : {
  "_default_" : {
   "properties" : {
    "speaker" : {"type": "string", "index" : "not_analyzed" },
    "play_name" : {"type": "string", "index" : "not_analyzed" },
    "line_id" : { "type" : "integer" },
    "speech_number" : { "type" : "integer" }
   }
  }
 }
}
';


curl -XPUT $ELASTICSEARCH_URL/logstash-2015.05.18 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';


curl -XPUT $ELASTICSEARCH_URL/logstash-2015.05.19 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';


curl -XPUT $ELASTICSEARCH_URL/logstash-2015.05.20 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';


echo "Use the following commands to extract the files"
rm -f *.json
unzip accounts.zip
unzip logs.zip
unzip shakespeare.zip

echo "Loading sample data"
curl -XPOST $ELASTICSEARCH_URL/bank/account/_bulk --data-binary @accounts.json
curl -XPOST $ELASTICSEARCH_URL/shakespeare/_bulk --data-binary @shakespeare.json
curl -XPOST $ELASTICSEARCH_URL/_bulk --data-binary @logs.json

## verify
echo "\n"
echo "Printing indices status"
curl $ELASTICSEARCH_URL/_cat/indices?v

echo "Removing tmp files"
rm *.json