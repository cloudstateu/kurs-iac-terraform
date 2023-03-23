terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "1bcf81c2-1a09-47ab-8534-8fa56dfe9832"
}
