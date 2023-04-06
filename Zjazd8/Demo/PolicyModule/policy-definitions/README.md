<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm.alias"></a> [azurerm.alias](#provider\_azurerm.alias) | ~> 3.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_definition.def](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | Management group id | `string` | n/a | yes |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Policy name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_definition"></a> [definition](#output\_definition) | The complete resource node of the Policy Definition |
| <a name="output_id"></a> [id](#output\_id) | The Id of the Policy Definition |
| <a name="output_metadata"></a> [metadata](#output\_metadata) | The metadata of the Policy Definition |
| <a name="output_name"></a> [name](#output\_name) | The name of the Policy Definition |
| <a name="output_parameters"></a> [parameters](#output\_parameters) | The parameters of the Policy Definition |
| <a name="output_rules"></a> [rules](#output\_rules) | The rules of the Policy Definition |
<!-- END_TF_DOCS -->