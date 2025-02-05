resource "azurerm_log_analytics_workspace" "workspace" {
  name = local.log_analytics_workspace-name
  resource_group_name = local.resource_group_name
  location = var.location

  allow_resource_only_permissions = try(var.logs_analytics_workspace.allow_resource_only_permissions, true)
  local_authentication_disabled = try(var.logs_analytics_workspace.local_authentication_disabled, false)
  sku = try(var.logs_analytics_workspace.sku, "PerGB2018")
  retention_in_days = try(var.logs_analytics_workspace.retention_in_days, 30)
  daily_quota_gb = try(var.logs_analytics_workspace.daily_quota_gb, -1)
  cmk_for_query_forced = try(var.logs_analytics_workspace.cmk_for_query_forced, false)
  internet_ingestion_enabled = try(var.logs_analytics_workspace.internet_ingestion_enabled, true)
  internet_query_enabled = try(var.logs_analytics_workspace.internet_query_enabled, true)
  reservation_capacity_in_gb_per_day = try(var.logs_analytics_workspace.reservation_capacity_in_gb_per_day, null)
  data_collection_rule_id = try(var.logs_analytics_workspace.data_collection_rule_id, null)
  immediate_data_purge_on_30_days_enabled = try(var.logs_analytics_workspace.immediate_data_purge_on_30_days_enabled, false)
  tags = merge(var.tags, try(var.logs_analytics_workspace.tags, {}))

  dynamic "identity" {
    for_each = try(var.logs_analytics_workspace.identity, null) != null ? [1] : []
    content {
      type         = try(var.logs_analytics_workspace.identity.type, "SystemAssigned")
      identity_ids = try(var.logs_analytics_workspace.identity.identity_ids, [])
    }
  }
}

resource "azurerm_log_analytics_solution" "solutions" {
  for_each = try(var.logs_analytics_workspace.solutions, {})

  solution_name = each.key
  resource_group_name = azurerm_log_analytics_workspace.workspace.resource_group_name
  location = azurerm_log_analytics_workspace.workspace.location
  workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
  workspace_name = azurerm_log_analytics_workspace.workspace.name
  
  tags = merge(var.tags, try(var.logs_analytics_workspace.tags, {}))

  plan {
    publisher = each.value.publisher
    product = each.value.product
    promotion_code = try(each.value.promotion_code, null)
  }
}

resource "azurerm_log_analytics_datasource_windows_event" "windows_event" {
  for_each = try(var.logs_analytics_workspace.datasource_windows_event, {})

  name = each.key
  resource_group_name = azurerm_log_analytics_workspace.workspace.resource_group_name
  workspace_name = azurerm_log_analytics_workspace.workspace.name
  event_log_name = each.key
  event_types = each.value.event_types
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel_onboarding" {
  count = try(var.logs_analytics_workspace.sentinel_onboarding, false) ? 1 : 0

  workspace_id = azurerm_log_analytics_workspace.workspace.id
  customer_managed_key_enabled = try(var.logs_analytics_workspace.customer_managed_key_enabled, false)
}