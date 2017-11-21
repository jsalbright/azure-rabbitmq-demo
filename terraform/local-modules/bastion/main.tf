resource "azurerm_public_ip" "jumpbox-pubip" {
  name                         = "${var.environment}-jumpbox-pubip"
  location                     = "${var.location}"
  resource_group_name          = "${var.primary_rg_name}"
  public_ip_address_allocation = "static"

  #domain_name_label            = "${var.primary_rg_name}-ssh"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_network_interface" "jumpbox-nic" {
  name                = "${var.environment}-jumpbox-nic"
  location            = "${var.location}"
  resource_group_name = "${var.primary_rg_name}"

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${var.public_subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.jumpbox-pubip.id}"
  }

  tags {
    environment = "${var.environment}"
  }
}

# create the temp ssh-key for our provisioners (remove later)
resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "azurerm_virtual_machine" "jumpbox" {
  name                  = "${var.environment}-jumpbox"
  location              = "${var.location}"
  resource_group_name   = "${var.primary_rg_name}"
  network_interface_ids = ["${azurerm_network_interface.jumpbox-nic.id}"]
  vm_size               = "${var.instance_size}"

  storage_image_reference {
    publisher = "${var.packer_image_config["publisher"]}"
    offer     = "${var.packer_image_config["offer"]}"
    sku       = "${var.packer_image_config["sku"]}"
    version   = "${var.packer_image_config["version"]}"
  }

  storage_os_disk {
    name              = "jumpbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "jumpbox"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_username}/.ssh/authorized_keys"
      key_data = "${tls_private_key.ssh-key.public_key_openssh}"
    }
  }

  tags {
    environment = "${var.environment}"
  }
}
