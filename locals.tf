locals {
  resource_group_id = strcontains(var.logs_analytics_workspace.resource_group, "/resourceGroups/") ? var.logs_analytics_workspace.resource_group : var.resource_groups[var.logs_analytics_workspace.resource_group].id
  resource_group_name = strcontains(var.logs_analytics_workspace.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.logs_analytics_workspace.resource_group) :  var.resource_groups[var.logs_analytics_workspace.resource_group].name
}