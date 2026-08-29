output "ec2_instance_ids" {
  value = aws_instance.cob_ec2[*].id
}

output "ec2_private_ips" {
  value = aws_instance.cob_ec2[*].private_ip
}

output "security_group_id" {
  value = aws_security_group.cob_tls.id
}
