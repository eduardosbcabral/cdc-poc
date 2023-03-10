# Run environment using docker-compose
```
./startReplicaSetEnvironment.sh
```

# MongoDb Connection String
```
mongodb://mongoadmin:mongoadmin@localhost:27017/?authMechanism=DEFAULT&authSource=admin&directConnection=true
```

# Create MongoDB Connector
```
curl --location 'localhost:8083/connectors/' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data '{
  "name": "debezium_test-connector", 
  "config": {
		"connector.class": "io.debezium.connector.mongodb.MongoDbConnector",
    "tasks.max": "1",
    "mongodb.hosts": "rs0/mongo1:27017",
    "mongodb.user": "mongoadmin",
    "mongodb.password": "mongoadmin",
    "collection.include.list": "debezium_test.Merchant,debezium_test.Account",
    "database.include.list": "debezium_test",
    "mongodb.members.auto.discover": "false",
    "topic.prefix": "debezium_test",
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://schema-registry:8081",
    "value.converter.schema.registry.url": "http://schema-registry:8081",
		"snapshot.mode": "never"
  }
}'
```

# Test MongoDb Connector validations


# List Kafka Connectors
```
curl -H "Accept:application/json" localhost:8083/connectors/
```

# Observations

- Debezium needs to authenticate agains the admin connection since it requires to read from the oplog.
- `mongodb.members.auto.discover`: Needed only when creating the connector if mongo is behind a proxy such as with Docker in this case.
- The avro schemas are created by the connector, it is not needed to create manualy.
- snapshot.mode 'never' is important when you do not need the read events, only the CUD ones.