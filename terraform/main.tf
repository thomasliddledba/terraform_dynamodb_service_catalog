provider "aws" {
  region = var.replica_regions[0]
}

resource "aws_dynamodb_table" "global_table" {
  name         = var.table_name
  billing_mode = var.billing_mode

  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  hash_key  = var.primary_key
  range_key = var.sort_key

  attribute {
    name = var.primary_key
    type = "S"
  }

  attribute {
    name = var.sort_key
    type = "S"
  }

  dynamic "attribute" {
    for_each = toset(flatten([
      for gsi in var.global_secondary_indexes : [
        { name = gsi.hash_key, type = "S" },
        { name = gsi.range_key, type = "S" }
      ]
    ]))
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.projection_type == "INCLUDE" ? global_secondary_index.value.non_key_attributes : null
    }
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  dynamic "replica" {
    for_each = toset(slice(var.replica_regions, 1, length(var.replica_regions)))
    content {
      region_name = replica.value
    }
  }

  ttl {
    enabled        = var.ttl_attribute != null
    attribute_name = var.ttl_attribute != null ? var.ttl_attribute : ""
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [replica]
  }
}

resource "aws_appautoscaling_target" "read" {
  count = var.billing_mode == "PROVISIONED" && var.enable_autoscaling ? 1 : 0

  max_capacity       = var.read_autoscaling.max_capacity
  min_capacity       = var.read_autoscaling.min_capacity
  resource_id        = "table/${aws_dynamodb_table.global_table.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read" {
  count = var.billing_mode == "PROVISIONED" && var.enable_autoscaling ? 1 : 0

  name               = "${var.table_name}-ReadAutoScaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read[0].resource_id
  scalable_dimension = aws_appautoscaling_target.read[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value       = var.read_autoscaling.target_utilization
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_target" "write" {
  count = var.billing_mode == "PROVISIONED" && var.enable_autoscaling ? 1 : 0

  max_capacity       = var.write_autoscaling.max_capacity
  min_capacity       = var.write_autoscaling.min_capacity
  resource_id        = "table/${aws_dynamodb_table.global_table.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write" {
  count = var.billing_mode == "PROVISIONED" && var.enable_autoscaling ? 1 : 0

  name               = "${var.table_name}-WriteAutoScaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write[0].resource_id
  scalable_dimension = aws_appautoscaling_target.write[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value       = var.write_autoscaling.target_utilization
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
