-- PRESTO
SHOW CATALOGS;

SHOW SCHEMAS FROM hive;
USE hive.default;
SHOW TABLES;

SHOW SCHEMAS FROM tpcds;
USE tpcds.sf1;
SHOW TABLES;

SHOW SCHEMAS FROM postgresql;
USE postgresql.public;
SHOW TABLES;

-- HIVE
CREATE SCHEMA IF NOT EXISTS tpcds;

SHOW TABLES;
DESCRIBE FORMATTED customer;

MSCK REPAIR TABLE customer;

SELECT * FROM customer LIMIT 10;


-- http://mail-archives.apache.org/mod_mbox/hive-dev/201707.mbox/%3CCAKcnr5akLtk+tiJ=VzSEF3YrrDj1xu-aFyEUKZ=KgHTYk+XMNA@mail.gmail.com%3E
set fs.s3.awsAccessKeyId=ABC;
set fs.s3.awsSecretAccessKey=123;

set fs.s3n.awsAccessKeyId=ABC;
set fs.s3n.awsSecretAccessKey=123;


\dt
\q