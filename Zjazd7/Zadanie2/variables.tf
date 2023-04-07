locals {
  prefix          = "chm-student0"
  hub_prefix      = "${local.prefix}-hub"

  hub_vnet_address_space              = "10.0.0.0/16"
  hub_sbn_fw_management_address_space = "10.0.0.0/26"
  hub_sbn_fw_address_space            = "10.0.0.64/26"
  jumphost_vnet_address_space         = "10.1.0.0/16"
  jumphost_sbn_vm_address_space       = "10.1.0.0/24"
  spoke_vnet_address_space            = "10.2.0.0/16"
  spoke_sbn_app_address_space         = "10.2.0.0/21"
}
