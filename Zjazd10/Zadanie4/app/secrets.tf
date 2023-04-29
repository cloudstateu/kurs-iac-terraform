resource "azurerm_key_vault_secret" "db_host" {
  provider     = azurerm.app
  name         = "DB-HOST"
  value        = module.psql.host
  key_vault_id = module.vault.id
}

resource "azurerm_key_vault_secret" "db_database" {
  provider     = azurerm.app
  name         = "DB-DATABASE"
  value        = "default"
  key_vault_id = module.vault.id
}

resource "azurerm_key_vault_secret" "db_username" {
  provider     = azurerm.app
  name         = "DB-USERNAME"
  value        = module.psql.administrator_login
  key_vault_id = module.vault.id
}

resource "azurerm_key_vault_secret" "db_password" {
  provider     = azurerm.app
  name         = "DB-PASSWORD"
  value        = module.psql.administrator_password
  key_vault_id = module.vault.id
}

resource "azurerm_key_vault_secret" "redis_host" {
  provider     = azurerm.app
  name         = "REDIS-HOST"
  value        = "tls://${azurerm_redis_cache.cache.hostname}"
  key_vault_id = module.vault.id
}

resource "azurerm_key_vault_secret" "redis_password" {
  provider     = azurerm.app
  name         = "REDIS-PASSWORD"
  value        = azurerm_redis_cache.cache.primary_access_key
  key_vault_id = module.vault.id
}
