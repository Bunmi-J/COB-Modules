output "cob_rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.cob_rds_instance.endpoint
}

output "cob_rds_address" {
  description = "RDS hostname"
  value       = aws_db_instance.cob_rds_instance.address
}

output "cob_rds_port" {
  description = "RDS port"
  value       = aws_db_instance.cob_rds_instance.port
}

output "cob_rds_database_name" {
  description = "Database name"
  value       = aws_db_instance.cob_rds_instance.db_name
}