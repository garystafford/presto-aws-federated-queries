CREATE EXTERNAL TABLE IF NOT EXISTS `customer_demographics`(
  `cd_demo_sk` bigint,
  `cd_gender` char(1),
  `cd_marital_status` char(1),
  `cd_education_status` char(20),
  `cd_purchase_estimate` integer,
  `cd_credit_rating` char(10),
  `cd_dep_count` integer,
  `cd_dep_employed_count` integer,
  `cd_dep_college_count` integer)
STORED AS PARQUET
LOCATION
  's3a://prestodb-demo-databucket-CHANGE_ME/customer_demographics'
TBLPROPERTIES ('parquet.compression'='SNAPPY');