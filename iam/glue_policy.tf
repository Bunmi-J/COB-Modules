# trust policy for glue to assume service role
data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}


#aws glue role to access the s3

resource "aws_iam_role" "glue_role" {
  name               = "${var.cob_glue_name}-service-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}





# Permission policy defined for the glue service role
data "aws_iam_policy_document" "glue_service_permission" {

  # Glue Catalog permissions
  statement {
    sid    = "GlueCatalogAccess"
    effect = "Allow"

    actions = [
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:CreateDatabase",
      "glue:UpdateDatabase",

      "glue:GetTable",
      "glue:GetTables",
      "glue:CreateTable",
      "glue:UpdateTable",

      "glue:GetPartition",
      "glue:GetPartitions",
      "glue:CreatePartition",
      "glue:BatchCreatePartition",
      "glue:UpdatePartition",

      "glue:BatchGetPartition"
    ]

    resources = ["*"]
  }

  # Read source S3 bucket
  statement {
    sid    = "S3SourceBucketAccess"
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetBucketAcl"
    ]

    resources = [
      "arn:aws:s3:::${var.source_bucket_name}"
    ]
  }

  # Read objects in source S3 bucket
  statement {
    sid    = "S3SourceObjectAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.source_bucket_name}/*"
    ]
  }

  # CloudWatch Logs
  statement {
    sid    = "GlueCloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:/aws-glue/*"
    ]
  }

  # CloudWatch metrics
  statement {
    sid    = "GlueCloudWatchMetrics"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData"
    ]

    resources = ["*"]
  }

  # EC2/VPC information required by Glue
  statement {
    sid    = "GlueVpcAccess"
    effect = "Allow"

    actions = [
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeRouteTables",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcAttribute"
    ]

    resources = ["*"]
  }

  

  # Allow Glue to tag resources it creates
  statement {
    sid    = "GlueResourceTagging"
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]

    resources = [
      "arn:aws:ec2:*:*:network-interface/*",
      "arn:aws:ec2:*:*:security-group/*",
      "arn:aws:ec2:*:*:instance/*"
    ]

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"
      values = [
        "aws-glue-service-resource"
      ]
    }
  }
}

# glue policy attachment to role
resource "aws_iam_role_policy" "glue_policy" {
  name = "${var.cob_glue_name}-policy"
  role = aws_iam_role.glue_role.id
  policy = data.aws_iam_policy_document.glue_service_permission.json
}