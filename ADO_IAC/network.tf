# network v-net for vm
resource "azurerm_virtual_network" "vm_vnet" {
  name                = "${terraform.workspace}-${local.project_name.name}-vnet"
  address_space       = [local.vnet_cidr]
  location            = azurerm_resource_group.aiado_resource_group.location
  resource_group_name = azurerm_resource_group.aiado_resource_group.name
  tags                = local.tags
}

# Backend Subnet
resource "azurerm_subnet" "vm_backend_subnet" {
  name                 = "${terraform.workspace}-${local.project_name.name}-subnet-backend"
  resource_group_name  = azurerm_resource_group.aiado_resource_group.name
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  address_prefixes     = [cidrsubnet(local.vnet_cidr, 3, 1)] # 2^(32-24-3)= 32 bits per subnet
  depends_on           = [azurerm_virtual_network.vm_vnet]
}

// Create Public Ip for Backend Virtual Machine
resource "azurerm_public_ip" "public_ip_backend" {
  name                = "${terraform.workspace}-${local.project_name.name}-vm-pub-ip-backend"
  resource_group_name = azurerm_resource_group.aiado_resource_group.name
  location            = azurerm_resource_group.aiado_resource_group.location
  allocation_method   = "Static"
  tags                = local.tags
}

// Create Network Interface for backend Virtual Machine
resource "azurerm_network_interface" "nic_backend" {
  name                = "${terraform.workspace}-${local.project_name.name}-vm-nic-backend"
  resource_group_name = azurerm_resource_group.aiado_resource_group.name
  location            = azurerm_resource_group.aiado_resource_group.location

  ip_configuration {
    name                          = "${terraform.workspace}-ip-config"
    subnet_id                     = azurerm_subnet.vm_backend_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_backend.id
  }
  tags = local.tags
}

# // Create SSH Key for VM
# resource "tls_private_key" "ssh_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
