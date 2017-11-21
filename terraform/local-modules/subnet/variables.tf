variable "primary_nsg_id" {
  type        = "string"
  description = "The ID of the main network security-group that we're using to provision our subnets"
}

variable "location" {
  description = "Base-Subnet - Location Name (East US)"
  default     = "East US"
  type        = "string"
}

variable "environment" {
  description = "Base-Subnet - Environment Name (DEV)"
  type        = "string"
}

# variable "subnets_names" {
#   default     = ["pub", "priv"]
#   type        = "list"
#   description = "Base-Subnet - Subnet Names (AD, Core, etc) "
# }

variable "subnet_configs" {
  default = {
    subnet_a = "10.0.1.0/24"
    subnet_b = "10.0.2.0/24"
  }
}

variable "primary_rg_name" {
  description = "Base-Subnet - Resource Group Name {Output from base-vNet}"
}

# variable "subnets_cidrs" {
#   type        = "list"
#   description = "Base-Subnet - Subnets CIDR (1.2.3.4/24 , 5.6.7.8/28)"
# }

variable "primary_vnet_name" {
  description = "Base-Subnet - vNet Name {Output from base-vNet}"
}
