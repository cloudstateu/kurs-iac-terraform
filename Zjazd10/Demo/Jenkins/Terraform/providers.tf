terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.52.0"
    }
  }
  required_version = "> 1.0.9"
}

provider "azurerm" {
  alias           = "network"
  subscription_id = var.network_subscription_id
  features {}
}
