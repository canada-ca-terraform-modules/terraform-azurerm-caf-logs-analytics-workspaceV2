# Purpose: catch breaking resource address/argument changes before any live plan.
# Step 1 simulates a currently-deployed workspace (pre-upgrade v4-style inputs).
# Step 2 plans the current (v5-targeted) code against that state - any address
# change or accidental destroy shows up here.
mock_provider "azurerm" {}

variables {
  tags              = {}
  userDefinedString = "myapp"
  group             = "TBS"
  project           = "CORE"
  env               = "Dev"
  resource_groups = {
    rg-test = {
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test"
      name = "rg-test"
    }
  }
}

# Step 1: simulate the currently-deployed resource using legacy azurerm 4.x field names
run "baseline_apply" {
  command = apply
  variables {
    logs_analytics_workspace = {
      resource_group                = "rg-test"
      local_authentication_disabled = false
      internet_ingestion_enabled    = true
      internet_query_enabled        = true
    }
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.name == "DevCLD-myapp-3b37d93d-law"
    error_message = "Baseline apply: unexpected resource name"
  }
}

# Step 2: plan the upgraded code against that state - name/address must be unchanged,
# and the legacy fields must still translate to the same effective v5 values.
run "upgrade_plan_no_replacement" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group                = "rg-test"
      local_authentication_disabled = false
      internet_ingestion_enabled    = true
      internet_query_enabled        = true
    }
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.name == "DevCLD-myapp-3b37d93d-law"
    error_message = "Resource name must be unchanged after upgrade"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.local_authentication_enabled == true
    error_message = "legacy local_authentication_disabled=false must still translate to local_authentication_enabled=true after upgrade"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.internet_ingestion_access_type == "Enabled"
    error_message = "legacy internet_ingestion_enabled=true must still translate to internet_ingestion_access_type=Enabled after upgrade"
  }
}
