provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "postgres-rg"
  location = "West Europe"
}

resource "azurerm_postgresql_server" "postgresserver" {
  name                = "postgresserver-tf"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  administrator_login          = "psqladmin"
  administrator_login_password = "HerrMann123!"

  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days            = 7
  geo_redundant_backup_enabled     = true
  auto_grow_enabled                = true
  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "postgresdb" {
  name = "postgresdb-tf"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresserver.name
  charset = "UTF8"
  collation = "English_United States.1252"

  lifecycle {
    prevent_destroy = false
  }
}
