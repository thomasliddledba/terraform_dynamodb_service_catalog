variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "primary_key" {
  description = "Primary key attribute name"
  type        = string
}

variable "sort_key" {
  description = "Sort key attribute name"
  type        = string
}

variable "replica_regions" {
  description = "List of AWS regions for DynamoDB Global Table replication"
  type        = list(string)
}

variable "billing_mode" {
  description = "Billing mode for the DynamoDB table: PAY_PER_REQUEST or PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "read_capacity" {
  description = "Read capacity units (used only if billing_mode is PROVISIONED)"
  type        = number
  default     = 5
  validation {
    condition     = var.billing_mode != "PROVISIONED" || var.read_capacity > 0
    error_message = "read_capacity must be > 0 when billing_mode is PROVISIONED."
  }
}

variable "write_capacity" {
  description = "Write capacity units (used only if billing_mode is PROVISIONED)"
  type        = number
  default     = 5
  validation {
    condition     = var.billing_mode != "PROVISIONED" || var.write_capacity > 0
    error_message = "write_capacity must be > 0 when billing_mode is PROVISIONED."
  }
}

variable "enable_autoscaling" {
  description = "Enable autoscaling for read and write capacity (only for PROVISIONED)"
  type        = bool
  default     = false
}

variable "read_autoscaling" {
  description = "Read capacity autoscaling settings"
  type = object({
    min_capacity       = number
    max_capacity       = number
    target_utilization = number
  })
  default = {
    min_capacity       = 5
    max_capacity       = 20
    target_utilization = 70
  }
}

variable "write_autoscaling" {
  description = "Write capacity autoscaling settings"
  type = object({
    min_capacity       = number
    max_capacity       = number
    target_utilization = number
  })
  default = {
    min_capacity       = 5
    max_capacity       = 20
    target_utilization = 70
  }
}

variable "ttl_attribute" {
  description = "Name of the TTL attribute"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the DynamoDB table"
  type        = map(string)
  default     = {}
}

variable "global_secondary_indexes" {
  description = "List of Global Secondary Indexes"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  default = []
}
