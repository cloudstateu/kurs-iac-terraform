locals {
  policy_object = jsondecode(file("${path.module}/json/${var.policy_name}.json"))

  display_name = try((local.policy_object).properties.displayName, "")
  description  = try((local.policy_object).properties.description, "")
  policy_rule  = (local.policy_object).properties.policyRule
  policy_mode  = (local.policy_object).properties.mode
  parameters   = (local.policy_object).properties.parameters
  metadata     = (local.policy_object).properties.metadata
}

resource "azurerm_policy_definition" "def" {
  provider = azurerm.alias

  name         = var.policy_name
  display_name = local.display_name
  description  = local.description
  policy_type  = "Custom"
  mode         = local.policy_mode

  management_group_id = var.management_group_id

  policy_rule = jsonencode(local.policy_rule)
  parameters  = jsonencode(local.parameters)
  metadata    = jsonencode(local.metadata)

  timeouts {
    read = "10m"
  }
}
