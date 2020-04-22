# Needs this old ass version because of phpLDAPadmin incompatibilities
#FROM lsiobase/nginx:3.11
FROM ubuntu:18.04

# set version label
ARG BUILD_DATE
ARG VERSION

ENV TZ America/Denver

LABEL build_version="teknofile.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="teknofile <teknofile@teknofile.org>"

ARG S6_OVERLAY_VERSION=1.22.1.0

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget tzdata && \
    cd /tmp && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz && \
    tar xzf s6-overlay-amd64.tar.gz -C / && \
    rm s6-overlay-amd64.tar.gz


RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl php-mysql php-cgi php-curl php-dom php-gd php-imagick php-xmlrpc php-rrd \
  php-xsl php-fileinfo php-fpm php-json php-mbstring php-simplexml \
  php-xmlwriter php-ctype php-gmp php-ldap php-sockets php-posix php-snmp php-gettext \
  rrdtool nginx openssl mysql-client snmpd unzip cron vim logrotate net-tools

#RUN echo "*** Adding some fonts ***"
#RUN apk add --no-cache \
#  msttcorefonts-installer \
#  fontconfig \
#  terminus-font \
#  ttf-opensans 

RUN echo "*** Configuring NGINX ***"
RUN echo 'fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/fastcgi_params
RUN rm -f /etc/nginx/conf.d/default.conf

RUN echo "*** Fixing logrotate ***"
RUN sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf
#RUN sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' /etc/periodic/daily/logrotate
RUN sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' /etc/cron.daily/logrotate

# Having reCaptcha issues so just download it before hand and stick here i guess
RUN mkdir -p /cacti/
#RUN curl -o /cacti/cacti.tar.gz -L https://www.cacti.net/downloads/cacti-latest.tar.gz
COPY contrib/cacti-latest.tar.gz /cacti/cacti.tar.gz

COPY root/ /

VOLUME /config
EXPOSE 80 443

RUN echo "**** create abc user and make our folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p \
  /app \
  /config \
  /defaults

ENTRYPOINT ["/init"]
