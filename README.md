# SYS-360 Final Project

This is Terraform code used for completion of the SYS-360 Final Project.

## Usage

### Prerequisites

To use this, Packer CLI, Terraform CLI and AWS CLI must be installed and available.

Add the AWS Access Key ID, Secret Access Key, and Session Token from the AWS Learner Lab to `~/.aws/credentials` as the `voclab` profile:

```confini
[voclab]
aws_access_key_id=...
aws_secret_access_key=...
aws_session_token=...
```

Within this project directory, install the necessary Packer and Terraform plugins:

```bash
cd packer
packer init .
cd ../terraform/state-backend
terraform init && terraform apply
cd ..
terraform init
```

This will initialize Packer and install the AWS plugin, initialize Terraform and install the AWS plugin, and
additionally create an S3 remote backend for Terraform to remotely store the environment state. This allows for
modification of the environment without copying locally stored state information.

Create a `terraform.tfvars` file in the `terraform/` directory, and add the following contents:

```confini
ssh_public_key = "ssh-ed25519 ..."
```

Set the value of `ssh_public_key` to a public key you have access to. Optionally, add an `ssh_key_name` variable with the desired name for the key in AWS.

Optionally, create a `secret.auto.pkrvars.hcl` file in the `packer/` directory, with the passwords for MariaDB `root`
and `wordpress` users. These can also be passed to packer through the CLI using `-var "key=value"`:

```confini
db_password = "..."
wp_db_password = "..."
```

### Running

1. From the `packer` directory:
   1. Build the jumpbox AMI: `packer build aws-jumpbox.pkr.hcl`
   1. Build the database AMI: `packer build -var "db_password=SETDBPASSHERE" -var "wp_db_password=SETDBWPPASSHERE" aws-mariadb.pkr.hcl`
   1. Build the web server AMI: `packer build -var "wp_db_password=SETWPDBPASSHERE" aws-webserver.pkr.hcl`
2. From the `terraform` directory:
   1. Deploy the environment with Terraform: `terraform apply`
      - Accept the deployment with `yes`
      - Be sure to run the state-backend setup [above](#prerequisites) first
3. Done! Check state with `terraform show`

### Using the jumpbox

To use the SSH jumpbox, copy the SSH private key supplied when provisioning to the jumpbox (the public key provided in
the `.tfvars` file):

```bash
scp -i /path/to/id_ed25519 /path/to/id_ed25519 ec2-user@<public IP>:~/.ssh/id_ed25519
```

For added security, create a new keypair on the jumpbox with `ssh-keygen` and use the existing private key to copy it to
the webserver and DB hosts. Then, the private key used for access to the jumpbox can be deleted from that host.

## File structure

- `packer/`
  - `aws-webserver.pkr.hcl` - AMI creation for web server
  - `aws-jumpbox.pkr.hcl` - AMI creation for SSH jumpbox
  - `aws-mariadb.pkr.hcl` - AMI creation for MariaDB instance
  - `scripts/` - scripts used when provisioning AMIs
    - `mariadb-setup.sh` - configure mariadb AMI, along with inlinle scripts
    - `webserver-setup.sh` - configure web server AMI
    - `webserver-wp-setup.sh` - install WordPress on web server AMI
  - `secret.auto.pkrvars.hcl` - optional: set DB secrets in file instead of via command line, as described [above](#prerequisites)
- `terraform/`
  - `terraform.tfvars` - set/override variables
    - this **must be** created and populated with (at least) `ssh_public_key`, as described [above](#prerequisites)
    - alternately, the SSH public key can be passed to `terraform` [as an agrument](https://developer.hashicorp.com/terraform/language/values/variables#variables-on-the-command-line)
  - `main.tf` - AWS provider configuration
  - `net.tf` - networking config (VPC, subnets, IGW, etc.)
  - `vars.tf` - variable definitions
  - `webserver/` - module containing web server config
    - `main.tf` - web instance creation
    - `out.tf` - module outputs for use in other config sections
    - `sg.tf` - security group config
    - `vars.tf` - module input variable definitions
  - same structure as `webserver/` for `jumpbox/` and `mariadb/`, performing same steps for those instances
  - `state-backend/` - one-time setup for the S3 backend configured to save environment state (see [above](#prerequisites))
    - `main.tf`  - module to create S3 bucket and table, with appropriate options, to serve as primary config S3 backend
