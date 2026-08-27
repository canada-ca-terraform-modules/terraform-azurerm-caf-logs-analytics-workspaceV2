# config/logs_analytics_workspace.tfvars
# Tracked, ready-to-run fixture for the test/live harness - one representative
# real-usage instance, not a two-code-path engineered fixture and not a
# dormant "_" template.
#
# Exercises the module's common path: default sku/retention/quota, RBAC-era
# (azurerm >= 5.0) local_authentication_enabled/internet_ingestion_access_type/
# internet_query_access_type all left on their defaults, resource_group
# resolved from the "Project" key in test_dependencies.tf's resource_groups map.

logs_analytics_workspace = {
  resource_group = "Project"
}
