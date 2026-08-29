# RDS database to be consumed by the analytic terraform
resource "aws_security_group" "cob_rds" {
  name        = "${var.security_groupname}-sg"
  description = "Allow postgres inbound traffic "
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-rds-sg"
    Environment = "${var.environment}"
    consumer = "${var.consumer_name}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_inbound" {
  security_group_id            = aws_security_group.cob_rds.id
  referenced_security_group_id = var.ecs_security_group_id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "rds_outbound" {
  security_group_id = aws_security_group.cob_rds.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_db_subnet_group" "cob_rds" {
  name = "${var.project_name}-${var.environment}-rds-subnet-group"

  subnet_ids = var.isolated_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-subnet-group"
    Environment = var.environment
  }
}


resource "aws_db_instance" "cob_rds_instance" {
  identifier = "${var.project_name}-${var.environment}-postgres"  
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.db_username
  password             = var.db_password
  port                 = var.db_port
  db_subnet_group_name = aws_db_subnet_group.cob_rds.name

  vpc_security_group_ids = [aws_security_group.cob_rds.id]
  #parameter_group_name = var.parametergroup_name
  skip_final_snapshot  = true
  tags = {
    Name        = "${var.project_name}-${var.environment}-postgres"
    consumer = var.consumer_name
  }
}
