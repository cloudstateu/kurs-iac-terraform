# Global Variables 

<!-- BEGIN_TF_DOCS -->
## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | n/a | `map(any)` | `null` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | n/a | <pre>object({<br>    PI          = string<br>    OwnerDev    = string<br>    OwnerAdm    = string<br>    Creator     = string<br>    Department  = string<br>    System      = string<br>    Environment = string<br>    CostCenter  = string<br>    Sensitivity = string<br>    Shared      = bool<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environments"></a> [environments](#output\_environments) | n/a |
| <a name="output_resource_tags"></a> [resource\_tags](#output\_resource\_tags) | n/a |
| <a name="output_resources"></a> [resources](#output\_resources) | n/a |
<!-- END_TF_DOCS -->