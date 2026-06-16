locals {
  location = "eastus"
  tags = {
    owner       = "aiado"
    environment = terraform.workspace
  }
  project_name = {
    name = "aiado"
  }

  # Define the CIDR ranges for each environment
  cidr_ranges = {
    "agent" = "10.101.0.0/24"
  }
  vnet_cidr = lookup(local.cidr_ranges, terraform.workspace)

  # Define the Azure databricks security group rules for each environment
  aiado_security_group_rules = {
    "agent" = [
      {
        name                       = "allow-all"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
  # Define VM configurations for each environment
  vm_configurations = {
    "agent" = {
      "backend" = {
        instance_type   = "Standard_D2s_v3"
        os_disk_size_gb = 128
        os_disk_type    = "StandardSSD_LRS"
      }
    }
  }
  # Helper variables for easier access
  backend_vm_config = local.vm_configurations[terraform.workspace]["backend"]

  # passwords
  vm_admin_passwords = {
    "agent" = "India@2026!Agent"
  }

  vm_admin_password = local.vm_admin_passwords[terraform.workspace]

  # Blob Storage Configuration
  blob_storage_config = {
    "agent" = {
      account_replication_type = "LRS"
      access_tier              = "Cool"
    }
  }
  blob_storage = local.blob_storage_config[terraform.workspace]
}