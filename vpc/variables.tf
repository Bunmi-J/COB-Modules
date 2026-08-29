variable "vpc_name" {
  description = "Name tag for VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default = [
    "10.0.0.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.3.0/24"
  ]
}

variable "isolated_subnet_cidrs" {
  description = "CIDR blocks for isolated subnets for RDS and other resources"
  type        = list(string)

  default = [
    "10.0.4.0/24",
    "10.0.5.0/24"
  ]
}

variable "availability_zones" {
  description = "Availability Zones to place the subnets in"
  type        = list(string)
  default = [
    "eu-north-1a",
    "eu-north-1b"
  ]
}

variable "subnet_routetable" {
    description = "name tag for the subnet routebale"
    type = string
}

variable "enable_nat_gateway" {
  description = "Included to create a NAT gateway for the private subnet if necessary, just change default to true"
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IPs to instances in the public subnet"
  type        = bool
  default     = false
}

variable "nat_gateway" {
    description = "Nat gate to allow internet access for the private subnet"
    type    = string
}

variable "project_name" {
    type = string
    description = "This is the project title"
    #default = "cob-project"
}