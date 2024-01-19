provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice"
  location = "eastus"
}

resource "azurerm_servicebus_namespace" "serbus" {
  name                = "tfex-servicebus-namespace-tf-test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}