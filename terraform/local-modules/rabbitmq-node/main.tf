# create a storage account for rabbitmq file-share
resource "azurerm_storage_account" "rabbitmq_storage_acct" {
  count                    = "${var.create_storage == "true" ? 1 : 0}"
  name                     = "${var.rabbitmq_storage_config["storageacct_name"]}"
  resource_group_name      = "${var.primary_rg_name}"
  location                 = "${var.location}"
  account_replication_type = "${var.rabbitmq_storage_config["storageacct_replication_type"]}"
  account_tier             = "${var.rabbitmq_storage_config["storageacct_tier"]}"
}

# create the rabbitmq file-share
resource "azurerm_storage_share" "rabbitmq_cluster_share" {
  count                = "${var.create_storage == "true" ? 1 : 0}"
  name                 = "rabbitmq-${var.environment}"
  resource_group_name  = "${var.primary_rg_name}"
  storage_account_name = "${azurerm_storage_account.rabbitmq_storage_acct.name}"
  quota                = "${var.rabbitmq_fileshare_size}"
}

# create a public ip to assign to our ELB
resource "azurerm_public_ip" "rabbitmq_elb_ip" {
  name                         = "${var.environment}-rabbitmq-elb"
  location                     = "${var.location}"
  resource_group_name          = "${var.primary_rg_name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "${var.environment}"
  }
}

# create our rabbitmq cluster elb
resource "azurerm_lb" "rabbitmq_elb" {
  name                = "${var.environment}-rabbitmq-lb"
  location            = "${var.location}"
  resource_group_name = "${var.primary_rg_name}"

  frontend_ip_configuration {
    name                 = "${var.environment}-elb-pubip"
    public_ip_address_id = "${azurerm_public_ip.rabbitmq_elb_ip.id}"
  }
}

# create our address pool for our elb
resource "azurerm_lb_backend_address_pool" "rabbitmq_bepool" {
  resource_group_name = "${var.primary_rg_name}"
  loadbalancer_id     = "${azurerm_lb.rabbitmq_elb.id}"
  name                = "${var.environment}-bepool-rabbitmq"
}

resource "azurerm_lb_nat_pool" "rabbitmq_elb_ports" {
  count                          = "${length(keys(var.rabbitmq_elb_ports))}"
  resource_group_name            = "${var.primary_rg_name}"
  name                           = "${element(keys(var.rabbitmq_elb_ports), count.index)}"
  loadbalancer_id                = "${azurerm_lb.rabbitmq_elb.id}"
  frontend_port_start            = "${element(var.rabbitmq_elb_ports["${element(keys(var.rabbitmq_elb_ports), count.index)}"], count.index + 0)}"
  frontend_port_end              = "${element(var.rabbitmq_elb_ports["${element(keys(var.rabbitmq_elb_ports), count.index)}"], count.index + 1) + 1}" # we need the + 1 because Azure requires end port greater-than start
  backend_port                   = "${element(var.rabbitmq_elb_ports["${element(keys(var.rabbitmq_elb_ports), count.index)}"], count.index + 2)}"
  protocol                       = "${element(var.rabbitmq_elb_ports["${element(keys(var.rabbitmq_elb_ports), count.index)}"], count.index + 3)}"
  frontend_ip_configuration_name = "${var.environment}-elb-pubip"
}

# resource "azurerm_network_security_rule" "rabbitmq-sg-rules-inbound" {
#   count                       = "${length(keys(var.rabbitmq_sg_rules_inbound))}"
#   name                        = "${element(keys(var.rabbitmq_sg_rules_inbound), count.index)}"
#   resource_group_name         = "${var.primary_rg_name}"
#   network_security_group_name = "${var.primary_nsg_name}"
#   source_port_range           = "${element(var.rabbitmq_sg_rules_inbound["${element(keys(var.rabbitmq_sg_rules_inbound), count.index)}"], count.index - 1)}"
#   destination_port_range      = "${element(var.rabbitmq_sg_rules_inbound["${element(keys(var.rabbitmq_sg_rules_inbound), count.index)}"], count.index - 2)}"
#   priority                    = "${element(var.rabbitmq_sg_rules_inbound["${element(keys(var.rabbitmq_sg_rules_inbound), count.index)}"], count.index - 3)}"
#   access                      = "${element(var.rabbitmq_sg_rules_inbound["${element(keys(var.rabbitmq_sg_rules_inbound), count.index)}"], count.index - 4)}"
#   protocol                    = "${element(var.rabbitmq_sg_rules_inbound["${element(keys(var.rabbitmq_sg_rules_inbound), count.index)}"], count.index - 5)}"
#   direction                   = "Inbound"
# }
#
# resource "azurerm_network_security_rule" "rabbitmq-sg-rules-outbound" {
#   count                       = "${length(keys(var.rabbitmq_sg_rules_outbound))}"
#   name                        = "${element(keys(var.rabbitmq_sg_rules_outbound), count.index)}"
#   resource_group_name         = "${var.primary_rg_name}"
#   network_security_group_name = "${var.primary_nsg_name}"
#   source_port_range           = "${element(var.["${element(keys(var.rabbitmq_sg_rules_outbound), count.index)}"], count.index - 1)}"
#   destination_port_range      = "${element(var.rabbitmq_sg_rules_outbound["${element(keys(var.rabbitmq_sg_rules_outbound), count.index)}"], count.index - 2)}"
#   priority                    = "${element(var.rabbitmq_sg_rules_outbound["${element(keys(var.rabbitmq_sg_rules_outbound), count.index)}"], count.index - 3)}"
#   access                      = "${element(var.rabbitmq_sg_rules_outbound["${element(keys(var.rabbitmq_sg_rules_outbound), count.index)}"], count.index - 4)}"
#   protocol                    = "${element(var.rabbitmq_sg_rules_outbound["${element(keys(var.rabbitmq_sg_rules_outbound), count.index)}"], count.index - 5)}"
#   direction                   = "Inbound"
# }

