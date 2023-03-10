locals {
  storage = [
    "chmstudent0sa1",
    "chmstudent0sa2",
    "chmstudent0sa3",
  ]
}

# Przykład wykorzystania length z count
# Tutaj zalecamy wykorzystanie for_each ze względu na indeks int w count!!!
resource "azurerm_storage_account" "storage" {
  count = length(local.storage)

  name                     = local.storage[count.index]
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
