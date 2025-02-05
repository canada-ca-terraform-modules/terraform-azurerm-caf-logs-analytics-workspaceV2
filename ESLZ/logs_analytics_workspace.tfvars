log_analytics_workspace = {
  "name" = {
    resource_group = "Project"

    # All commented out values below are shown with their default value in the module. To change these values, uncomment then modify values
    # allow_resource_only_permissions         = true              Optional: Possible value: true/false    
    # local_authentication_disabled           = false             Optional: Possible value: true/false 
    # sku                                     = "PerGB2018"       Optional: Check Terraform docs for SKUs
    # retention_in_days                       = 30                Optional: Between 30 and 730
    # daily_quota_gb                          = -1                Optional: Integer value/ -1 for disabled
    # cmk_for_query_forced                    = false             Optional: Possible value: true/false 
    # internet_ingestion_enabled              = true              Optional: Possible value: true/false 
    # internet_query_enabled                  = true              Optional: Possible value: true/false 
    # reservation_capacity_in_gb_per_day      = null              Optional: Integer value / Only relevant when SKU is CapacityReservation
    # data_collection_rule_id                 = null              Optional: Azure ID
    # immediate_data_purge_on_30_days_enabled = false             Optional: Possible value: true/false 
    # customer_managed_key_enabled = false                        Optional: Possible value: true/false

    # identity = {
    #   type = "SystemAssigned"
    #   identity_ids = null
    # }

    # Optional: Set Solutions for the workspace. Example for SecurityInsights below
    # solutions = {
    #   "SecurityInsights" = {
    #     publisher = "Microsoft"
    #     product = "OMSGallery/SecurityInsights"
    #   }
    # }

    # Optinal: Set data source for Windows event logs. Example below
    # datasource_windows_event = {
    #   "windows_event" = {
    #     event_types = ["Information", "Error", "Warning"]   # Required: Any combination of these 3 values is accepted
    #   }
    # }

  }
}
