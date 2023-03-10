#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault
#https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks

resource "azurerm_log_analytics_workspace" "log" {
  name                = "chm-student0-log"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_key_vault" "kv" {
  name                        = "chm-student0-log-kv"
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

data "azurerm_monitor_diagnostic_categories" "kv_ds_categories" {
  resource_id = azurerm_key_vault.kv.id
}

resource "azurerm_monitor_diagnostic_setting" "log_ds" {
  name                       = "chm-student0-log-kv-ds"
  target_resource_id         = azurerm_key_vault.kv.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    enabled  = true
    category = "AllMetrics"
  }

  #  dynamic "enabled_log" {
  #    for_each = data.azurerm_monitor_diagnostic_categories.kv_ds_categories.log_category_types
  #    content {
  #      category = enabled_log.value
  #    }
  #  }
  #
  #  dynamic "metric" {
  #    for_each = data.azurerm_monitor_diagnostic_categories.kv_ds_categories.metrics
  #    content {
  #      enabled  = true
  #      category = metric.value
  #    }
  #  }
}
