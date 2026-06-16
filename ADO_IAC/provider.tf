terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "aiado-terraform-rg"
    storage_account_name = "aiadosto"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"
  }
}