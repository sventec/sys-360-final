# security group configuration for jumpbox

resource "aws_security_group" "jumpbox-sg" {
  name        = "jumpbox-sg"
  description = "traffic restrictions for SSH jumpbox"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "jumpbox_in_ssh" {
  # SSH in from anywhere
  security_group_id = aws_security_group.jumpbox-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "allow SSH inbound from anywhere"
}

resource "aws_vpc_security_group_egress_rule" "jumpbox_egress" {
  # unrestricted egress
  security_group_id = aws_security_group.jumpbox-sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

