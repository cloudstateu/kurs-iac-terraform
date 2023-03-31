#https://registry.terraform.io/browse/modules?page=4&provider=azurerm
#https://github.com/kumarvna?tab=repositories
module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = data.azurerm_resource_group.rg.name
  vm_os_simple        = "UbuntuServer"
  enable_ssh_key      = false
  admin_password      = "testowe123!%#@@"
  vnet_subnet_id      = module.network.vnet_subnets[0]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  use_for_each = false
}

output "public_ip" {
  value = module.linuxservers.public_ip_address
}
