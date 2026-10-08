resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}
resource "aws_subnet" "subnet-public" {
  for_each                = local.subnet
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${each.key}"
  }

}
resource "aws_subnet" "subnet-private" {
  for_each          = local.subnet1
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = "private-subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route_table" "public_sbrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.subnet-public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_sbrt.id
}

resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-nacl"
  }
  dynamic "ingress" {
    for_each = var.ingress_nacl_public
    content {
    rule_no    = ingress.value.rule_no
    protocol   = ingress.value.protocol
    action     = ingress.value.action
    cidr_block = ingress.value.cidr_block
    from_port  = ingress.value.from_port
    to_port    = ingress.value.to_port
  }
  }

  dynamic "egress" {
    for_each = var.egress_nacl_public
    content {
    rule_no    = egress.value.rule_no
    protocol   = egress.value.protocol
    action     = egress.value.action
    cidr_block = egress.value.cidr_block
    from_port  = egress.value.from_port
    to_port    = egress.value.to_port
  }
}
}
resource "aws_network_acl_association" "main_nacl_association" {
  for_each       = aws_subnet.subnet-public
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.nacl.id
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id =aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet-public["web1"].id
}
resource "aws_route_table" "private_sbrt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0" 
    gateway_id = aws_nat_gateway.nat_gw.id
  }
}
resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.subnet-private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_sbrt.id
}
resource "aws_network_acl" "nacl1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-nacl"
  }
  
  egress {
    rule_no    = 100
    protocol   = -1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
resource "aws_network_acl_association" "main_nacl_association1"{
  for_each       = aws_subnet.subnet-private
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.nacl.id
}




resource "aws_instance" "ec2_instance1" {
  for_each = aws_subnet.subnet-public
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.small"
  key_name = "kutty1"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = each.value.id
  tags = {
    Name = "main-ec2-instance1-${each.key}"
  }
  
}
resource "aws_security_group" "sg" {
  name       = "main-sg"
  description = "Security group for main VPC"
  vpc_id      = aws_vpc.main.id
}
resource "aws_security_group_rule" "allow_all" {
  for_each          = var.sg_ingress
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
} 
resource "aws_security_group_rule" "allow_all1" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  
} 

resource "aws_instance" "ec2_instance2" {
  for_each = aws_subnet.subnet-private
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t2.small"
  key_name = "kutty1"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id = each.value.id
  tags = {
    Name = "main-ec2-instance2-${each.key}"
  }
}
resource "aws_ec2_instance_connect_endpoint" "ec2_instance_connect_endpoint" {
  subnet_id = aws_subnet.subnet-private["app1"].id
  security_group_ids = [aws_security_group.sg1.id]
}
resource "aws_security_group" "sg1" {
  name       = "main-sg1"
  description = "Security group for main VPC"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow_all2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg1.id
  
} 
