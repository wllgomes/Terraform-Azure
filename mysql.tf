provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-mysql"
  location = "eastus"
}

resource "azurerm_mysql_server" "mysqlserver" {
  name                = "mysqlservertf"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name                     = "B_Gen5_2"
  storage_mb                   = 5120
  version                      = "5.7"
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = "mysqladmin"
  administrator_login_password = "H@ShICoRpDW3b8"

  infrastructure_encryption_enabled = false
  ssl_enforcement_enabled           = true
  public_network_access_enabled     = true
  auto_grow_enabled                 = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mysqldb" {
  name                = "mysqldb-tf"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}

data "http" "ip_address" {
  url = "https://api.ipify.org"
  request_headers = {
    Accept = "text/plan"
  }
}

resource "azurerm_mysql_firewall_rule" "myip" {
  name                = "personalip"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  start_ip_address    = data.http.ip_address.body
  end_ip_address      = data.http.ip_address.body
}

resource "azurerm_mysql_firewall_rule" "allow-azservices" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}