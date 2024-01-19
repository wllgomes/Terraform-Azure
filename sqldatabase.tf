provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-sqldatabase"
  location = "brazilsouth"
}

resource "azurerm_sql_server" "sqlserver" {
  name                = "mssqlservertf1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  version                      = "12.0"
  administrator_login          = "adminsqlserver1"
  administrator_login_password = "Filtro907!@"
}

resource "azurerm_mssql_database" "mssqldatabase" {
  name         = "db_terraform"
  server_id    = azurerm_sql_server.sqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  sku_name     = "Basic"
}

resource "azurerm_sql_database" "azsqldatabase" {
  name                = "azsqldatabase-tf"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sqlserver.name
}