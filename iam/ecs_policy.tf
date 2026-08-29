
# ECS trust policy document for ecs container to assume task role 
data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"] 
    }
  }
}

# Resource to launch ecs role
resource "aws_iam_role" "ecs_container" {
  name               = "${var.resource_name}-ecs-container-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

# ecs permission policy for the ecs role (ecs-container-role)  
data "aws_iam_policy_document" "ecs_perm" {
  statement {
    sid    = "TaskBasicLogs"
    effect = "Allow"

    actions = [
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
            "s3:GetObject"
              
      ]

  resources = [
    for bucket in var.allowed_s3_prefixes :
    "arn:aws:s3:::${bucket}/*"
  ]
     }
}
  
  }
  
resource "aws_iam_role_policy" "ecs_policy" {
      name   = "${var.resource_name}-ecs_main_policy"
      role   = aws_iam_role.ecs_container.id
      policy = data.aws_iam_policy_document.ecs_perm.json
}

# ECS trust policy document for container to assume Execution Role

data "aws_iam_policy_document" "ecs_execution_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}



#ecs  task exection role
resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.resource_name}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution_managed" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
