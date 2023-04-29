output "id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "key_vault_secret_provider_object_id" {
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
}

output "key_vault_secret_provider_client_id" {
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id
}
