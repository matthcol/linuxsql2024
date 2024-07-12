-- DBA queries
select host, user  from mysql.user;
CREATE USER lecteur@'%' IDENTIFIED BY 'password';
select host, user  from mysql.user;
