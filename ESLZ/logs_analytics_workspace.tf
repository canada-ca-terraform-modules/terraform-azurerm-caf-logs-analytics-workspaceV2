variable "log_analytics_workspace" {
  description = "Configuration for all log analytics workspace for the project"
  type = any
  default = {}
}

module "law" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-logs-analytics-workspaceV2.git?ref=v1.0.0"
  for_each = var.log_analytics_workspace

  userDefinedString = each.key
  group = var.group
  project = var.project
  env = var.env
  resource_groups = local.resource_groups_all
  logs_analytics_workspace = each.value
  tags = var.tags
}