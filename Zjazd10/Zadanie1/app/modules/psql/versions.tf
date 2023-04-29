terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 3.53.0"
      configuration_aliases = [
        azurerm.psql
      ]
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}
