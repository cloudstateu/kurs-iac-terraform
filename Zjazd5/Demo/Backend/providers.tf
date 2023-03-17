#konfiguracja backendu https://developer.hashicorp.com/terraform/language/settings/backends/configuration

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.47.0"
    }
  }
  backend "azurerm" {
#    resource_group_name  = "chm-student0"
#    storage_account_name = "chmstudent0tfstate"
#    container_name       = "tfstate"
#    key                  = "example.terraform.tfstate"
#    subscription_id      = "1bcf81c2-1a09-47ab-8534-8fa56dfe9832"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "1bcf81c2-1a09-47ab-8534-8fa56dfe9832"
}
