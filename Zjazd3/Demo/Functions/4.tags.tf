// 4. TAGS
// https://developer.hashicorp.com/terraform/language/functions/formatdate
// https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static
resource "azurerm_storage_account" "storage" {
  name                     = "chmstudent0demo"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    "created_at" = formatdate("HH:mmaa", timestamp())
  }

#  lifecycle {
#    ignore_changes = [
#      tags["created_at"]
#    ]
#  }
}
