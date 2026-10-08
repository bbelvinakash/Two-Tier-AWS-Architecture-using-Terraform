locals {
  subnet = {
    web = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    }
    web1 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  }
}
locals {
  subnet1 = {
    app = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1a"
    }
    app1 = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"
    }
  }
}
