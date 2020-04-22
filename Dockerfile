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
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget \
  tzdata \
  curl \
  php-mysql \
  php-cgi \
  php-curl \
  php-dom \
  php-gd \
  php-php-imagick \
  php-xmlrpc \
  php-xsl php-fileinfo php-fpm php-json php-mbstring php-openssl php-session php-simplexml \
  php-xmlwriter phpxlib php-ctype php-gmp php-ldap php-sockets php-posix php-snmp php-gettext \
  rrdtool \
  php-rrd \
  nginx \
  openssl \
  mysql-client \
  snmpd \
  unzip 

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
RUN sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' /etc/periodic/daily/logrotate


RUN mkdir -p /cacti/
RUN curl -o /cacti/cacti.tar.gz -L https://www.cacti.net/downloads/cacti-latest.tar.gz

COPY root/ /

VOLUME /config
EXPOSE 80 443
