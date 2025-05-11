# Terraform: AWS DynamoDB Global Table with Optional Autoscaling

This Terraform configuration deploys an **Amazon DynamoDB Global Table** that supports:
- Customizable table name, keys, and regions
- On-demand (`PAY_PER_REQUEST`) or provisioned billing
- Global Secondary Indexes (GSIs)
- Time-to-Live (TTL) expiration
- Optional autoscaling for provisioned capacity

---

## Purpose

This module allows users to easily create a highly available, multi-region DynamoDB Global Table with optional fine-grained control over indexing, billing mode, TTL, and autoscaling policies. It is intended for DevOps and infrastructure teams managing globally replicated databases.

---

## Input Parameters

| Name                    | Type            | Description                                                                 |
|-------------------------|-----------------|-----------------------------------------------------------------------------|
| `table_name`            | `string`        | Name of the DynamoDB table.                                                 |
| `primary_key`           | `string`        | Primary key (partition key) attribute name.                                 |
| `sort_key`              | `string`        | Sort key attribute name.                                                    |
| `replica_regions`       | `list(string)`  | AWS regions for global replication (first is the primary region).           |
| `billing_mode`          | `string`        | `PAY_PER_REQUEST` or `PROVISIONED`.                                         |
| `read_capacity`         | `number`        | Read units (used only with `PROVISIONED`).                                  |
| `write_capacity`        | `number`        | Write units (used only with `PROVISIONED`).                                 |
| `enable_autoscaling`    | `bool`          | Enable autoscaling (only when using `PROVISIONED` billing mode).            |
| `read_autoscaling`      | `object`        | Settings for read autoscaling: `min_capacity`, `max_capacity`, `target_utilization`. |
| `write_autoscaling`     | `object`        | Settings for write autoscaling: `min_capacity`, `max_capacity`, `target_utilization`. |
| `ttl_attribute`         | `string`        | Name of the TTL attribute (optional).                                       |
| `tags`                  | `map(string)`   | Key-value tags applied to the table.                                        |
| `global_secondary_indexes` | `list(object)` | Optional list of GSI configurations. Each includes `name`, `hash_key`, `range_key`, `projection_type`, and `non_key_attributes`. |

---

## Files Explained

| File            | Purpose                                                                 |
|-----------------|-------------------------------------------------------------------------|
| `main.tf`       | Defines the main DynamoDB table, replica setup, TTL, GSI, and autoscaling policies. |
| `variables.tf`  | Declares and validates all input variables used by the module.          |
| `outputs.tf`    | Outputs useful values such as the DynamoDB table ARN.                  |
| `terraform.tfvars` | Example file for supplying user-specific values to variables.        |

---

## Example Usage

```hcl
module "global_dynamodb" {
  source = "./path-to-this-module"

  table_name       = "CustomerOrders"
  primary_key      = "customer_id"
  sort_key         = "order_id"
  replica_regions  = ["us-east-1", "us-west-2"]
  billing_mode     = "PROVISIONED"
  read_capacity    = 5
  write_capacity   = 5
  enable_autoscaling = true

  read_autoscaling = {
    min_capacity       = 5
    max_capacity       = 100
    target_utilization = 70
  }

  write_autoscaling = {
    min_capacity       = 5
    max_capacity       = 50
    target_utilization = 70
  }

  ttl_attribute = "expiration"
  tags = {
    Environment = "Production"
    Team        = "DevOps"
  }
}
```

## Requirements
 - Terraform 1.0+
 - AWS CLI configured or environment varialbes set for authentication
 - IAM permissions for:
   - `dynamodb:*`
   - `application-autoscaling:*`
   - `cloudwatch:*`

## Outputs
| File            | Purpose                                                                 |
|-----------------|-------------------------------------------------------------------------|
| `dynamodb_table_arn` |  The ARN of the created DynamoDB table                             |


## Notes
 - The first region in replica_regions is used as the primary region.
 - If billing_mode = `PAY_PER_REQUEST`, autoscaling and capacity settings are ignored.
 - Auto Scaling only applies when `billing_mode = "PROVISIONED"` and `enable_autoscaling = true`.
 - This module requires that your AWS IAM role has permissions for DynamoDB, CloudWatch, and Application Auto Scaling.