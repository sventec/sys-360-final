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
cd ../terraform
terraform init .
```

Create a `terraform.tfvars` file in the `terraform/` directory, and add the following contents:

```confini
ssh_public_key = ssh-ed25519 ...
```

Set the value of `ssh_public_key` to a public key you have access to. Optionally, add an `ssh_key_name` variable with the desired name for the key in AWS.

### Running

1. From the `packer` directory:
   1. Build the web server AMI: `packer build aws-webserver.pkr.hcl`
   1. Build the database AMI: `packer build aws-mariadb.pkr.hcl`
1. From the `terraform` directory:
   1. Deploy the environment with Terraform: `terraform apply`
      - Accept the deployment with `yes`
1. Check state with `terraform show`

## File structure

- `packer/`
  - `aws-webserver.pkr.hcl` - AMI creation for web server
  - `aws-mariadb.pkr.hcl` - AMI creation for MariaDB instance
  - `scripts/` - scripts used when provisioning AMIs
    - `webserver-setup.sh` - configure web server AMI
- `terraform/`
  - `terraform.tfvars` - set/override variables
    - this **must be** created and populated with (at least) `ssh_public_key`, as described [above](#prerequisites)
  - `main.tf` - AWS provider configuration
  - `net.tf` - networking config (VPC, subnets, IGW, etc.)
  - `vars.tf` - variable definitions
  - `webserver/` - module containing web server config
    - `main.tf` - web instance creation
    - `out.tf` - module outputs for use in other config sections
    - `sg.tf` - security group config
    - `vars.tf` - module input variable definitions
