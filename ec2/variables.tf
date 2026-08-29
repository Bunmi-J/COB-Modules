variable "vpc_id" {
    description = "This vpc id for cob_vpc "
    type = string
}

variable "security_groupname" {
    description = "This describe the specific security group name "
    type = string
}

variable "cidr_block" {
  description = "cidr block range for ipv4"
  type        = list(string)
}

variable "subnet_ids" {
    description = "This subnet ids for private subnet "
    type = list(string)
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
  description = "Name of the consumer/service using this bucket. Used to namespace object keys (e.g. consumers/<consumer_name>/...) and to scope lifecycle rules so multiple consumers can safely share one bucket."
  type        = string
}

variable "ami_id" {
  description = "AMI ID parameter reference for the EC2 instance"
  type        = string

  default = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "keyname" {
  description = "Name of an existing EC2 key pair in AWS"
  type        = string
}

variable "iam_ec2_instance_profile_name" {
  description = "Name of an IAM instance profile to attach ."
  type        = string
  default     = null
}