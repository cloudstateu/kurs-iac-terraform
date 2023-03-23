terraform {
  source = "${get_terragrunt_dir()}/../../app"
}

inputs = {
  vnet_name               = "vnet01"
  subnet_name             = "sbn01"
  vnet_address_space      = "10.0.0.0/16"
  subnet_address_prefixes = ["10.0.0.0/24"]
}
