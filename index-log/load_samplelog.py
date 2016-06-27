import time
from datetime import datetime
from random import randint

from elasticsearch import Elasticsearch


es_url = raw_input("Define index name. Default is http://localhost:9200: ") or "http://localhost:9200"
es_index = raw_input("Define index name. Defalt: logstash") or "logstash"
es_doctype = raw_input("Define doc type. Defalt: log") or "log" 

es = Elasticsearch(es_url)

while True:
    doc = {
       'author': 'kimchy',
       'text': 'Sample data generated. Elasticsearch: cool. bonsai cool.',
       'event_date': datetime.now(),
       'elapsed_total': randint(0,1000),
       'elapsed_database': randint(0,500),
       'elapsed_integration': randint(0,200)
    }
    ## create index doc
    res = es.index(index=es_index, doc_type=es_doctype, body=doc)
    print("Created documento ID %s" % res['_id'])
    time.sleep(randint(1, 10))

"""
res = es.get(index="test-index", doc_type='tweet', id=1)
print(res['_source'])

es.indices.refresh(index="test-index")

res = es.search(index="test-index", body={"query": {"match_all": {}}})
print("Got %d Hits:" % res['hits']['total'])
for hit in res['hits']['hits']:
    print(hit["_source"])
"""