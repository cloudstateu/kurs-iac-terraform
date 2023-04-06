terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "0685fd9c-4d40-4347-98b8-2c014be7272e"
}
