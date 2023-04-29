terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.53.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    http = {
      source = "hashicorp/http"
      version = "3.3.0"
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

provider "random" {
}

provider "http" {
}
