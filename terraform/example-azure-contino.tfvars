location = "East US"

environment = "dev"

subnet_configs = {
  subnet_a = "10.0.1.0/24"
  subnet_b = "10.0.2.0/24"
}

rabbitmq_storage_config = {
  storageacct_name             = "rabbitmqstorageacct"
  storageacct_replication_type = "LRS"
  storageacct_tier             = "Standard"
}

rabbitmq_fileshare_size = "32"

packer_image_config = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "16.04-LTS"
  version   = "latest"
}

rabbitmq_vm_username = "rabbitmqadmin"

rabbitmq_vm_password = "P@ssw0rd!"

bastion_vm_username = "bastionadmin"

bastion_vm_password = "P@ssw0rd!"

rabbitmq_image_version = 4
