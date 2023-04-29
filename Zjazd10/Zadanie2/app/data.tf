data "azurerm_client_config" "current" {
  provider = azurerm.app
}

data "azurerm_resource_group" "rg" {
  provider = azurerm.app
  name     = var.rg_name
}

data "terraform_remote_state" "shared" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.shared_state_config.resource_group_name
    storage_account_name = var.shared_state_config.storage_account_name
    container_name       = var.shared_state_config.container_name
    key                  = var.shared_state_config.key
    subscription_id      = var.shared_state_config.subscription_id
  }
}

data "http" "my_ip_address" {
  url = "https://ipv4.icanhazip.com/"
}
