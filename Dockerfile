# ARG BASE_IMAGE=stafwag/debian_i386:buster
ARG BASE_IMAGE=debian:bookworm
ARG DEBIAN_FRONTEND=noninteractive
FROM $BASE_IMAGE
LABEL maintainer "staf wagemakers <staf@wagemakers.be>"

RUN apt-get update  -y
RUN apt-get dist-upgrade -y

RUN groupadd librarian -g 50000
RUN useradd librarian -u 50000 -d /home/librarian -s /usr/sbin/nologin -g librarian
RUN mkdir /home/librarian
RUN chown librarian:librarian /home/librarian

RUN apt-get install -y apache2-utils
RUN apt-get install -y ca-certificates
RUN apt-get install -y procps
RUN apt-get install docker-registry

ENV PREFIX=/

RUN mkdir -p ${PREFIX}/etc/docker/registry/
COPY etc/docker/registry/ ${PREFIX}/etc/docker/registry
RUN chown root:librarian ${PREFIX}/etc/docker/registry/*
RUN chmod 640 ${PREFIX}/etc/docker/registry/*

USER librarian
WORKDIR /home/librarian

VOLUME ["/var/lib/registry"]
EXPOSE 5000

ENTRYPOINT ["/usr/bin/docker-registry","serve","/etc/docker/registry/config.yml"]
