This container expects that the cacti DB to be already created, with correct user permissions to access it and the base schema applied.

My testing has been against MySQL (mariadb should work).

CREATE USER 'cactiuser'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON cacti.* to 'cactiuser'@'%';

# Needed for MySQL (need to test with mariadb?)
ALTER USER 'cactiuser'@'%' IDENTIFIED WITH mysql_native_password BY 'password';

CREATE DATABASE cacti;
mysql -h mysql -u root -p < cacti.sql
