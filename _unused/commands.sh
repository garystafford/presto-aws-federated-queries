EC2_ENDPOINT=ec2-34-231-243-251.compute-1.amazonaws.com
 # or

 EC2_ENDPOINT=$(\
  aws ec2 describe-instances \
      --filters "Name=product-code,Values=ejee5zzmv4tc5o3tr1uul6kg2" \
          "Name=product-code.type,Values=marketplace" \
      --query "Reservations[*].Instances[*].{Instance:PublicDnsName}" \
      --output text)


scp -i "~/.ssh/ahana-presto.pem" \
  properties/rds_postgresql.properties \
  ec2-user@${EC2_ENDPOINT}:~/

ssh -i "~/.ssh/ahana-presto.pem" ec2-user@${EC2_ENDPOINT}

yes | sudo yum update
yes | sudo yum install htop

# https://prestodb.io/docs/current/connector/hive.html
echo """connector.name=hive-hadoop2
hive.metastore.uri=thrift://localhost:9083
hive.non-managed-table-writes-enabled=true
""" >hive.properties

sudo mv hive.properties /etc/presto/catalog/hive.properties

sudo mv rds_postgresql.properties /etc/presto/catalog/

sudo reboot

echo """
# ** CHANGE ME ** - environment specific
export DATA_BUCKET=prestodb-demo-databucket-v8gbj2fr6vcc
export EC2_ENDPOINT=ec2-34-231-243-251.compute-1.amazonaws.com
export POSTGRES=presto-demo.cxauxtdppqiu.us-east-1.rds.amazonaws.com

# configure and use Apache Hive
export JAVA_HOME=/usr
export HADOOP_HOME=~/hadoop
export HADOOP_CLASSPATH="${HADOOP_HOME}/share/hadoop/tools/lib/*"
export HIVE_HOME=~/hive
export PATH="${HIVE_HOME}/bin:${HADOOP_HOME}/bin:${PATH}"
""" >>~/.bash_profile

# presto-cli --catalog tpcds --schema sf1

# aws s3 ls
# aws s3api create-bucket --bucket ${DATA_BUCKET}

# echo """
# SELECT
#     *
# FROM
#     tpcds.sf1.customer;
# """ >customer.sql

# echo """
# SELECT
#     *
# FROM
#     tpcds.sf1.customer_address;
# """ >customer_address.sql

# presto-cli \
#   --catalog tpcds \
#   --schema sf1 \
#   --file customer.sql \
#   --output-format CSV_HEADER >customer_quoted.csv

# presto-cli \
#   --catalog tpcds \
#   --schema sf1 \
#   --file customer_address.sql \
#   --output-format CSV_HEADER >customer_address_quoted.csv

# presto-cli \
#   --catalog tpcds \
#   --schema sf1 \
#   --execute "SELECT * FROM tpcds.sf1.customer;" \
#   --output-format CSV_HEADER >customer_quoted.csv

# presto-cli \
#   --catalog tpcds \
#   --schema sf1 \
#   --execute "SELECT * FROM tpcds.sf1.customer_address;" \
#   --output-format CSV_HEADER >customer_address_quoted.csv

# presto-cli \
#   --catalog tpcds \
#   --schema sf1 \
#   --execute "SELECT * FROM tpcds.sf1.customer_demographics;" \
#   --output-format CSV_HEADER >customer_demographics_quoted.csv

presto-cli \
  --catalog tpcds \
  --schema sf1 \
  --execute "INSERT INTO hive.default.customer SELECT * FROM tpcds.sf1.customer;"

presto-cli \
  --catalog tpcds \
  --schema sf1 \
  --execute "INSERT INTO hive.default.customer_address SELECT * FROM tpcds.sf1.customer_address;"

presto-cli \
  --catalog tpcds \
  --schema sf1 \
  --execute "INSERT INTO hive.default.customer_demographics SELECT * FROM tpcds.sf1.customer_demographics;"

presto-cli \
  --catalog tpcds \
  --schema sf1 \
  --execute """
      INSERT INTO hive.default.customer_demographics
      SELECT
          *
      FROM
          tpcds.sf1.customer_demographics;
"""
presto-cli --execute """
INSERT INTO hive.default.customer
SELECT * FROM tpcds.sf1.customer;
"""

presto-cli --execute """
INSERT INTO rds_postgresql.public.customer_address
SELECT * FROM tpcds.sf1.customer_address;
"""

# sed 's/"\([[:digit:]]\+\)"/\1/g' customer_quoted.csv > customer.csv

# remove start and end line double quotes
# remove extra spaces on fixed width columns
# removes double quotes between fields
# sed -e 's/^\"//g' -e 's/\"$//g' -e 's/ \{0,\}\",\"/,/g' \
#   customer_quoted.csv > customer.csv
# sed -e 's/^\"//g' -e 's/\"$//g' -e 's/ \{0,\}\",\"/,/g' \
#   customer_address_quoted.csv > customer_address.csv
# sed -e 's/^\"//g' -e 's/\"$//g' -e 's/ \{0,\}\",\"/,/g' \
#   customer_demographics_quoted.csv > customer_demographics.csv

sed -e 's/^\"//g' -e 's/\"$//g' -e 's/\",\"/,/g' \
  customer_quoted.csv >customer.csv
sed -e 's/^\"//g' -e 's/\"$//g' -e 's/\",\"/,/g' \
  customer_address_quoted.csv >customer_address.csv
sed -e 's/^\"//g' -e 's/\"$//g' -e 's/\",\"/,/g' \
  customer_demographics_quoted.csv >customer_demographics.csv

head -5 customer.csv
head -5 customer_address.csv
head -5 customer_demographics.csv

aws s3 cp customer.csv s3://${DATA_BUCKET}/customer/
aws s3 cp customer_address.csv s3://${DATA_BUCKET}/customer_address/
aws s3 cp customer_demographics.csv s3://${DATA_BUCKET}/customer_demographics/

# scp -i "~/.ssh/ahana-presto.pem" ec2-user@ec2-100-24-122-163.compute-1.amazonaws.com:~/customer.csv .

java -version
# openjdk version "1.8.0_252"
# OpenJDK Runtime Environment (build 1.8.0_252-b09)
# OpenJDK 64-Bit Server VM (build 25.252-b09, mixed mode)

hadoop version
# Hadoop 2.9.2

postgres --version
# postgres (PostgreSQL) 9.2.24

psql --version
# psql (PostgreSQL) 9.2.24

hive --version
# Hive 2.3.7

presto-cli --version
# Presto CLI 0.235-cb21100

psql -l

# sudo -u ec2-user psql hive

cat /etc/presto/jvm.config
cat /etc/presto/config.properties
cat /etc/presto/node.properties
cat /etc/presto/catalog/rds_postgresql.properties

scp -i "~/.ssh/ahana-presto.pem" \
  ahana_presto_aws/sql/hive_customer.sql \
  ec2-user@${EC2_ENDPOINT}:~/

scp -i "~/.ssh/ahana-presto.pem" \
  ahana_presto_aws/sql/hive_customer_address.sql \
  ec2-user@${EC2_ENDPOINT}:~/

hive
# copy and paste sql commands

hive -f hive_customer.sql
hive -f hive_customer_address.sql

# Access RDS from psql on presto EC2
export PGPASSWORD=5up3r53cr3tPa55w0rd
psql -h ${POSTGRES} -p 5432 -d shipping -U presto
# copy and paste sql commands

psql -h ${POSTGRES} -p 5432 -d shipping -U presto \
  -f sql/postgres_customer_address.sql

psql -h ${POSTGRES} -p 5432 -d shipping -U presto \
  -c "SELECT COUNT(*) FROM customer_address;"

presto-cli \
  --catalog tpcds \
  --schema sf1 \
  --file sql/presto_query2.sql \
  --output-format ALIGNED \
  --client-tags "query=presto_query2"

presto-cli \
  --catalog tpcds \
  --schema sf1 \
  --file presto_query2.sql