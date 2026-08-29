variable "project_name" {
    type = string
    description = "This is the project title"
    #default = "cob-project"
}

variable "environment" {
    description = "Environment name can be dev, staging or prod"
    default = "dev"
}


variable "athena_data_catalog" {
    description = "Athena use the data catalog to store and retrieve tables metadata"
    type = string
}

#variable "query_result_bucket" {
#  description = "S3 bucket used for Athena query results"
# type        = string
#}

#variable "bucket_id" { 
#   description = "s3 bucketid for the glue database"
#   type = string
#}

#variable "athena_database_name" {
#    description = "athena use the glue catalog database"
#}

variable "consumer_name" {
  description = "Name of the consumer/service using this container."
  type        = string
}