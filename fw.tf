data "http" "ip_address" {
  url = "https://api.ipify.org"
  request_headers = {
    Accept = "text/plan"
  }
}

resource "azurerm_postgresql_firewall_rule" "myip" {
  name = "personalip"
  resource_group_name = azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.postgresserver.name
  start_ip_address = data.http.ip_address.body
  end_ip_address = data.http.ip_address.body
}

resource "azurerm_postgresql_firewall_rule" "allow-azservices" {
  name = "allow-azure-services"
  resource_group_name = azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.postgresserver.name
  start_ip_address = "0.0.0.0"
  end_ip_address = "0.0.0.0"
}