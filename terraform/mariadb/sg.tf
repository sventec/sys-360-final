# security group configuration for mariadb

resource "aws_security_group" "mariadb-sg" {
  name        = "mariadb-sg"
  description = "traffic restrictions for mariadb server"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "mariadb_in_mysql_web" {
  # MySQL in from webserver only
  security_group_id = aws_security_group.mariadb-sg.id
  cidr_ipv4         = "10.10.10.25/32"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  description       = "allow MySQL inbound from webserver"
}

resource "aws_vpc_security_group_ingress_rule" "mariadbb_in_ssh_jumpbox" {
  # SSH in from jumpbox only
  security_group_id = aws_security_group.mariadb-sg.id
  cidr_ipv4         = "10.10.10.30/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "allow SSH inbound from jumpbox only"
}

resource "aws_vpc_security_group_egress_rule" "mariadb_egress" {
  # unrestricted egress
  security_group_id = aws_security_group.mariadb-sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

