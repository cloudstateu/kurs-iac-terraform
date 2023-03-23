terraform {
  # source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "${get_terragrunt_dir()}/../../app"
}

inputs = {
  vnet_name               = "vnet02"
  subnet_name             = "sbn01"
  vnet_address_space      = "10.0.0.0/16"
  subnet_address_prefixes = ["10.0.0.0/24"]
}
