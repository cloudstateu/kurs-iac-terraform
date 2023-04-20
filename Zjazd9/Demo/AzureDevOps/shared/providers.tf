terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  alias           = "shared"
  subscription_id = var.subscription_id
}
