resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                = "${local.resources.sql-database}-${var.environment}-${var.project_name}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login    = "mysqladmin"
  administrator_password = random_password.password.result

  backup_retention_days        = 7
  sku_name                     = "GP_Standard_D2ds_v4"
  version                      = "8.0.21"
  geo_redundant_backup_enabled = false
  zone                         = "1"

  delegated_subnet_id = azurerm_subnet.snet_data.id
  private_dns_zone_id = azurerm_private_dns_zone.private_dns_zones["mysql"].id

  storage {
    auto_grow_enabled = true
    iops              = 396
    size_gb           = 32
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnet_links
  ]
}

resource "azurerm_monitor_diagnostic_setting" "mysql" {
  name                       = "${local.resources.monitor-diagnostic-settings}-${local.resources.sql-database}-${var.environment}-${var.project_name}-01"
  target_resource_id         = azurerm_mysql_flexible_server.mysql.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id

  log {
    category = "MySqlSlowLogs"
    enabled  = true

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "MySqlAuditLogs"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
