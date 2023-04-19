terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.5.0"
    }
  }
}

provider "azapi" {
  subscription_id = var.subscription_id
}