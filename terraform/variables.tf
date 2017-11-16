variable "dry_run" {
  description = "This value toggles whether we create an additional VNET and Subnet to deploy Jenkins into. For testing only."
  default = 1
}

variable "vnet_name" {
  description = "The name of the Virtual Network in Azure"
  type = "string"
}

variable "subnet_name" {
  description = "The default subnet name for this Virtual Network"
  type = "string"
}

variable "subnet_cidr" {
  description = "The CIDR block for this Virtual Network's default subnet"
  type = "string"
}

variable "location" {
  description = "The Azure Region in which to provision the VNET resources"
  type = "string"
}

variable "subnet_id" {
  description = "The ID of the Subnet within our VNET where we will deploy the Jenkins VM"
  type = "string"
}

variable "jenkins_fileshare_name" {
  # NOTE: Alphanumeric and hyphens, Lowercase only
  description = "The name of the fileshare that we will create in our storage account for Jenkins VM"
  type = "string"
}

variable "jenkins_fileshare_size" {
  description = "The size of the fileshare in GB"
  type = "string"
}

variable "jenkins_storageacct_name" {
  # NOTE: Alphanumeric, Lowercase only, between 3-24 chars
  description = "The name of our Storage Account in which we will create the fileshare."
  type = "string"
}

variable "jenkins_image_sku" {
  description = "The release-name of the OS image that we will install for the Jenkins VM"
  type = "string"
}

variable "jenkins_vm_username" {
  description = "The default username that we will use for connecting to the Jenkins VM"
  type = "string"
}

variable "jenkins_vm_password" {
  # NOTE: 6-72 chars, at least 1 ucase and 1 lcase char and must contain a special char or number.
  description = "The default password that we will use for connecting to the Jenkins VM"
  type = "string"
}

variable "jenkins_image_version" {
  description = "The release-version of the OS image that we will install for the Jenkins VM"
  type = "string"
}

variable "environment" {
  description = "The name of the environment to attach to the Jenkins VM as a Tag"
  type = "string"
}

variable "jenkins_image_publisher" {
  description = "The name of the Owner of the OS image that we will install for the Jenkins VM "
  type = "string"
}

variable "jenkins_image_offer" {
  # to determine this info, run this command locally:  az vm image list -o table
  description = "The internal name of the OS-type in Azure (e.g. WindowsServer, UbuntuServer, RHEL)"
  type = "string"
}

variable "jenkins_vm_size" {
  description = "The Azure VM instance-size as a name (e.g. Standard_D3_v2)"
  type = "string"
}

variable "jenkins_tcp_inbout_ports" {
  description = "The list of inbound TCP ports that the Jenkins VM must be able to listen on"
  default = ["80", "8080", "22"]
  type = "list"
}

variable "jenkins_udp_inbound_ports" {
  description = "The list of outbound TCP ports that the Jenkins VM must be able to communicate on"
  default = []
  type = "list"
}

variable "nsg_name" {
  description = "The name of the Azure Network Security Group that we will attach our Security Rules to"
  type = "string"
}

variable "chef_user" {
  description = "The Chef server username for authentication"
  type = "string"
}

variable "chef_key_file" {
  description = "The path to the Chef server pem-file for user authentication"
  type = "string"
}

variable "chef_node_name" {
  description = "The Chef server node name"
  type = "string"
}

variable "chef_server_url" {
  description = "The Chef server URL for authentication"
  type = "string"
}

variable "chef_version" {
  description = "The specific version of Chef server that we are authenticating with"
  type = "string"
}

variable "storageacct_key" {
  description = "The Azure Storage account Access Key that will be used to mount the File Share on the Jenkins VM"
  type = "string"
}
