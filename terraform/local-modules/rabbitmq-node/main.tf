# create a storage account for rabbitmq file-share
resource "azurerm_storage_account" "rabbitmq_storage_acct" {
  name                     = "${var.rabbitmq_storage_config["storageacct_name"]}"
  resource_group_name      = "${var.primary_rg_name}"
  location                 = "${var.location}"
  account_replication_type = "${var.rabbitmq_storage_config["storageacct_replication_type"]}"
  account_tier             = "${var.rabbitmq_storage_config["storageacct_tier"]}"
}

# create the rabbitmq file-share
resource "azurerm_storage_share" "rabbitmq_cluster_share" {
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

  #domain_name_label            = "${var.primary_rg_name}"

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

resource "azurerm_lb_nat_pool" "lbnatpool" {
  count                          = 3
  resource_group_name            = "${var.primary_rg_name}"
  name                           = "ssh"
  loadbalancer_id                = "${azurerm_lb.rabbitmq_elb.id}"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}
