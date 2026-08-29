variable "catalog_database_name" {
    description = "name of the catalog database"
    type = string
}

variable "catalog_table_name" {
    description = "name of the catalog table"
    type = string
}

#variable "catalog_name" {
#    description = "Name of glue catalog that stores and registers glue table metadata"
#   type = string
#}

variable "cob-crawler_name" {
    description = "Name of the glue  crawler"
    type = string
}

variable "glue_role_arn" {
   description = " glue role for the glue crawler"
   type = string
}

variable "s3_bucket_name" {
    description = "S3 bucket to store data for glue crawler"
    type = string
}