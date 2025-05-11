table_name      = "CustomerOrders"
primary_key     = "customer_id"
sort_key        = "order_id"
replica_regions = ["us-east-1", "us-west-2"]

billing_mode       = "PROVISIONED"
read_capacity      = 5
write_capacity     = 5
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

global_secondary_indexes = [
  {
    name               = "CustomerNameIndex"
    hash_key           = "customer_name"
    range_key          = "order_date"
    projection_type    = "INCLUDE"
    non_key_attributes = ["email", "address"]
  }
]
