# docker-cacti

Docker-cacti is an implementation of cacti inside of a docker container. This container is based off of s6-overlay and uses much of the same structure as the folks at [linuxserver.io](https://github.com/linuxserver). 
This container, when started stores it's data and state in /config. The cacti application runs behind nginx and the image itself is runs in an alpine image. 

# Running the container

Environment Variables:
| Environment Variable Name |Description  |
|--|--|
|PUID | The UID of the user running in the container that will be mapped to id 0 inside of the container  |
|GUID | The GID of the user running in the container that will be mapped to gid 0 inside of the container |
|MYSQL_HOSTNAME| The `hostname` of the MYSQL server to host the database |
|MYSQL_USERNAME| The `username` to access the MYSQL database |
|MYSQL_PASSWORD| The `password` to access the MYSQL database|
|MYSQL_DATABASE| The `database` name to use |
|TZ| The timezone (i.e. `America/Denver`)|

Running the container:

    docker run -d \
      --name ${DCKR_NAME} \
      -e PUID=$(id -u) \
      -e GUID=$(id -g) \
      -e MYSQL_HOSTNAME="${DCKR_MYSQL_CACTI_HOST}" \
      -e MYSQL_USERNAME="${DCKR_MYSQL_CACTI_USER}" \
      -e MYSQL_PASSWORD="${DCKR_MYSQL_CACTI_PASS}" \
      -e MYSQL_DATABASE="${DCKR_MYSQL_CACTI_DATABASE}" \
      -e TZ="${DCKR_TZ}" \
      -p 20080:80 \
      -p 20443:443 \
      -v /opt/docker/${DCKR_NAME}:/config \
      teknofile/tkf-docker-cacti:latest

## Database Setup

This container does *NOT* automatically configure the SQL database. Users should pre-populate the database following the typical database creation. Once the database and user is created, you can seed the DB with table construction with `mysql -u cactiuser -p cactidb < /config/www/cacti/cacti.sql`. Substitute the appropriate users/DB's etc where necessary. 

## Upgrades

I haven't figured out upgrades yet


