resource "azurerm_resource_group" "aiado_resource_group" {
  name     = "${terraform.workspace}-${local.project_name.name}-rg"
  location = local.location
  tags     = local.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.aiado_resource_group.name
}

output "resource_group_location" {
  value = azurerm_resource_group.aiado_resource_group.location
}