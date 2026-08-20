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

run "naming_convention" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "rg-test"
    }
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.name == "DevCLD-myapp-3b37d93d-law"
    error_message = "Name must follow {env4}CLD-{userDefinedString}-{unique}-law convention"
  }
}

run "default_values" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "rg-test"
    }
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.allow_resource_only_permissions == true
    error_message = "allow_resource_only_permissions must default to true"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.sku == "PerGB2018"
    error_message = "sku must default to PerGB2018"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.retention_in_days == 30
    error_message = "retention_in_days must default to 30"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.daily_quota_gb == -1
    error_message = "daily_quota_gb must default to -1"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.local_authentication_enabled == true
    error_message = "local_authentication_enabled must default to true (azurerm >= 5.0)"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.internet_ingestion_access_type == "Enabled"
    error_message = "internet_ingestion_access_type must default to Enabled (azurerm >= 5.0)"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.internet_query_access_type == "Enabled"
    error_message = "internet_query_access_type must default to Enabled (azurerm >= 5.0)"
  }
}

run "name_override" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "rg-test"
      name           = "existing-law-name"
    }
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.name == "existing-law-name"
    error_message = "name override must take priority over the generated name"
  }
}

# azurerm >= 5.0 native arg names, set explicitly
run "v5_native_args" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group                 = "rg-test"
      local_authentication_enabled   = false
      internet_ingestion_access_type = "Disabled"
      internet_query_access_type     = "SecuredByPerimeter"
    }
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.local_authentication_enabled == false
    error_message = "local_authentication_enabled must be settable directly (azurerm >= 5.0 native name)"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.internet_ingestion_access_type == "Disabled"
    error_message = "internet_ingestion_access_type must be settable directly (azurerm >= 5.0 native name)"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.internet_query_access_type == "SecuredByPerimeter"
    error_message = "internet_query_access_type must be settable directly (azurerm >= 5.0 native name)"
  }
}

# Legacy azurerm 4.x argument names, translated to the azurerm >= 5.0 schema
run "legacy_v4_arg_compat" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group                = "rg-test"
      local_authentication_disabled = true
      internet_ingestion_enabled    = false
      internet_query_enabled        = false
    }
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.local_authentication_enabled == false
    error_message = "legacy local_authentication_disabled=true must translate to local_authentication_enabled=false"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.internet_ingestion_access_type == "Disabled"
    error_message = "legacy internet_ingestion_enabled=false must translate to internet_ingestion_access_type=Disabled"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.internet_query_access_type == "Disabled"
    error_message = "legacy internet_query_enabled=false must translate to internet_query_access_type=Disabled"
  }
}

run "identity_block" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "rg-test"
      identity = {
        type = "SystemAssigned"
      }
    }
  }
  assert {
    condition     = length(azurerm_log_analytics_workspace.workspace.identity) == 1
    error_message = "identity block must be emitted when supplied"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.identity[0].type == "SystemAssigned"
    error_message = "identity.type must pass through"
  }
}

run "no_identity_block" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "rg-test"
    }
  }
  assert {
    condition     = length(azurerm_log_analytics_workspace.workspace.identity) == 0
    error_message = "identity block must not be emitted when omitted"
  }
}

run "solutions" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "rg-test"
      solutions = {
        SecurityInsights = {
          publisher = "Microsoft"
          product   = "OMSGallery/SecurityInsights"
        }
      }
    }
  }
  assert {
    condition     = azurerm_log_analytics_solution.solutions["SecurityInsights"].plan[0].publisher == "Microsoft"
    error_message = "solution plan.publisher must pass through"
  }
}

run "datasource_windows_event" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "rg-test"
      datasource_windows_event = {
        windows_event = {
          event_types = ["Error", "Warning"]
        }
      }
    }
  }
  assert {
    condition     = azurerm_log_analytics_datasource_windows_event.windows_event["windows_event"].event_types == toset(["Error", "Warning"])
    error_message = "event_types must pass through"
  }
}

run "sentinel_onboarding_disabled_by_default" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "rg-test"
    }
  }
  assert {
    condition     = length(azurerm_sentinel_log_analytics_workspace_onboarding.sentinel_onboarding) == 0
    error_message = "sentinel_onboarding must default to disabled (count = 0)"
  }
}

run "sentinel_onboarding_enabled" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group               = "rg-test"
      sentinel_onboarding          = true
      customer_managed_key_enabled = true
    }
  }
  assert {
    condition     = length(azurerm_sentinel_log_analytics_workspace_onboarding.sentinel_onboarding) == 1
    error_message = "sentinel_onboarding = true must create the onboarding resource"
  }
  assert {
    condition     = azurerm_sentinel_log_analytics_workspace_onboarding.sentinel_onboarding[0].customer_managed_key_enabled == true
    error_message = "customer_managed_key_enabled must pass through"
  }
}

run "resource_group_arm_id" {
  command = plan
  variables {
    logs_analytics_workspace = {
      resource_group = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-direct"
    }
  }
  assert {
    condition     = azurerm_log_analytics_workspace.workspace.resource_group_name == "rg-direct"
    error_message = "A resource_group passed as a full ARM ID must resolve resource_group_name via regex, not map lookup"
  }
}
