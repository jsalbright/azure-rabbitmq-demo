variable "location" {
  description = "The Azure Region in which all of the resources will be created"
  type        = "string"
  default     = "East US"
}

variable "environment" {
  description = "The name of the MVC environment"
  type        = "string"
}

variable "vnet_cidr" {
  description = "The CIDR/address-space of the VNET in which we will deploy all of the MVC resources"
  type        = "string"

  #default = "10.10.0.0/16"
}
