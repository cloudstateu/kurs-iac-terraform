terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "1bcf81c2-1a09-47ab-8534-8fa56dfe9832" #lab-01
  features {}
}

provider "random" {
}
