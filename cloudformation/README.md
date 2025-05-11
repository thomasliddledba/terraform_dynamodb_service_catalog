# AWS CloudFormation Template: DynamoDB Global Table with Autoscaling and TTL

This CloudFormation template provisions a **DynamoDB Global Table** with support for:

- Global replication across AWS regions
- On-demand or provisioned billing
- Optional autoscaling for read and write capacity
- Time-to-Live (TTL) configuration
- Global Secondary Indexes (GSI)
- IAM Role for Application Auto Scaling

---

## Parameters

- TableName (String): Name of the DynamoDB table  
- PrimaryKey (String): Partition key (hash key) name  
- SortKey (String): Sort key name  
- BillingMode (String): PAY_PER_REQUEST or PROVISIONED  
- ReadCapacityUnits (Number): Used with PROVISIONED mode  
- WriteCapacityUnits (Number): Used with PROVISIONED mode  
- TTLAttribute (String): Optional TTL attribute  
- ReplicaRegions (CommaDelimitedList): Comma-separated list of AWS regions  

---

## CLI Deployment Example

### 1. Create `params.json`

```json
[
  { "ParameterKey": "TableName", "ParameterValue": "CustomerOrders" },
  { "ParameterKey": "PrimaryKey", "ParameterValue": "customer_id" },
  { "ParameterKey": "SortKey", "ParameterValue": "order_id" },
  { "ParameterKey": "BillingMode", "ParameterValue": "PROVISIONED" },
  { "ParameterKey": "ReadCapacityUnits", "ParameterValue": "5" },
  { "ParameterKey": "WriteCapacityUnits", "ParameterValue": "5" },
  { "ParameterKey": "TTLAttribute", "ParameterValue": "expiration" },
  { "ParameterKey": "ReplicaRegions", "ParameterValue": "us-east-1,us-west-2" }
]
```

### 2. Deploy the stack
```bash
aws cloudformation create-stack \
  --stack-name dynamodb-global-table-stack \
  --template-body file://dynamodb-global-table-full.yaml \
  --parameters file://params.json \
  --capabilities CAPABILITY_NAMED_IAM
```

### 3. Update the stack
```bash
aws cloudformation update-stack \
  --stack-name dynamodb-global-table-stack \
  --template-body file://dynamodb-global-table-full.yaml \
  --parameters file://params.json \
  --capabilities CAPABILITY_NAMED_IAM
```

## Outputs
- TableArn: ARN of the global DynamoDB table
- AutoScalingRoleArn: IAM Role used by Auto Scaling