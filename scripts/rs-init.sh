#!/bin/bash

DELAY=25

mongo <<EOF
var config = {
    "_id": "dbrs",
    "version": 1,
    "members": [
        {
            "_id": 1,
            "host": "mongo1:27017",
            "priority": 2
        },
        {
            "_id": 2,
            "host": "mongo2:27017",
            "priority": 1
        },
        {
            "_id": 3,
            "host": "mongo3:27017",
            "priority": 1
        }
    ]
};
rs.initiate(config, { force: true });
EOF

echo "****** Waiting for ${DELAY} seconds for replicaset configuration to be applied ******"

sleep $DELAY

mongo <<EOF
print('Start adding user #################################################################');

use admin;

db.createUser(
  {
    user: "mongoadmin",
    pwd: "mongoadmin",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
  }
);

db = db.getSiblingDB('debezium_test');

db.createUser({
    user: 'debezium',
    pwd: 'dbz',
    roles: [
        {
            role: 'readWrite',
            db: 'debezium_test'
        }
    ]
});
db.createCollection('Merchant');
db.createCollection('Account');

print('User debezium created.');
print('END #################################################################');
EOF