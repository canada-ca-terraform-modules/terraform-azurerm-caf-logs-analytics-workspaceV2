output "log_analytics_workspace_object" {
  description = "Outputs the entire LAW"
  value = azurerm_log_analytics_workspace.workspace
}

output "log_analytics_workspace_name" {
  description = "Outputs the name of the LAW"
  value = azurerm_log_analytics_workspace.workspace.name
}

output "log_analytics_workspace_id" {
  description = "Outputs the ID of the LAW"
  value = azurerm_log_analytics_workspace.workspace.id
}

output "log_analytics_workspace_solutions" {
  description = "Outputs the solutions for the LAW"
  value = azurerm_log_analytics_solution.solutions
}

output "log_analytics_workspace_datasource_windows_event" {
  description = "Outputs the data source windows event for the LAW"
  value = azurerm_log_analytics_datasource_windows_event.windows_event
}