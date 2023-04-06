terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
      configuration_aliases = [
        azurerm.alias
      ]
    }
  }
}
