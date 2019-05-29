docker network create mysqlnet

for N in 1 2 3
do docker run -d --name=node$N --net=mysqlnet --hostname=node$N \
  -v $PWD/d$N:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mypass \
  mysql/mysql-server:8.0 \
  --server-id=$N \
  --log-bin='mysql-bin-1.log' \
  --enforce-gtid-consistency='ON' \
  --log-slave-updates='ON' \
  --gtid-mode='ON' \
  --transaction-write-set-extraction='XXHASH64' \
  --binlog-checksum='NONE' \
  --master-info-repository='TABLE' \
  --relay-log-info-repository='TABLE' \
  --plugin-load='group_replication.so' \
  --relay-log-recovery='ON' \
  --group-replication-start-on-boot='OFF' \
  --group-replication-group-name='aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' \
  --group-replication-local-address="node$N:33061" \
  --group-replication-group-seeds='node1:33061,node2:33061,node3:33061' \
  --loose-group-replication-single-primary-mode='OFF' \
  --loose-group-replication-enforce-update-everywhere-checks='ON'
done
