CREATE EXTERNAL TABLE `customer_address`(
  `ca_address_sk` bigint,
  `ca_address_id` string, 
  `ca_street_number` bigint, 
  `ca_street_name` string, 
  `ca_street_type` string, 
  `ca_suite_number` string, 
  `ca_city` string, 
  `ca_county` string, 
  `ca_state` string, 
  `ca_zip` bigint, 
  `ca_country` string, 
  `ca_gmt_offset` double, 
  `ca_location_type` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY ',' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3a://garystaf-prestodb-tpcds-customers/customer_address';