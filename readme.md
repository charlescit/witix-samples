# Load Sample Data

## App Python 

Para executar essa aplicação de exemplo, basta acessar o diretório e executar o comando abaixo:
```shell
cd sample\index-log
python load_samplelog.py
```
Isso inicia um processo que passa a enviar um documento ao elasticsearch (locahost:9200) a cada ~10 segundos. Abaixo um fragmento de código responsável.
```python
while True:
    doc = {
       'author': 'kimchy',
       'text': 'Sample data generated. Elasticsearch: cool. bonsai cool.',
       'event_date': datetime.now(),
       'elapsed_total': randint(0,1000)
       'elapsed_database': randint(0,500)
       'elapsed_integration': randint(0,200)
    }
    ## create index doc
    res = es.index(index=es_index, doc_type=es_doctype, body=doc)
    print("Created documento ID %s" % res['_id'])
    time.sleep(randint(1, 10))
```

## Kibana Sample Data
Esses scripts carregam os dados no elasticsearch e gráficos no kibana utilizados na documentacao [Getting Started with Kibana] (https://www.elastic.co/guide/en/kibana/4.5/getting-started.html)

```shell
cd samples\demo
./setup_samples.sh

```

## Spring Petclinic (witix-plugins)
O projeto petclini disponível nesse repositório foi configurado para utilizar o witix-plugins que são classes java que facilitam a coleta de dados em um projeto Spring.

Veja mais detalhes da configuracao no [Readme.md](witix-spring-petclinic/readme.md)

## JHipster
O [JHipster](http://jhipster.github.io), stack java para desenvolvimento de microservices, pode ser fáciltime utilizado para testar o envio de dados para o 

Basta criar uma aplicação normalmente utilizando o gerador descrito no link (http://jhipster.github.io/creating-an-app) e na sequencia configurar as propriedades jhipster.logging.enable para true. Isso habilita o envio dos logs

Basta ativar 
```yaml
jhipster:
    # ... outras propriedades
    logging:
        logstash: # Forward logs to logstash over a socket, used by LoggingConfiguration
            enabled: true ## colocar true
            host: localhost ## atenção com o host definido aqui. 
            port: 5000 ## essa porta foi configurada no logstash.conf 
            queueSize: 512
```

## Logstash reindex
Arquivos de configuração que enviam dados para o elasticsearch witix-elasticsearch:9200. Exemplo de utilização abaixo:

```
docker run --net docker_witix -it --link docker_witix-elasticsearch_1:witix-elasticsearch --rm -v "$PWD":/config-dir logstash logstash -f /config-dir/logstash-request.conf
```

Como esse exemplo utiliza o logstash através de uma imagem docker, é necessário fazer o link com o container elasticsearch (--link docker_witix-elasticsearch_1:witix-elasticsearch), além de incluir a configuração de rede (--net)