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
}

module "rabbitmq-nodes" {
  source                  = "local-modules/rabbitmq-node"
  environment             = "${var.environment}"
  rabbitmq_storage_config = "${var.rabbitmq_storage_config}"
  location                = "${var.location}"
  subnet_id               = "${element(module.rabbitmq_subnets.subnet_ids, 0)}"
  primary_rg_name         = "${module.rabbitmq_vnet.vnet_rg_name}"
}
