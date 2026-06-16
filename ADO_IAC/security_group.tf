// Create Network Security Group for Azure data bricks
resource "azurerm_network_security_group" "aiado_sg" {
  name                = "${terraform.workspace}-${local.project_name.name}-aiado-sg"
  resource_group_name = azurerm_resource_group.aiado_resource_group.name
  location            = azurerm_resource_group.aiado_resource_group.location
  tags                = local.tags
}

// Rule for Azure data bricks network security group
resource "azurerm_network_security_rule" "aiado_sg_rule" {
  for_each                    = { for rule in local.aiado_security_group_rules[terraform.workspace] : rule.name => rule }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.aiado_resource_group.name
  network_security_group_name = azurerm_network_security_group.aiado_sg.name
  depends_on                  = [azurerm_network_security_group.aiado_sg]
}

# Network security group association for Public Subnet
resource "azurerm_subnet_network_security_group_association" "public_nsg_assoc" {
  subnet_id                 = azurerm_subnet.vm_backend_subnet.id
  network_security_group_id = azurerm_network_security_group.aiado_sg.id
  depends_on                = [azurerm_network_security_rule.aiado_sg_rule]
}

# # Network security group association for Private Subnet
# resource "azurerm_subnet_network_security_group_association" "private_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.aiado_private_subnet.id
#   network_security_group_id = azurerm_network_security_group.aiado_sg.id
#   depends_on                = [azurerm_network_security_rule.aiado_sg_rule]
# }
