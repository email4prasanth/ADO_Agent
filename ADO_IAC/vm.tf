resource "azurerm_linux_virtual_machine" "vm_backend" {
  name                = "${terraform.workspace}-${local.project_name.name}-vm-backend"
  resource_group_name = azurerm_resource_group.aiado_resource_group.name
  location            = azurerm_resource_group.aiado_resource_group.location

  size                            = local.backend_vm_config.instance_type
  admin_username                  = "adminuser"
  admin_password                  = local.vm_admin_password # Change this
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_backend.id
  ]

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = local.backend_vm_config.os_disk_type
    disk_size_gb         = local.backend_vm_config.os_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.tags
}