output "vnet_rg_name" {
  value = "${azurerm_resource_group.vnet_rg.name}"
}

output "primary_vnet_id" {
  value = "${azurerm_virtual_network.primary_vnet.id}"
}

output "primary_vnet_name" {
  value = "${azurerm_virtual_network.primary_vnet.name}"
}

output "primary_nsg_ids" {
  value = ["${azurerm_network_security_group.vnet_security_groups.*.id}"]
}

output "primary_nsg_names" {
  value = ["${azurerm_network_security_group.vnet_security_groups.*.name}"]
}
