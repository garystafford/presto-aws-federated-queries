CREATE EXTERNAL TABLE `customer_demographics`(
  `cd_demo_sk` bigint,
  `cd_gender` char(1),
  `cd_marital_status` char(1),
  `cd_education_status` char(20),
  `cd_purchase_estimate` integer,
  `cd_credit_rating` char(10),
  `cd_dep_count` integer,
  `cd_dep_employed_count` integer,
  `cd_dep_college_count` integer)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY ',' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3a://prestodb-demo-databucket-v8gbj2fr6vcc/customer_demographics'
-- TBLPROPERTIES (
--   'skip.header.line.count' = '1')