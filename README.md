# Ahana PrestoDB on AWS Federated Query Demo

```bash
aws cloudformation create-stack \
  --stack-name prestodb-demo \
  --template-body file://cloudformation/rds_s3.yaml
  --parameters ParameterKey=DBAvailabilityZone,ParameterValue=us-east-1f
```

- <https://www.tutorialspoint.com/hive/hive_create_database.htm>  
- <https://docs.cloudera.com/runtime/7.0.1/using-hiveql/topics/hive-create-s3-based-table.html>  
- <https://prestodb.io/docs/current/connector.html>  
