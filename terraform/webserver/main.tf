# webserver configuration module

data "aws_ami" "webserver" {
  # AMI created with Packer: `aws-webserver.pkr.hcl`
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["webserver-*"]
  }
}

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.webserver.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = var.ssh_key_name
  subnet_id              = var.subnet_id
  private_ip             = "10.10.10.25"
  tags                   = { Name = "webserver" }
}
