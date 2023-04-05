output "environments" {
  value = local.environments
}

output "resources" {
  value = local.resources
}

output "resource_tags" {
  value = merge(var.resource_tags, var.additional_tags)
}