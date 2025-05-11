output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB Global Table"
  value       = aws_dynamodb_table.global_table.arn
}
