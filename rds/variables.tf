variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "allocated_storage" {
  description = "Database storage in GB"
  type        = number
  default     = 10
}

variable "db_name" {
  description = "Cob project database name"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_username" {
  description = "database username"
  type        = string
}

variable "db_password" {
  description = "database password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "isolated_subnet_ids" {
  description = "Subnet IDs used by the RDS DB subnet group"
  type        = list(string)
}

#variable "vpc_security_group_ids" {
#  description = "Security groups attached to RDS"
#  type        = list(string)
#}

variable "vpc_id" {
    description = "vpc id for the rds"
  type = string
}

variable "publicly_accessible" {
  description = "Whether the database should have a public IP"
  type        = bool
  default     = false
}

variable "ecs_security_group_id" {
    description = "ecs security group id allowed to connect to postgresql referenced by ingress_rule"
    type = string
}

variable "consumer_name" {
  description = "Name of the consumer/service using this database."
  type        = string
}

variable "security_groupname" {
    description = "This describe the specific security group name "
    type = string
}