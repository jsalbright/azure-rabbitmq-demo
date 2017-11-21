# create the temp ssh-key for our provisioners (remove later)
resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "azurerm_virtual_machine_scale_set" "rabbitmq_scaleset" {
  name                = "${var.environment}-rabbitmq-scaleset"
  location            = "${var.location}"
  resource_group_name = "${var.primary_rg_name}"
  upgrade_policy_mode = "Automatic"

  sku {
    name     = "${var.cluster_config["instance_type_name"]}"
    tier     = "Standard"
    capacity = "${var.cluster_config["min_count"]}"
  }

  storage_profile_image_reference {
    publisher = "${var.packer_image_config["publisher"]}"
    offer     = "${var.packer_image_config["offer"]}"
    sku       = "${var.packer_image_config["sku"]}"
    version   = "${var.packer_image_config["version"]}"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "rabbitmq-node"
    admin_username       = "${var.vm_username}"
    admin_password       = "${var.vm_password}"
  }

  # we need this for now to easily facilitate post-provisioners
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_username}/.ssh/authorized_keys"
      key_data = "${tls_private_key.ssh-key.public_key_openssh}"
    }
  }

  network_profile {
    name    = "rabbitmqnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "RabbitMQIPConfiguration"
      subnet_id                              = "${var.subnet_id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.rabbitmq_bepool.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${element(azurerm_lb_nat_pool.rabbitmq_elb_ports.*.id, count.index)}"]
    }
  }

  tags {
    environment = "staging"
  }
}
