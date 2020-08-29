-- https://docs.cloudera.com/runtime/7.0.1/using-hiveql/topics/hive-create-s3-based-table.html

CREATE EXTERNAL TABLE `customer`(
  `c_customer_sk` bigint, 
  `c_customer_id` string, 
  `c_current_cdemo_sk` bigint, 
  `c_current_hdemo_sk` bigint, 
  `c_current_addr_sk` bigint, 
  `c_first_shipto_date_sk` bigint, 
  `c_first_sales_date_sk` bigint, 
  `c_salutation` string, 
  `c_first_name` string, 
  `c_last_name` string, 
  `c_preferred_cust_flag` string, 
  `c_birth_day` bigint, 
  `c_birth_month` bigint, 
  `c_birth_year` bigint, 
  `c_birth_country` string, 
  `c_login` string, 
  `c_email_address` string, 
  `c_last_review_date_sk` bigint)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY ',' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3a://garystaf-prestodb-tpcds-customers/customer';