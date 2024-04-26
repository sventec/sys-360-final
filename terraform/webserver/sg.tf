# security group configuration for both private and public subnets

resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "traffic restrictions for web server"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "web_in_http" {
  security_group_id = aws_security_group.web-sg.id
  # HTTP in from anywhere
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  description = "allow HTTP inbound from anywhere"
}

resource "aws_vpc_security_group_egress_rule" "web_egress" {
  security_group_id = aws_security_group.web-sg.id
  # unrestricted egress
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}


