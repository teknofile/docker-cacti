# Needs this old ass version because of phpLDAPadmin incompatibilities
FROM lsiobase/nginx:3.11

# set version label
ARG BUILD_DATE
ARG VERSION

ENV TZ America/Denver

LABEL build_version="teknofile.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="teknofile <teknofile@teknofile.org>"

RUN \
  echo "** Install the runtime packages" && \
  apk add --no-cache --upgrade \
    bash \
    curl \
    php7-pdo_mysql \
    php7-mysqli \
    php7-mysqlnd \
    php7-cgi \
    php7-curl \
    php7-dom \
    php7-gd \
    php7-imagick \
    php7-xmlrpc \
    php7-xsl \
    php7-fileinfo \
    php7-fpm \
    php7-json \
    php7-mbstring \
    php7-openssl \
    php7-session \
    php7-simplexml \
    php7-xmlwriter \
    php7-zlib \
    php7-ctype \
    php7-gmp \
    php7-ldap \
    php7-sockets\ 
    php7-posix \
    php7-snmp \
    php7-gettext \
    librrd \
    rrdtool \
    rrdtool-cached \
    rrdtool-utils \
    git \
    logrotate \
    libressl3.0-libssl \
    nginx \
    openssl \
    unzip

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
