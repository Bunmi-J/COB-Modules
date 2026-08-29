# getting current aws account id
data "aws_caller_identity" "current" {}


resource "aws_athena_data_catalog" "cob_athena" {
  name        = var.athena_data_catalog 
  description = "Glue based Data Catalog"
  type        = "GLUE"

  parameters = {
    "catalog-id" = data.aws_caller_identity.current.account_id
  }
}

# s3 bucket for query results
resource "aws_s3_bucket" "query_results" {
  bucket = "${var.project_name}-${var.environment}-query-results"
}

# To reduce storage cost, it's advisable to enable lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "query_results_lifecycle" {
  bucket = aws_s3_bucket.query_results.id

  rule {
    id     = "query-results-expiration"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}



# advisable to enable s3 versioning
resource "aws_s3_bucket_versioning" "s3_athena_results" {
  bucket = aws_s3_bucket.query_results.id

  versioning_configuration {
    status = "Enabled"
  }
}

# cob workgroup to control where query is run and where query results are written to
resource "aws_athena_workgroup" "cob_workgroup" {
  name = "${var.project_name}-${var.environment}-athena"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.query_results.bucket}/query-results/"
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-athena"
    Environment = var.environment
    consumer = var.consumer_name
  }
}

