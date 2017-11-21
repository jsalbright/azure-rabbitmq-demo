variable "primary_nsg_name" {
  type        = "string"
  description = "The name of the NSG associated with the subnets in which your scale-set VMs will be deployed"
}

variable "cluster_config" {
  default = {}
}

variable "rabbitmq_elb_ports" {
  type = "map"

  default = {
    # port-name = ["elb-port-start", "elb-port-stop", "host-target-port", "protocol"]
    rabbitmq_gui = ["80", "80", "5672", "Tcp"]
  }
}

variable "rabbitmq_sg_rules_outbound" {
  type = "map"

  default = {
    # rule-name = ["source-port-range", "dest-port-range", "priority", "access-type", "protocol"]
    all_outbound = ["*", "*", "1000", "Allow", "Tcp", "*", "*", "Internet"]
  }
}

variable "rabbitmq_sg_rules_inbound" {
  type = "map"

  default = {
    # rule-name = ["source-port-range", "dest-port-range", "priority", "access-type", "protocol"]
    ssh          = ["22", "22", "110", "Allow", "Tcp", "VirtualNetwork"]
    rabbitmq     = ["5672", "5672", "120", "Allow", "Tcp", "VirtualNetwork"]
    rabbitmq_gui = ["15672", "15672", "130", "Allow", "Tcp", "VirtualNetwork"]
  }
}

variable "packer_image_config" {
  type        = "map"
  description = "The metadata of the rabbitmq image that we consume from our packer immutable image pipeline"

  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

variable "vm_port_configs" {
  type = "map"

  default = {
    ssh = "22"
  }
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

variable "rabbitmq_fileshare_size" {
  type        = "string"
  description = "The size of the Azure file-share in GB"
  default     = "32"
}

variable "vm_username" {
  type        = "string"
  description = "The username for the VM that we will associate with the ssh keypair that gets generated for the post-provisioners to use"
}

variable "vm_password" {
  type        = "string"
  description = "The password for our VM post-provisioner user"
}

variable "cluster_config" {
  type = "map"

  default = {
    instance_type_name = "Standard_A0"
    min_count          = 2
  }
}

variable "subnet_id" {
  type        = "string"
  description = "The subnet in which to deploy the VMs in our Scale-Sets"
}

variable "create_storage" {
  type        = "string"
  description = "Toggle creating file-share until we actually need it"
  default     = "false"
}

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
