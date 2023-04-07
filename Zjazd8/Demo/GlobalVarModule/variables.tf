module "globals" {
  source = "./modules/global-vars"
}

locals {
  prefix   = "${var.env}-${var.my_account}-"
  acr_name = "${local.prefix}${module.globals.resources.container-registry}"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "my_account" {
  type    = string
  default = "student29"
}