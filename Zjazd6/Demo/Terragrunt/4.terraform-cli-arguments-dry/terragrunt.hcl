remote_state {
  backend  = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    key = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
EOF
}

terraform {
  extra_arguments "backend_credentials" {
    commands = [
      "init"
    ]

    arguments = [
      "-backend-config=${get_terragrunt_dir()}/../terraform.tfbackend"
    ]
  }

  extra_arguments "compact_warnings" {
    commands = [
      "plan",
      "apply"
    ]

    arguments = [
      "-compact-warnings"
    ]
  }
}
