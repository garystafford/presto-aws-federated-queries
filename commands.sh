presto-cli --catalog tpcds --schema sf1

# Create second datasource
aws s3 ls
aws s3api create-bucket --bucket garystaf-prestodb-tpcds-customers

echo """
SELECT
    *
FROM
    tpcds.sf1.customer;
""" >customer.sql

echo """
SELECT
    *
FROM
    tpcds.sf1.customer_address;
""" >customer_address.sql

presto-cli \
  --catalog tpcds \
  --schema sf1 \
  --file customer.sql \
  --output-format CSV_HEADER >customer_quoted.csv

presto-cli \
  --catalog tpcds \
  --schema sf1 \
  --file customer_address.sql \
  --output-format CSV_HEADER >customer_address_quoted.csv

# sed 's/"\([[:digit:]]\+\)"/\1/g' customer_quoted.csv > customer.csv
sed 's/\"//g' customer_quoted.csv > customer.csv
sed 's/\"//g' customer_address_quoted.csv > customer_address.csv

head -5 customer.csv
head -5 customer_address.csv

aws s3 cp customer.csv s3://garystaf-prestodb-tpcds-customers/customer/
aws s3 cp customer_address.csv s3://garystaf-prestodb-tpcds-customers/customer_address/

scp -i "~/.ssh/ahana-presto.pem" ec2-user@ec2-100-24-122-163.compute-1.amazonaws.com:~/customer.csv .

# configure and use Apache Hive
export JAVA_HOME=/usr
export HADOOP_HOME=~/hadoop/
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/*
hive/bin/hive


hive/bin/hive -e """
SELECT
    COUNT(*)
FROM
    tpcds.sf1.customer_address
""" > ~/sample_output.txt