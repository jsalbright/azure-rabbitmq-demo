# this data block obtains the user's environment variables for provider credentials
data "azurerm_client_config" "current_config" {}

# create a resource group for the Jenkins VM
resource "azurerm_resource_group" "jenkins_rg" {
  name      = "${var.environment}jenkinsrg"
  location  = "${var.location}"
}

# create a storage account for Jenkins file share
resource "azurerm_storage_account" "jenkins_storage" {
  name                = "${var.jenkins_storageacct_name}"
  resource_group_name = "${azurerm_resource_group.jenkins_rg.name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

# create the jenkins file share
resource "azurerm_storage_share" "jenkins_share" {
  name                  = "${var.jenkins_fileshare_name}"
  resource_group_name  	= "${azurerm_resource_group.jenkins_rg.name}"
  storage_account_name 	= "${azurerm_storage_account.jenkins_storage.name}"
  quota                 = "${var.jenkins_fileshare_size}"
}

# create our security-group to contain our rules
resource "azurerm_network_security_group" "jenkins_nsg" {
  name      = "${var.environment}_jenkins_nsg"
  location  = "${var.jenkins_location}"
  resource_group_name = "${azurerm_resource_group.jenkins_rg.name}"
}

# create the Subnet in our VNET in which Jenkins will be deployed for our test
resource "azurerm_subnet" "jenkins_subnet" {
  name                  = "${var.subnet_name}"
  resource_group_name   = "${azurerm_resource_group.jenkins_rg.name}"
  virtual_network_name	= "${var.vnet_name}"
  address_prefix        = "${var.subnet_cidr}"
}

# create the NIC for the Jenkins VM
resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkinsnic"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.jenkins_rg.name}"

  ip_configuration {
    name      = "jenkinsipconfig"
    subnet_id = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
  }
}

# create the inbound port rules for Jenkins by iterating over the array of inbound ports (80, 8080, 22)
resource "azurerm_network_security_rule" "jenkins_sgrules" {
  count                       = "${length(var.jenkins_tcp_inbout_ports) > 0 ? length(var.jenkins_tcp_inbout_ports) : 0}"
  name                        = "jenkinstcp${var.jenkins_tcp_inbout_ports[count.index]}"
  priority                    = "${100 + count.index}"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "${var.jenkins_tcp_inbout_ports[count.index]}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.jenkins_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.jenkins_nsg.name}"
}

# create the managed-disk for our Jenkins VM
resource "azurerm_managed_disk" "jenkins_mdisk" {
  name                 = "${var.environment}_jenkins_mdisk"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.jenkins_rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "32"
}

# create the temp ssh-key for our provisioner
resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# create our jenkins vm and conditionally attach the additional nic with a public-ip if unit-testing
resource "azurerm_virtual_machine" "jenkins_vm" {
  name                  = "${var.environment}_jenkins_vm"
  location              = "${var.location}"
  vm_size               = "${var.jenkins_vm_size}"
  resource_group_name   = "${azurerm_resource_group.jenkins_rg.name}"
  network_interface_ids = ["${var.}"]
  primary_network_interface_id = "${element(split(",", data.template_file.nic_ids.rendered),0)}"

  storage_image_reference {
    publisher = "${var.jenkins_image_publisher}"
    offer     = "${var.jenkins_image_offer}"
    sku       = "${var.jenkins_image_sku}"
    version   = "${var.jenkins_image_version}"
  }

  # boot volume
  storage_os_disk {
    name              = "jenkinsosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # ephemeral disk
  storage_data_disk {
    name            = "${azurerm_managed_disk.jenkins_mdisk.name}"
    managed_disk_id = "${azurerm_managed_disk.jenkins_mdisk.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.jenkins_mdisk.disk_size_gb}"
  }

  # default initial creds for Jenkins VM
  os_profile {
    computer_name  = "${var.environment_name}-jenkins"
    admin_username = "${var.jenkins_vm_username}"
    admin_password = "${var.jenkins_vm_password}"
  }

  # we need this for now to easily facilitate post-provisioners
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.jenkins_vm_username}/.ssh/authorized_keys"
      key_data = "${tls_private_key.ssh-key.public_key_openssh}"
    }
  }

  tags {
    Name 	= "jenkins-vm"
    environment = "${var.environment_name}"
    Network	= "Private"
  }
}
