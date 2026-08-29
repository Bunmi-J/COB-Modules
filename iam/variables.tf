variable "allowed_s3_prefixes" {
  description = "List of S3 prefixes workloads may access"
  type        = list(string)
  default     = []
}

variable "resource_name" {
  description = "project title and project environment"
  type = string
}

variable "cob_glue_name" {
    description = "iam role name"
    type = string
}

variable "source_bucket_name" {
  description = "S3 bucket containing raw data queried by Athena"
  type        = string
}

variable "query_results_bucket_name" {
  description = "S3 bucket containing Athena query results"
  type        = string
}

variable "project_name" {
    type = string
    description = "This is the project title"
    #default = "cob-project"
}

variable "environment" {
    description = "Environment name can be dev, staging or prod"
    default = "dev"
}

variable "glue_role_arn" {
  description = "IAM role ARN used by the Glue crawler"
  type        = string
}

variable "username" {
  description = "username for the athena"
  type = string
}

variable "allowed_principal_arns" {
  description = "IAM principals allowed to assume the data engineer role"
  type        = list(string)
}

variable "athena_user" {
  description = "List of IAM users that can access the Athena"
  type = list(string)
}

