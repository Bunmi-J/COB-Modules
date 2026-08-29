output "s3-ids" {
    description = "id for the cob s3"
    value = aws_s3_bucket.cob-s3.id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.cob-s3.bucket
}

output "s3-object-arn" {
    description = "ARN for the cob s3 object"
    value = var.enable_object_upload ? aws_s3_object.cob-object[0].arn : null
}

output "s3-version" {
    description = "version for the cob s3 bucket"
    value = aws_s3_bucket_versioning.versioning-s3.id
}