What is this?
==============

This will deploy a VM Scale Set using a Packer-generated image.
See the `packer` directory for information on how to create this image.

How do I use it?
================

You will need to install Docker to use this Makefile.

1. Clone this repository.
2. Create your .env: `cp .env.example .env`
3. Populate your `.env` with real values. See [this](https://www.packer.io/docs/builders/azure-setup.html) document for information on how to get started.
4. Create your `terraform.tfvars`: `cp example-azure-contino.tfvars terraform.tfvars`
5. Populate your `terraform.tfvars` with real values.
6. Ensure that you can create a plan: `make plan`
7. Apply the plan: `make apply`
