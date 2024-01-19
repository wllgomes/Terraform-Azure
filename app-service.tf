provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice"
  location = "brazilsouth"
}

resource "azurerm_service_plan" "app" {
  name                = "webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "weblinux" {
  name                = "linuxapptest2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.app.location
  service_plan_id     = azurerm_service_plan.app.id

  site_config {}
}