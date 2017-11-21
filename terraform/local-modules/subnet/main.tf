resource "azurerm_subnet" "primary_subnets" {
  count                     = "${length(keys(var.subnet_configs))}"
  name                      = "${var.environment}.subnet.${element(keys(var.subnet_configs), count.index)}"
  resource_group_name       = "${var.primary_rg_name}"
  virtual_network_name      = "${var.primary_vnet_name}"
  address_prefix            = "${var.subnet_configs["${element(keys(var.subnet_configs), count.index)}"]}"
  network_security_group_id = "${element(azurerm_network_security_group.nsg.*.id, count.index)}"
}

resource "azurerm_network_security_group" "nsg" {
  count               = "${length(keys(var.subnet_configs))}"
  name                = "${var.environment}.nsg.${element(keys(var.subnet_configs), count.index)}"
  location            = "${var.location}"
  resource_group_name = "${var.primary_rg_name}"

  tags {
    environment = "${var.environment}"
  }
}
