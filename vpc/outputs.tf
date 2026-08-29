output "vpc_id" {
  value = aws_vpc.cob_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.cob_vpc.cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  value       = aws_subnet.cob_private[*].cidr_block
}


output "public_subnet_ids" {
  description = "public subnet ids"
  value = aws_subnet.cob_public[*].id
}



output "private_subnet_ids" {
  description = "private subnet ids"
  value = aws_subnet.cob_private[*].id
}

output "isolated_subnet_ids" {
  description = "isolated subnet ids"
  value = aws_subnet.cob_isolated[*].id
}


output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
}