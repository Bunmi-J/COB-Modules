variable "vpc_id" {
    description = "This vpc id for cob_vpc where ecs will created"
    type = string
}

variable "cidr_block" {
  description = "cidr block range for ipv4"
  type        = list(string)
}

variable "subnet_ids" {
    description = "These are private subnet ids for ecs tasks"
    type = list(string)
}


variable "public_subnet_ids" {
  description = "Public subnet IDs for the ecs load balancer"
  type        = list(string)
}

variable "security_groupname" {
    description = "This describe the specific security group name "
    type = string
}

variable "cob_ecs_cluster_name" {
    description = " ECS cluster name"
    type = string
}

variable "ecs_service_name" {
    description = "ECS service name "
    type = string
}


variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

#variable "ecs_role_policy" {
#  description = "IAM role policy associated with the ecs role"
#  type        = string
#}

#variable "ecs_role" {
# description = "IAM role associated with the ecs"
#  type        = string
#}

variable "service_storage_name" {
    description = "the name of the ecs storage"
    type = string
}


variable "service_task1" {
    description = "image name for the first task_definition"
    type = string
}

variable "service_task2" {
    description = "image name for the second task_definition"
    type = string
}

variable "task1" {
    description = "task1 name for the first task"
    type = string
}

variable "task2" {
    description = "task name for the second task"
    type = string
}

variable "alb_name" {
    description = "name of application load balancer for ecs"
}

variable "cob_lb_name"{
    description = "network load balancer"
    type = string
}

variable "project_name" {
    type = string
    description = "This is the project title"
    #default = "cob-project"
}

variable "environment" {
    description = "Environment name can be dev, staging or prod"
    default = "dev"
}

variable "consumer_name" {
  description = "Name of the consumer/service using this container."
  type        = string
}

