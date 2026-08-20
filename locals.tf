locals {
  resource_group_id   = strcontains(var.logs_analytics_workspace.resource_group, "/resourceGroups/") ? var.logs_analytics_workspace.resource_group : var.resource_groups[var.logs_analytics_workspace.resource_group].id
  resource_group_name = strcontains(var.logs_analytics_workspace.resource_group, "/resourceGroups/") ? regex("[^/]+$", var.logs_analytics_workspace.resource_group) : var.resource_groups[var.logs_analytics_workspace.resource_group].name

  # --- azurerm v5.0.0 compat: azurerm_log_analytics_workspace renamed 3 arguments, no deprecated alias ---
  # local_authentication_disabled (bool, v4) -> local_authentication_enabled (bool, v5, inverted meaning)
  # New arg wins if the caller explicitly sets it; otherwise fall back to the legacy bool (inverted); else default true.
  local_authentication_enabled = try(var.logs_analytics_workspace.local_authentication_enabled, null) != null ? var.logs_analytics_workspace.local_authentication_enabled : (
    try(var.logs_analytics_workspace.local_authentication_disabled, null) != null ? !var.logs_analytics_workspace.local_authentication_disabled : true
  )

  # internet_ingestion_enabled (bool, v4) -> internet_ingestion_access_type (string: Enabled/Disabled/SecuredByPerimeter, v5)
  internet_ingestion_access_type = try(var.logs_analytics_workspace.internet_ingestion_access_type, null) != null ? var.logs_analytics_workspace.internet_ingestion_access_type : (
    try(var.logs_analytics_workspace.internet_ingestion_enabled, null) != null ? (var.logs_analytics_workspace.internet_ingestion_enabled ? "Enabled" : "Disabled") : "Enabled"
  )

  # internet_query_enabled (bool, v4) -> internet_query_access_type (string, v5)
  internet_query_access_type = try(var.logs_analytics_workspace.internet_query_access_type, null) != null ? var.logs_analytics_workspace.internet_query_access_type : (
    try(var.logs_analytics_workspace.internet_query_enabled, null) != null ? (var.logs_analytics_workspace.internet_query_enabled ? "Enabled" : "Disabled") : "Enabled"
  )
}
