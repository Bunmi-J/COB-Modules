# Cob VPC
resource "aws_vpc" "cob_vpc" {
  cidr_block       = var.vpc_cidr
  #instance_tenancy = "default"

  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}


# CoB public subnet
resource "aws_subnet" "cob_public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.cob_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone        = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.project_name}-public-subnet-${var.availability_zones[count.index]}"
  }
}

# Cob private subnet
resource "aws_subnet" "cob_private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.cob_vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone        = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-${var.availability_zones[count.index]}"
  }
}   

# isolated subnet to manage RDS
resource "aws_subnet" "cob_isolated" {
  count = length(var.isolated_subnet_cidrs)
  vpc_id     = aws_vpc.cob_vpc.id
  cidr_block = var.isolated_subnet_cidrs[count.index]
  availability_zone        = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-isolated-subnet-${var.availability_zones[count.index]}"
  }
}  



# CoB VPC internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cob_vpc.id 

  tags = {
    Name = "${var.vpc_name}_gw"
  }
}

# Resource to create CoB public subnet route table
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.cob_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  
  tags = {
    Name = "${var.subnet_routetable}_public"
  }
}

# resource to create association between public_routetable and cob_public subnet

resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.cob_public)
  subnet_id      = aws_subnet.cob_public[count.index].id
  route_table_id = aws_route_table.public_routetable.id
}

# Resource to enable elastic IP for the COB VPCPublic subnet_ids/NAT gateway
resource "aws_eip" "nat_eip" {
    count         = var.enable_nat_gateway ? 1 : 0
    domain = "vpc"
}

# Resource to create the NAT GATEWAY for the public subnet (cob_public)
resource "aws_nat_gateway" "public_nat" {
    count         = var.enable_nat_gateway ? 1 : 0
    allocation_id = aws_eip.nat_eip[0].id
    subnet_id     = aws_subnet.cob_public[count.index].id

    tags = {
         Name = var.nat_gateway
    }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
    depends_on = [
         aws_internet_gateway.gw,
         aws_route_table.public_routetable,
         aws_route_table_association.public_assoc
  ]
}


# Resource to create CoB private subnet route table

resource "aws_route_table" "private_routetable" {
  vpc_id = aws_vpc.cob_vpc.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.public_nat[0].id
    }    

 }

    tags = {
    Name = "${var.subnet_routetable}_private"
  }
}

# resource to create association between private_routetable and cob_private subnet

resource "aws_route_table_association" "private_assoc" {
  count = length(aws_subnet.cob_private)
  subnet_id      = aws_subnet.cob_private[count.index].id
  route_table_id = aws_route_table.private_routetable.id
}
