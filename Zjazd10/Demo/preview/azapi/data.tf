data "azapi_resource" "rg_29" {
  name      = "chm-student29"
  parent_id = "/subscriptions/${var.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2020-06-01"
}