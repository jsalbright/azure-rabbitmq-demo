variable "rabbitmq_vm_username" {
  default = "rabbitmqadmin"
}

variable "rabbitmq_vm_password" {
  default = "P@ssw0rd!"
}

variable "bastion_vm_username" {
  default = "bastionadmin"
}

variable "bastion_vm_password" {
  default = "P@ssw0rd!"
}

variable "subnet_configs" {
  type = "map"

  default = {
    subnet_a = "10.0.1.0/24"
    subnet_b = "10.0.2.0/24"
  }
}

variable "packer_image_config_rabbitmq" {
  type = "map"

  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

variable "packer_image_config_bastion" {
  type = "map"

  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

variable "scaleset_subnet_id" {
  default = "subnet_a"
}

variable "vnet_cidr" {
  description = "The overall address-space for our entire virtual network"
  default     = "10.0.0.0/16"
}

variable "rabbitmq_storage_config" {
  type        = "map"
  description = "A map of values for configuring the name of the storage-account and the storage-type for the VM(s)"

  default = {
    storageacct_name             = ""
    storageacct_replication_type = "LRS"
    storageacct_tier             = "Standard"
  }
}

variable "location" {
  description = "The Azure Region in which to provision the VNET resources"
  type        = "string"
}

variable "environment" {
  description = "The name of the environment to attach to the Jenkins VM as a Tag"
  type        = "string"
}
