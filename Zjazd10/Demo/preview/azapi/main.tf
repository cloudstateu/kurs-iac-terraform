resource "azapi_resource" "acr" {
  type      = "Microsoft.ContainerRegistry/registries@2023-01-01-preview"
  name      = replace(local.acr_name, "-", "")
  parent_id = data.azapi_resource.rg_29.id

  location = data.azapi_resource.rg_29.location

  body = jsonencode({
    sku = {
      name = "Standard"
    }
    properties = {
      adminUserEnabled         = false
      networkRuleBypassOptions = "AzureServices"      
    }
  })
}