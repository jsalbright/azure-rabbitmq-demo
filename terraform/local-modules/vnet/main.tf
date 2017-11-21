data "azurerm_client_config" "current_config" {}

# create the primary resource-group for our environment
resource "azurerm_resource_group" "vnet_rg" {
  name     = "${var.environment}.vnetrg"
  location = "${var.location}"

  tags {
    environment = "${var.environment}"
    location    = "${var.location}"
  }
}

# create the primary vnet for our environment
resource "azurerm_virtual_network" "primary_vnet" {
  name                = "${var.environment}.vnet"
  resource_group_name = "${azurerm_resource_group.vnet_rg.name}"
  address_space       = ["${var.vnet_cidr}"]
  location            = "${var.location}"

  tags {
    environment = "${var.environment}"
  }
}
