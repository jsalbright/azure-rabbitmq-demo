resource "azurerm_subnet" "primary_subnets" {
  count                     = "${length(keys(var.subnet_configs))}"
  name                      = "${var.environment}.subnet.${element(keys(var.subnet_configs), count.index)}"
  resource_group_name       = "${var.primary_rg_name}"
  virtual_network_name      = "${var.primary_vnet_name}"
  address_prefix            = "${var.subnet_configs["${element(keys(var.subnet_configs), count.index)}"]}"
  network_security_group_id = "${var.primary_nsg_id}"
}
