resource "aws_security_group" "cob_tls" {
  name        = "${var.security_groupname}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-ec2-sg"
    Environment = "${var.environment}"
    consumer = "${var.consumer_name}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cob_tls_ipv4" {
  security_group_id = aws_security_group.cob_tls.id
  count = length(var.cidr_block)
  cidr_ipv4         = var.cidr_block[count.index]  #aws_vpc.cob_vpc.cidr_block #module.cob_vpc.vpc_cidr  
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.cob_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



# launch ec2 instance
resource "aws_instance" "cob_ec2" {
  count = length(var.subnet_ids)
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids[count.index]
  vpc_security_group_ids = [
    aws_security_group.cob_tls.id
    ]
  iam_instance_profile = var.iam_ec2_instance_profile_name
  key_name = var.keyname

  tags = {
    Name        = "${var.project_name}-ec2-${count.index + 1}"
    Environment = "${var.environment}"
    consumer = "${var.consumer_name}"
  }
}
