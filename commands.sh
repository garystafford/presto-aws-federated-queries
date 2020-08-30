scp -i "~/.ssh/ahana-presto.pem" \
    rds_postgresql.properties \
    ec2-user@ec2-100-24-122-163.compute-1.amazonaws.com:~/

sudo mv rds_postgresql.properties /etc/presto/catalog/

sudo reboot

yes | sudo yum update

presto-cli --catalog tpcds --schema sf1

# Create second datasource
DATA_BUCKET=prestodb-demo-databucket-v8gbj2fr6vcc

aws s3 ls
aws s3api create-bucket --bucket ${DATA_BUCKET}

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

# remove start and end line double quotes
# remove extra spaces on fixed width columns
# removes double quotes between fields
sed -e 's/^\"//g' -e 's/\"$//g' -e 's/ \{0,\}\",\"/,/g' customer_quoted.csv > customer.csv
sed -e 's/^\"//g' -e 's/\"$//g' -e 's/ \{0,\}\",\"/,/g' customer_address_quoted.csv > customer_address.csv

head -5 customer.csv
head -5 customer_address.csv

aws s3 cp customer.csv s3://${DATA_BUCKET}/customer/
aws s3 cp customer_address.csv s3://${DATA_BUCKET}/customer_address/

scp -i "~/.ssh/ahana-presto.pem" ec2-user@ec2-100-24-122-163.compute-1.amazonaws.com:~/customer.csv .

# configure and use Apache Hive
export JAVA_HOME=/usr
export HADOOP_HOME=~/hadoop
export HADOOP_CLASSPATH="${HADOOP_HOME}/share/hadoop/tools/lib/*"
export HIVE_HOME=~/hive
export PATH="${HIVE_HOME}/bin:${HADOOP_HOME}/bin:${PATH}"

hive

java -version
openjdk version "1.8.0_252"
OpenJDK Runtime Environment (build 1.8.0_252-b09)
OpenJDK 64-Bit Server VM (build 25.252-b09, mixed mode)

hadoop version
Hadoop 2.9.2

postgres --version
postgres (PostgreSQL) 9.2.24

psql --version
psql (PostgreSQL) 9.2.24

hive --version
Hive 2.3.7

presto-cli --version
Presto CLI 0.235-cb21100

psql -l

sudo -u ec2-user psql hive

cat /etc/presto/jvm.config
cat /etc/presto/config.properties
cat /etc/presto/node.properties
cat /etc/presto/catalog/rds_postgresql.properties

# Access RDS from psql on presto EC2
export PGPASSWORD=5up3r53cr3tPa55w0rd
psql -h presto-demo.cxauxtdppqiu.us-east-1.rds.amazonaws.com -p 5432 -d shipping \
-U presto