locals {
  policy_definitions = [
    "AllowedLocations_Deny",
    "InvalidResourceTypes_Deny"
  ]
}

module "policy_definitions" {
  for_each = toset(local.policy_definitions)

  source = "./policy-definitions"

  providers = {
    azurerm.alias = azurerm
  }

  policy_name         = each.value
  management_group_id = data.azurerm_management_group.root_management_group.id
}
