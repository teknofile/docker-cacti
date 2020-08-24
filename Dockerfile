# Needs this old ass version because of phpLDAPadmin incompatibilities
#FROM ubuntu:18.04
FROM wtfo/docker-base-ubuntu-s6:latest

# set version label
ARG BUILD_DATE
ARG VERSION

ENV TZ America/Denver

LABEL build_version="teknofile.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="teknofile <teknofile@teknofile.org>"

RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y wget tzdata 

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl php-mysql php-cgi php-curl php-dom php-gd php-imagick php-xmlrpc php-rrd \
  php-xsl php-fileinfo php-fpm php-json php-mbstring php-simplexml \
  php-xmlwriter php-ctype php-gmp php-ldap php-sockets php-posix php-snmp php-gettext \
  rrdtool nginx openssl mysql-client snmpd unzip cron logrotate snmp-mibs-downloader

RUN echo "*** Configuring NGINX ***"
RUN echo 'fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/fastcgi_params
RUN rm -f /etc/nginx/conf.d/default.conf

RUN echo "*** Fixing logrotate ***"
RUN sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf
RUN sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' /etc/cron.daily/logrotate

# Having reCaptcha issues so just download it before hand and stick here i guess
RUN mkdir -p /cacti/
ADD ./contrib/cacti*gz /cacti/

COPY root/ /

VOLUME /config
EXPOSE 80 443

ENTRYPOINT ["/init"]
