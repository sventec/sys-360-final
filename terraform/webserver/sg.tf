# security group configuration for webserver

resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "traffic restrictions for web server"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "web_in_http" {
  # HTTP in from anywhere
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "allow HTTP inbound from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "web_in_https" {
  # HTTPS in from anywhere
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "allow HTTPS inbound from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "web_in_ssh_jumpbox" {
  # SSH in from jumpbox only
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "10.10.10.30/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "allow SSH inbound from jumpbox only"
}

resource "aws_vpc_security_group_egress_rule" "web_egress" {
  # unrestricted egress
  security_group_id = aws_security_group.web-sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
