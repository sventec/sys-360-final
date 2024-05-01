_default:
	@just --list

build-web:
	cd packer && packer build -var-file="secret.auto.pkrvars.hcl" aws-webserver.pkr.hcl

build-jump:
	cd packer && packer build aws-jumpbox.pkr.hcl

build-db:
	cd packer && packer build -var-file="secret.auto.pkrvars.hcl" aws-mariadb.pkr.hcl

apply:
	cd terraform && terraform apply

@init:
	#!/usr/bin/env bash
	cd packer
	packer init .
	cd ../terraform/state-backend
	terraform init && terraform apply
	cd ..
	terraform init

# vim: set ft=make:
