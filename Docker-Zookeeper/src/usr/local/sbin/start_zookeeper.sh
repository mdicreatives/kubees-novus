#! /usr/bin/env bash
#Apache Zookeeper Configurations and service initiation file
#Author @Muhammad Danish

set -eo pipefail

CONFIG_FILE="/opt/zookeeper/conf/zoo.cfg"
ID_FILE="/data/zookeeper/myid"
DATA_DIR="/data/zookeeper"
DATA_LOG_DIR="/data/zookeeper/logs"
CLIENT_PORT="2181"

ZOOKEEPER_ID=${ZOOKEEPER_ID:-1}
echo "ZOOKEEPER_ID=${ZOOKEEPER_ID}"

echo ${ZOOKEEPER_ID} > ${ID_FILE}

echo "clientPort=${CLIENT_PORT}"
echo "clientPort=${CLIENT_PORT}" > ${CONFIG_FILE}

ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME:-2000}
echo "tickTime=${ZOOKEEPER_TICK_TIME}"
echo "tickTime=${ZOOKEEPER_TICK_TIME}" >> ${CONFIG_FILE}

ZOOKEEPER_INIT_TIME=${ZOOKEEPER_INIT_TIME:-5}
echo "initLimit=${ZOOKEEPER_INIT_TIME}" 
echo "initLimit=${ZOOKEEPER_INIT_TIME}" >> ${CONFIG_FILE}

ZOOKEEPER_SYNC_LIMIT=${ZOOKEEPER_SYNC_LIMIT:-2}
echo "syncLimit=${ZOOKEEPER_SYNC_LIMIT}"
echo "syncLimit=${ZOOKEEPER_SYNC_LIMIT}" >> ${CONFIG_FILE}

echo "dataDir=${DATA_DIR}"
echo "dataDir=${DATA_DIR}" >> ${CONFIG_FILE}

echo "dataLogDir=${DATA_LOG_DIR}"
echo "dataLogDir=${DATA_LOG_DIR}" >> ${CONFIG_FILE}

for VAR in `env`
do
  if [[ $VAR =~ ^ZOOKEEPER_SERVER_[0-9]+= ]]; then
    SERVER_ID=`echo "$VAR" | sed -r "s/ZOOKEEPER_SERVER_(.*)=.*/\1/"`
    SERVER_IP=`echo "$VAR" | sed 's/.*=//'`
    if [ "${SERVER_ID}" = "${ZOOKEEPER_ID}" ]; then
      echo "server.${SERVER_ID}=0.0.0.0:2888:3888" >> ${CONFIG_FILE}
      echo "server.${SERVER_ID}=0.0.0.0:2888:3888"
    else
      echo "server.${SERVER_ID}=${SERVER_IP}:2888:3888" >> ${CONFIG_FILE}
      echo "server.${SERVER_ID}=${SERVER_IP}:2888:3888"
    fi
  fi
done

su zookeeper -s /bin/bash -c "/opt/zookeeper/bin/zkServer.sh start-foreground"