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


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.cob-s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Enforce encryption on s3

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_config_s3" {
  bucket = aws_s3_bucket.cob-s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# s3 object for cob
resource "aws_s3_object" "cob-object" {
  bucket = aws_s3_bucket.cob-s3.bucket
  count = var.enable_object_upload ? 1 : 0
  key    = var.object_key
  source = var.object_source
}

