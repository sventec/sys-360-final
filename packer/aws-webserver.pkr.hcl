packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "webserver" {
  profile = "voclab"
  region  = "us-east-1"
  # ami_name      = "webserver-${ formatdate("YYYY-MM-DD'T'hhmmssZ", timestamp()) }"
  ami_name      = "webserver-${regex_replace(timestamp(), "[- TZ:]", "")}"
  instance_type = "t2.micro"
  # latest Amazon Linux 2 AMI:
  source_ami_filter {
    filters = {
      architecture        = "x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
      name                = "amzn2-ami-*-hvm-*"
    }
    owners      = ["amazon"]
    most_recent = true
  }
  ssh_username = "ec2-user"
  tags = {
    Assignment = "Final"
  }
}

build {
  name = "build-webserver"
  sources = [
    "source.amazon-ebs.webserver"
  ]

  provisioner "shell" {
    script = "scripts/webserver-setup.sh"
  }
}

