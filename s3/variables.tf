variable "bucket_name" {
    description = "This describe the specific bucket title "
    type = string
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

variable "versioning_enabled" {
  description = "Enable S3 object versioning"
  type        = bool
  default     = true
}

variable "enable_lifecycle" {
  description = "Decide whether to attach a lifecycle configuration to the bucket"
  type        = bool
  default     = true
}

variable "lifecycle_prefix" {
    description = "enable consumer to specify the object prefix the lifecycle applies to. Empty string means lc is applied to all objects"
    type = string
    default = ""
}
variable "consumer_name" {
  description = "Name of the consumer/service using this bucket. Used to namespace object keys (e.g. consumers/<consumer_name>/...) and to scope lifecycle rules so multiple consumers can safely share one bucket."
  type        = string
}

variable "enable_object_upload" {
  description = "if you the object path is not available yet or Whether to upload an object to the S3 bucket"
  type        = bool
  default     = false
}

variable "object_key" {
  description = "S3 object key is like the folder path to upload the object to on s3 bucket"
  type        = string
  default     = ""
}

variable "object_source" {
  description = "Path to Local file to upload"
  type        = string
  default     = ""
}