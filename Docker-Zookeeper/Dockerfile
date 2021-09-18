# Apache Zookeeper
# Author @Muhammad Danish 

FROM openjdk:8-jre-alpine
LABEL name="Zookeeper" version=$ZOOKEEPER_VERSION

ARG ZOOKEEPER_VERSION="3.6.3"
ARG ZOOKEEPER_DOWNLOAD_URL="https://downloads.apache.org/zookeeper/zookeeper-$ZOOKEEPER_VERSION/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz"
ARG ZOOKEEPER_DATA_PATH="/data/zookeeper"
ARG ZOOKEEPER_DATALOGS_PATH="/data/zookeeper/logs"


ADD ./src /

RUN chmod +x /usr/local/sbin/start_zookeeper.sh

RUN mkdir -p $ZOOKEEPER_DATA_PATH
RUN mkdir -p $ZOOKEEPER_DATALOGS_PATH
RUN mkdir -p /opt

RUN apk add --no-cache wget bash

RUN addgroup -S zookeeper \
    && adduser -h ${ZOOKEEPER_DATA_PATH} -G zookeeper -S -H -s /sbin/nologin zookeeper \
    && chown -R zookeeper:zookeeper $ZOOKEEPER_DATA_PATH \
    && chown -R zookeeper:zookeeper $ZOOKEEPER_DATALOGS_PATH

RUN  wget -q -O - $ZOOKEEPER_DOWNLOAD_URL | tar -xvzf - -C /opt \
    && mv /opt/*zookeeper-* /opt/zookeeper \
    && chown -R zookeeper:zookeeper /opt/zookeeper



VOLUME [ "/data/zookeeper" , "/opt/zookeeper/conf" ]

EXPOSE 2181 2888 3888

ENTRYPOINT [ "/usr/local/sbin/start_zookeeper.sh" ]