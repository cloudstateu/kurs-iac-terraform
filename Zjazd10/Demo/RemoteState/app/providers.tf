terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.52.0"
    }
  }
  backend "azurerm" {
    subscription_id      = "1bcf81c2-1a09-47ab-8534-8fa56dfe9832"
    resource_group_name  = "chm-student0"
    storage_account_name = "jenkinstfstateterraform"
    container_name       = "tfstate"
    tenant_id            = "3a81269f-0731-42d7-9911-a8e9202fa750"
    key                  = "app.state.tfstate"
  }
}

provider "azurerm" {
  alias           = "app"
  subscription_id = "1bcf81c2-1a09-47ab-8534-8fa56dfe9832"
  features {}
}
