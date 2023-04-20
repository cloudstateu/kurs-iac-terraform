terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.51.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  alias           = "app"
  subscription_id = var.subscription_id
}

provider "azurerm" {
  features {}
  alias           = "shared"
  subscription_id = var.shared_subscription_id
}
