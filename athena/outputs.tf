output "query_results_bucket_name" {
  description = "S3 bucket used for Athena query results"
  value       = aws_s3_bucket.query_results.bucket
}