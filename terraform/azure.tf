terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-unyleya" {
  name     = "rg-unyleya"
  location = "Brazil South"
}

resource "azurerm_kubernetes_cluster" "cluster-unyleya" {
  name                = "aks-unyleya"
  location            = azurerm_resource_group.rg-unyleya.location
  resource_group_name = azurerm_resource_group.rg-unyleya.name
  dns_prefix          = "aksunyleya"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_container_registry" "acr-unyleya" {
  name                = "acrunyleya"
  resource_group_name = azurerm_resource_group.rg-unyleya.name
  location            = azurerm_resource_group.rg-unyleya.location
  sku                 = "Standard"
  admin_enabled       = false
}