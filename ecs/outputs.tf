output "ecs_security_group_id" {
    description = "ecs security group id allowed to connect to postgresql referenced by ingress_rule"
    value = aws_security_group.cob_ecs_tls.id
}