terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
}

provider "azurerm" {
  alias = "hub"
  features {}
  subscription_id = "1bcf81c2-1a09-47ab-8534-8fa56dfe9832"
}

provider "azurerm" {
  alias = "spoke"
  features {}
  subscription_id = "0685fd9c-4d40-4347-98b8-2c014be7272e"
}
