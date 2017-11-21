variable "packer_image_config" {
  type        = "map"
  description = "The metadata of the jumpbox image that we consume from our packer immutable image pipeline"

  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

variable "location" {
  type        = "string"
  description = "The Azure region where the public subnet exists into which we will deploy the bastion host VM"
}

variable "instance_size" {
  default = "Standard_DS1_v2"
}

variable "vm_username" {
  type        = "string"
  description = "The username for the VM that we will associate with the ssh keypair that gets generated for the post-provisioners to use"
}

variable "vm_password" {
  type        = "string"
  description = "The password for our VM post-provisioner user"
}

variable "environment" {
  type = "string"
}

variable "primary_rg_name" {
  type        = "string"
  description = "The primary resource group in which we will create the bastion host resources"
}

variable "public_subnet_id" {
  type        = "string"
  description = "The ID of the public subnet in which the bastion host VM will be deployed"
}
