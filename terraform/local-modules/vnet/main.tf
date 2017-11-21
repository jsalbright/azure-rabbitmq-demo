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

resource "azurerm_network_security_group" "vnet_security_groups" {
  count               = "${length(keys(var.vnet_security_groups))}"
  name                = "${var.environment}.nsg.${element(keys(var.vnet_security_groups), count.index)}"
  location            = "${var.vnet_security_groups["${element(keys(var.vnet_security_groups), count.index)}"]}"
  resource_group_name = "${azurerm_resource_group.vnet_rg.name}"

  tags {
    environment = "${var.environment}"
  }
}
