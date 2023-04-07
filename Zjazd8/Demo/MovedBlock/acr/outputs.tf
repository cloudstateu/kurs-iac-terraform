output "acr_id" {
  description = "Container registry id"
  value       = (var.sku == "Premium") ? azurerm_container_registry.acr_premium[0].id : azurerm_container_registry.acr_standard[0].id
}