provider "azurerm" {
  features {
  }
skip_provider_registration = true
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice"
  location = "eastus"
}

resource "azurerm_container_registry" "acr" {
  name                = "registrycont1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_container_registry_webhook" "webhook" {
  name                = "webhooktest"
  resource_group_name = azurerm_resource_group.rg.name
  registry_name       = azurerm_container_registry.acr.name
  location            = azurerm_resource_group.rg.location

  service_uri = "https://mywebhookreceiver.example/mytag"
  status      = "enabled"
  scope       = "mytag:*"
  actions     = ["push"]
  custom_headers = {
    "Content-Type" = "application/json"
  }
}