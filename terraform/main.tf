data "azurerm_client_config" "current" {}

module "rabbitmq_vnet" {
  source      = "local-modules/vnet"
  vnet_cidr   = "10.0.0.0/16"
  environment = "${var.environment}"
  location    = "${var.location}"
}

module "rabbitmq_subnets" {
  source            = "local-modules/subnet"
  location          = "${var.location}"
  environment       = "${var.environment}"
  subnet_configs    = "${var.subnet_configs}"
  primary_rg_name   = "${module.rabbitmq_vnet.vnet_rg_name}"
  primary_vnet_name = "${module.rabbitmq_vnet.primary_vnet_name}"
  primary_nsg_id    = "${element(module.rabbitmq_vnet.primary_nsg_ids, 0)}"
}

module "rabbitmq-nodes" {
  source                  = "local-modules/rabbitmq-node"
  environment             = "${var.environment}"
  rabbitmq_storage_config = "${var.rabbitmq_storage_config}"
  location                = "${var.location}"
  subnet_id               = "${element(module.rabbitmq_subnets.subnet_ids, 0)}"
  primary_rg_name         = "${module.rabbitmq_vnet.vnet_rg_name}"
  primary_nsg_name        = "${element(module.rabbitmq_vnet.primary_nsg_names, 0)}"
  vm_username             = "${var.rabbitmq_vm_username}"
  vm_password             = "${var.rabbitmq_vm_password}"
  packer_image_config     = "${var.packer_image_config_rabbitmq}"
  cluster_config          = "${var.cluster_config}"
  admin_password          = "${var.admin_password}"
  rabbit_password         = "${var.rabbit_password}"
}

module "bastion-host" {
  source              = "local-modules/bastion"
  environment         = "${var.environment}"
  location            = "${var.location}"
  vm_username         = "${var.bastion_vm_username}"
  vm_password         = "${var.bastion_vm_password}"
  packer_image_config = "${var.packer_image_config_bastion}"
  primary_rg_name     = "${module.rabbitmq_vnet.vnet_rg_name}"
  public_subnet_id    = "${element(module.rabbitmq_subnets.subnet_ids, 0)}"
}
