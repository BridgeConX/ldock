FROM phusion/baseimage:0.9.17

MAINTAINER Adam Engebretson <adam.engebretson@bridgeconx.com>
# INSPIRED BY github.com/sameersbn/docker-redis

ENV REDIS_USER=redis \
    REDIS_DATA_DIR=/var/lib/redis \
    REDIS_LOG_DIR=/var/log/redis

RUN apt-add-repository ppa:rwky/redis -y

RUN apt-get update

RUN apt-get install -y redis-server


RUN sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf
RUN sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis/redis.conf
RUN sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf
RUN sed 's/^# unixsocketperm 755/unixsocketperm 777/' -i /etc/redis/redis.conf
RUN sed '/^logfile/d' -i /etc/redis/redis.conf
RUN rm -rf /var/lib/apt/lists/*

COPY build/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 6379/tcp

VOLUME ["${REDIS_DATA_DIR}"]

ENTRYPOINT ["/sbin/entrypoint.sh"]
