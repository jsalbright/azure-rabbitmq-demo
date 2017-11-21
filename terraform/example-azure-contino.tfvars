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
