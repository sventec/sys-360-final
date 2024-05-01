packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "mariadb" {
  profile       = "voclab"
  region        = "us-east-1"
  ami_name      = "mariadb-${regex_replace(timestamp(), "[- TZ:]", "")}"
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

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Root password for DB"
}

variable "wp_db_password" {
  type        = string
  sensitive   = true
  description = "Password for wordpress DB user"
}

build {
  name = "build-mariadb"
  sources = [
    "source.amazon-ebs.mariadb"
  ]

  provisioner "shell" {
    # sleep to let machine fully boot
    inline = ["sleep 15"]
  }

  # install and start mariadb
  provisioner "shell" {
    script = "scripts/mariadb-setup.sh"
  }

  # set mariadb root password
  provisioner "shell" {
    inline = ["mysql -u root -pCHANGEME -e \"UPDATE mysql.user SET Password = PASSWORD('${var.db_password}') WHERE User = 'root'; FLUSH PRIVILEGES;\""]
  }

  # create wordpress DB and user
  provisioner "shell" {
    inline = [
      "mysql -u root '-p${var.db_password}' -e \"CREATE DATABASE wordpress; CREATE USER wordpressuser@10.10.10.25 IDENTIFIED BY '${var.wp_db_password}';\"",
      "mysql -u root '-p${var.db_password}' -e \"GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@10.10.10.25 IDENTIFIED BY '${var.wp_db_password}'; FLUSH PRIVILEGES;\""
    ]
  }
}
