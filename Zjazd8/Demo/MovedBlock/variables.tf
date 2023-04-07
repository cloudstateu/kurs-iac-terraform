locals {
  prefix   = "${var.env}-${var.my_account}-"
  acr_name = "${local.prefix}acr"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "my_account" {
  type    = string
  default = "student29"
}

variable "access_policies_secrets" {
  type = map(object({
    permissions = list(string)
  }))
  default = {
    "secret_permissions" = {
      permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    }
  }
}