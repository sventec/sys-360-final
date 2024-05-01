# mariadb configuration module

data "aws_ami" "mariadb" {
  # AMI created with Packer: `aws-mariadb.pkr.hcl`
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["mariadb-*"]
  }
}

resource "aws_instance" "mariadb" {
  ami                    = data.aws_ami.mariadb.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mariadb-sg.id]
  key_name               = var.ssh_key_name
  subnet_id              = var.subnet_id
  private_ip             = "10.10.15.60"
  tags                   = { Name = "mariadb" }
}
