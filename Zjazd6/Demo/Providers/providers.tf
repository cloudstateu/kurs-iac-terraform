terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
}

provider "azurerm" {
  alias = "hub"
  features {}
  subscription_id = "0685fd9c-4d40-4347-98b8-2c014be7272e"
}

provider "azurerm" {
  alias = "spoke"
  features {}
  subscription_id = "e0a3aa17-0bd9-4dc5-803d-6ea393ade30a"
}