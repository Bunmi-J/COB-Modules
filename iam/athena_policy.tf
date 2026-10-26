# Trust policy for for athena to assume role
#data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "data_engineer_assume" {
  statement {
    sid    = "AllowUserToAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"

      identifiers =   "arn:aws:iam::469935552963:user/Admin"  #aws_iam_role.data_engineer.arn        #var.allowed_principal_arns 

       #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cob-data-engineer" 

        

      
    }
  }
}

# athena permission policy for a user/role can 
data "aws_iam_policy_document" "query_access" {

  statement {
    sid    = "AthenaQueryAccess"
    effect = "Allow"

    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "athena:StopQueryExecution"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "GlueCatalogReadAccess"
    effect = "Allow"

    actions = [
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:GetTable",
      "glue:GetTables",
      "glue:GetPartition",
      "glue:GetPartitions"
    ]

    resources = ["*"]
  }

  
  statement {
    sid    = "AthenaDataCatalogManagement"
    effect = "Allow"

    actions = [
      "athena:GetDataCatalog",
      "athena:ListDataCatalogs",
      "athena:CreateDataCatalog",
      "athena:UpdateDataCatalog",
      "athena:DeleteDataCatalog",
      "athena:ListTagsForResource",
      "athena:TagResource",
      "athena:UntagResource"
    ]

    resources = ["*"]
  }




  statement {
    sid    = "S3SourceDataRead"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.source_bucket_name}",
      "arn:aws:s3:::${var.source_bucket_name}/*"
    ]
  }

  statement {
    sid    = "AthenaResultsAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload"
    ]

    resources = [
      "arn:aws:s3:::${var.query_results_bucket_name}/athena-results/*"
    ]
  }

  statement {
    sid    = "AthenaResultsBucketAccess"
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.query_results_bucket_name}"
    ]
  }
}


#policy that allows Athena to query glue catalog data and grants access to s3

resource "aws_iam_policy" "athena_access_policy" {
  name        = "${var.project_name}-${var.environment}-athena-access"
  description = "Allows Athena to query Glue catalog data and access S3"

  policy = data.aws_iam_policy_document.query_access.json
}

#
resource "aws_iam_role" "data_engineer" {
 name               = "${var.project_name}-${var.environment}-data-engineer" #var.username
 path               = "/system/"
 assume_role_policy = data.aws_iam_policy_document.data_engineer_assume.json
}


# attach athena access policy to the role
resource "aws_iam_role_policy_attachment" "athena_access_attachment" {
  role       = aws_iam_role.data_engineer.name
  policy_arn = aws_iam_policy.athena_access_policy.arn
}


data "aws_iam_policy_document" "admin_assume_data_engineer" {
  statement {
    sid    = "AssumeDataEngineerRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      aws_iam_role.data_engineer.arn
    ]
  }
}


resource "aws_iam_policy" "admin_assume_data_engineer" {
  name        = "${var.project_name}-${var.environment}-admin-assume-data-engineer"
  description = "Allows the Admin IAM user to assume the data engineer role"

  policy = data.aws_iam_policy_document.admin_assume_data_engineer.json
}


resource "aws_iam_user_policy_attachment" "admin_assume_data_engineer" {
  user       = "Admin"
  policy_arn = aws_iam_policy.admin_assume_data_engineer.arn
}
