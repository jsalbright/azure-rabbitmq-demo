output "subnet_names" {
  value = ["${azurerm_subnet.primary_subnets.*.name}"]
}

output "subnet_ids" {
  value = ["${azurerm_subnet.primary_subnets.*.id}"]
}
