locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

inputs = {
  student_prefix          = local.common.locals.student_prefix
  vnet_name               = "vnet01"
  subnet_name             = "sbn01"
  vnet_address_space      = "10.0.0.0/16"
  subnet_address_prefixes = ["10.0.0.0/24"]
}
