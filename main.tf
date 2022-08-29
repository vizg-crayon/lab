# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

# Create a Terraform configuration with a backend configuration bloc
    backend "azurerm" {
        resource_group_name  = "vizg-rg"
        storage_account_name = "vizstorageterraform"
        container_name       = "vizcontainer"
        key                  = "terraform.tfstate"
    }

}

provider "azurerm" {
  features {}
}

# Create resources group
resource "azurerm_resource_group" "rg" {
  name     = "vizg-rg"
  location = "southeastasia"

  tags = {
    Environment = "Terraform Getting Started"
    Team        = "DevOps"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "southeastasia"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "staging"
    Team        = "DevOps"
  }
}

# Create Azure storage 
resource "azurerm_storage_account" "rg" {
  name                     = "vizstorageterraform"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
    Team        = "DevOps"
  }

}

# Create Container in azure storage
resource "azurerm_storage_container" "rg" {
  name                  = "vizcontainer"
  storage_account_name  = azurerm_storage_account.rg.name
  container_access_type = "blob"

  tags = {
    environment = "staging"
    Team        = "DevOps"
  }

}