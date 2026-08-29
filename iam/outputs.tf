output "ec2_role_arn" {
  description = "ARN of the EC2 workload role"
  value       = aws_iam_role.instance.arn
}

output "cob_ec2_instance_profile_name" {
  description = "IAM instance profile name for EC2"
  value       = aws_iam_instance_profile.cob_ec2_instance_profile.name
}

output "ecs_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_container.arn
}

output "ecs_execution_role_arn" {
  description = "ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "glue_role_arn" {
    description = "Amazon resource name for the glue role"
    value = aws_iam_role.glue_role.arn
}


#output "ecs_role_policy" {
#  description = "policy ARN of the ECS execution role"
#  value       = aws_iam_role_policy.ecs_policy 
#}