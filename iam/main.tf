# EC2 trust Policy document for ec2 to assume an IAM instance profile role 

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ec2 IAM role
resource "aws_iam_role" "instance" {
  name               = "${var.resource_name}-ec2-instance-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# ec2 defined permission policy document 
data "aws_iam_policy_document" "ec2_perm" {
  statement {
    sid    = "EC2BasicLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }


  dynamic "statement" {
     for_each = length(var.allowed_s3_prefixes) > 0 ? [1] : []
     content {
     sid    = "S3ListBucket"
     effect = "Allow"

     actions = [
     "s3:ListBucket"
  ]

  resources = [
    for bucket in var.allowed_s3_prefixes :
    "arn:aws:s3:::${bucket}"
  ]
  }
}

  dynamic "statement" {
     for_each = length(var.allowed_s3_prefixes) > 0 ? [1] : []
     content {
     sid    = "S3ObjectAccess"
     effect = "Allow"

     actions = [
              "s3:GetObject",
              "s3:PutObject"
      ]

  resources = [
    for bucket in var.allowed_s3_prefixes :
    "arn:aws:s3:::${bucket}/*"
  ]
  }
}

}

# instance profile for ec2
resource "aws_iam_instance_profile" "cob_ec2_instance_profile" {
  name = "${var.resource_name}-ec2-instance-profile"
  role = aws_iam_role.instance.name
}

# ec2 permission policy
resource "aws_iam_role_policy" "ec2_policy" {
  name = "${var.resource_name}-ec2_policy"
  role = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.ec2_perm.json
}
  

