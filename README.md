<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_datasource_windows_event.windows_event](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_datasource_windows_event) | resource |
| [azurerm_log_analytics_solution.solutions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_sentinel_log_analytics_workspace_onboarding.sentinel_onboarding](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_log_analytics_workspace_onboarding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | (Required) Env value | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | (Required) Group portion of the name of the LAW | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the LAW | `string` | `"canadacentral"` | no |
| <a name="input_logs_analytics_workspace"></a> [logs\_analytics\_workspace](#input\_logs\_analytics\_workspace) | Object containing all configuration for the LAW and associated resources | `any` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) Project portion of the name of the LAW | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Resource group object containing all the resource group for the target project | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the LAW | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) UserDefinedString portion of the name of the LAW | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_analytics_workspace_datasource_windows_event"></a> [log\_analytics\_workspace\_datasource\_windows\_event](#output\_log\_analytics\_workspace\_datasource\_windows\_event) | Outputs the data source windows event for the LAW |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | Outputs the ID of the LAW |
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | Outputs the name of the LAW |
| <a name="output_log_analytics_workspace_object"></a> [log\_analytics\_workspace\_object](#output\_log\_analytics\_workspace\_object) | Outputs the entire LAW |
| <a name="output_log_analytics_workspace_solutions"></a> [log\_analytics\_workspace\_solutions](#output\_log\_analytics\_workspace\_solutions) | Outputs the solutions for the LAW |
<!-- END_TF_DOCS -->