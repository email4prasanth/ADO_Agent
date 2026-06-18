// Get current Azure client configuration
data "azurerm_client_config" "current" {}

// Create Azure Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                = local.key_vault_name[terraform.workspace]
  location            = azurerm_resource_group.aiado_resource_group.location
  resource_group_name = azurerm_resource_group.aiado_resource_group.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  rbac_authorization_enabled = false

  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Update",
    "Recover",
    "Backup",
    "Restore",
    "Import",
    "Encrypt",
    "Decrypt",
    "Sign",
    "Verify",
    "WrapKey",
    "UnwrapKey",
    "Purge"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Update",
    "Import",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "ManageIssuers",
    "GetIssuers",
    "SetIssuers",
    "DeleteIssuers",
    "Purge"
  ]
}
