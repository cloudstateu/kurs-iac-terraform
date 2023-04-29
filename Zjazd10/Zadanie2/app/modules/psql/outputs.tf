output "host" {
  value = azurerm_postgresql_flexible_server.psql.fqdn
}

output "administrator_login" {
  value     = azurerm_postgresql_flexible_server.psql.administrator_login
  sensitive = true
}

output "administrator_password" {
  value     = azurerm_postgresql_flexible_server.psql.administrator_password
  sensitive = true
}
