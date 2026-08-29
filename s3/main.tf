resource "aws_s3_bucket" "cob-s3" {
  bucket = "${var.bucket_name}-bucket"

  tags = {
    Name        = "${var.project_name}-s3-bucket"
    Environment = "${var.environment}"
    consumer = "${var.consumer_name}"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cob-s3-lc" {
  bucket = aws_s3_bucket.cob-s3.id

  rule {
    id     = "storage-rule"
    status = var.enable_lifecycle ? "Enabled" : "Suspended"

    filter {
      prefix = var.lifecycle_prefix
    }

   # transition {
   #   days          = 30
   #   storage_class = "STANDARD_IA"
   # }

    expiration {
      days = 365
    }

  }
}

resource "aws_s3_bucket_versioning" "versioning-s3" {
  bucket = aws_s3_bucket.cob-s3.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_object" "cob-object" {
  bucket = aws_s3_bucket.cob-s3.bucket
  count = var.enable_object_upload ? 1 : 0
  key    = var.object_key
  source = var.object_source
}

