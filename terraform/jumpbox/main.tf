# jumpbox configuration module

data "aws_ami" "jumpbox" {
  # AMI created with Packer: `aws-jumpbox.pkr.hcl`
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["jumpbox-*"]
  }
}

resource "aws_instance" "jumpbox" {
  ami                    = data.aws_ami.jumpbox.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jumpbox-sg.id]
  key_name               = var.ssh_key_name
  subnet_id              = var.subnet_id
  private_ip             = "10.10.10.30"
  tags                   = { Name = "jumpbox" }
}
