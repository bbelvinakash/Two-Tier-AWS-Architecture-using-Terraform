output "pub-out" {
  value = { for key, value in aws_subnet.subnet-public : key => {
    cidr_block        = value.cidr_block
    availability_zone = value.availability_zone
    }
  }
}
output "priv-out" {
  value = { for key, value in aws_subnet.subnet-private : key => {
    cidr_block        = value.cidr_block
    availability_zone = value.availability_zone
    }
  }
}

