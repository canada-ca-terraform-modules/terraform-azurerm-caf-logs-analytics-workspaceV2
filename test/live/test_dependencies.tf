# test_dependencies.tf
# Self-contained dependency resources, owned entirely by this harness.
#
# Deliberately NOT reusing any shared/production resource group: writing into
# a shared RG usually requires elevated, non-sandbox permissions. A dedicated
# throwaway RG here needs only Contributor on the sandbox subscription and
# can never collide with or affect any production resource.
#
# terraform-azurerm-caf-logs-analytics-workspaceV2 expects `resource_groups`
# to be a MAP keyed by an arbitrary name (matching `logs_analytics_workspace.resource_group`
# in the tfvars), each entry shaped { name, id } - see the module's own
# locals.tf: `var.resource_groups[var.logs_analytics_workspace.resource_group].name`.

resource "azurerm_resource_group" "live_test" {
  # PR-number suffix keeps two concurrently open PRs against this module from
  # colliding on the same sandbox resource group.
  name     = "${var.env}-caf-logs-analytics-workspaceV2-live-test-${var.pr_number}-rg"
  location = var.location

  # pr-number tag (ticket 13): lets the nightly orphan sweeper find this RG
  # by tag and match it back to a PR, independent of naming convention.
  tags = {
    "pr-number" = var.pr_number
  }
}

locals {
  resource_groups = {
    "Project" = {
      name = azurerm_resource_group.live_test.name
      id   = azurerm_resource_group.live_test.id
    }
  }
}
