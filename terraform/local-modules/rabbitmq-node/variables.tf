variable "rabbitmq_storage_config" {
  type        = "map"
  description = "A map of values for configuring the name of the storage-account and the storage-type for the VM(s)"

  default = {
    storageacct_name             = ""
    storageacct_replication_type = "LRS"
    storageacct_tier             = "Standard"
  }
}

variable "rabbitmq_fileshare_size" {
  type        = "string"
  description = "The size of the Azure file-share in GB"
  default     = "32"
}

variable "vm_username" {
  type    = "string"
  default = "administrator"
}

variable "vm_password" {
  type    = "string"
  default = "P@ssw0rd"
}

variable "cluster_config" {
  default = {
    instance_type_name = "Standard_A0"
    min_count          = 3
  }
}

variable "subnet_id" {
  type        = "string"
  description = "The subnet in which to deploy the VMs in our Scale-Sets"
}

# variable "rabbitmq_image_sku" {
#   description = "The release-name of the OS image that we will install for the Jenkins VM"
#   type        = "string"
# }
#
# variable "rabbitmq_vm_username" {
#   description = "The default username that we will use for connecting to the Jenkins VM"
#   type        = "string"
# }
#
# variable "rabbitmq_vm_password" {
#   # NOTE: 6-72 chars, at least 1 ucase and 1 lcase char and must contain a special char or number.
#   description = "The default password that we will use for connecting to the Jenkins VM"
#   type        = "string"
# }
#
# variable "rabbitmq_image_version" {
#   description = "The release-version of the OS image that we will install for the Jenkins VM"
#   type        = "string"
# }

variable "location" {
  type        = "string"
  description = "The Azure region in which to deploy the rabbitmq VM(s)"
}

variable "primary_rg_name" {
  type        = "string"
  description = "The name of the resource-group in which to create the Azure resources"
}

variable "environment" {
  type        = "string"
  description = "The name of the logical environment to associate these Azure resources"
}
