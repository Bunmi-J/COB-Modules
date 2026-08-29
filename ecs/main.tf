resource "aws_security_group" "cob_ecs_tls" {
  name        = "${var.security_groupname}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-ecs-sg"
    Environment = "${var.environment}"
    consumer = "${var.consumer_name}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cob_ecs_tls_ipv4" {
  security_group_id = aws_security_group.cob_ecs_tls.id
  count = length(var.cidr_block)
  cidr_ipv4         = var.cidr_block[count.index]  #aws_vpc.cob_vpc.cidr_block #module.cob_vpc.vpc_cidr  
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.cob_ecs_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#cob ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cob_ecs_cluster_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#load balancer for the network, move to vpc module
resource "aws_lb" "ecs_lb" {
  name               = var.cob_lb_name 
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids 

  enable_deletion_protection = true

  tags = {
    Name        = "${var.project_name}-load-balancer"
    Environment = "${var.environment}"
    consumer = "${var.consumer_name}"
  
  }
}

resource "aws_lb_target_group" "alb_ecs" {
  name        = "${var.alb_name}" 
  target_type = "ip"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

# listener to connect and forward traffic NLB to Target group
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn

  port     = 80
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ecs.arn
  }
}

# cob ecs service
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.ecs_service_name}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = 2
  #iam_role        = var.ecs_role  #aws_iam_role.ecs_container.arn
  #depends_on      = [var.ecs_role_policy]  #[aws_iam_role_policy.ecs_policy]
  network_configuration {
     subnets = var.subnet_ids
     security_groups = [
            aws_security_group.cob_ecs_tls.id
    ]
    assign_public_ip = false

  }
 
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_ecs.arn
    container_name   = "${var.task1}"
    container_port   = 80
  }
  depends_on = [
    aws_lb_listener.ecs_listener
  ]  
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-north-1a, eu-north-1b]"
  }
}

