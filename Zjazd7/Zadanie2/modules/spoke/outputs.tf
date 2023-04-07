output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnets_id" {
  value = [for s in azurerm_subnet.subnets : s.id]
}
