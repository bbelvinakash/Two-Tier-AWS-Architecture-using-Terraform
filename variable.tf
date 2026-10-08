variable "ingress_nacl_public" {
  type = list(object({
    rule_no    = number
    protocol   = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))

  default = [
    { rule_no = 100, protocol = 6, action = "allow", cidr_block = "0.0.0.0/0", from_port = 22, to_port = 22 },
    { rule_no = 101, protocol = 6, action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
    { rule_no = 102, protocol = 6, action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 }
  ]
}
variable "egress_nacl_public" {
  type = list(object({
    rule_no    = number,
    protocol   = number,
    action     = string
    cidr_block = string
    to_port    = number
    from_port  = number
  }))
  default = [
    { rule_no = 100, protocol = -1, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }
  ]
}
variable "sg_ingress" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = number
    cidr_blocks = list(string)
  }))
  default = {
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = 6
      cidr_blocks = ["0.0.0.0/0"]
    },
    https = {
      from_port   = 443
      to_port     = 443
      protocol    = 6
      cidr_blocks = ["0.0.0.0/0"]
    },
   ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = 6
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}