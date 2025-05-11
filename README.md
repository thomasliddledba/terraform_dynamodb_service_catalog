# DynamoDB Global Table Examples with Terraform and CloudFormation

This repository contains infrastructure-as-code (IaC) examples for deploying a fully functional **Amazon DynamoDB Global Table** using two popular tools:

- **Terraform**
- **AWS CloudFormation**

Each example demonstrates how to configure a DynamoDB table with support for:
- Global replication across multiple AWS regions
- Primary key and sort key definitions
- Billing modes (`PAY_PER_REQUEST` and `PROVISIONED`)
- Time-to-Live (TTL) configuration
- Global Secondary Indexes (GSI)
- Optional autoscaling for read/write capacity
- IAM Role for Application Auto Scaling (CloudFormation)

---

## 📁 Repository Structure
```bash
.
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── terraform.tfvars
│ └── README.md
│
├── cloudformation/
│ ├── dynamodb-global-table-full.yaml
│ └── README.md
│
└── README.md ← (this file)

```

---

## Use Cases

- Set up a highly available, multi-region DynamoDB table for global applications.
- Demonstrate best practices using either Terraform or CloudFormation.
- Learn how to automate autoscaling configuration and IAM roles.

---

## How to Use

Navigate into either the `terraform/` or `cloudformation/` folder for full setup instructions, parameter references, and deployment examples using the AWS CLI or `terraform apply`.

---

## Requirements

- AWS CLI configured with appropriate IAM permissions
- Terraform 1.0+ (if using the Terraform example)
- AWS CloudFormation permissions with `CAPABILITY_NAMED_IAM` (for IAM role creation)

---

## License

This project is licensed under the MIT License. See individual folder documentation for usage guidance.

