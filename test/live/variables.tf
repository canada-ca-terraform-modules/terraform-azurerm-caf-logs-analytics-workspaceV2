variable "env" {
  description = "Environment prefix used in the generated LAW name"
  type        = string
  default     = "livetest"
}

variable "group" {
  description = "Group portion of the name of the LAW - required by terraform-azurerm-caf-logs-analytics-workspaceV2's own variables.tf"
  type        = string
  default     = "TBS"
}

variable "project" {
  description = "Project portion of the name of the LAW - required by terraform-azurerm-caf-logs-analytics-workspaceV2's own variables.tf"
  type        = string
  default     = "CORE"
}

variable "location" {
  description = "Location for the throwaway live-test resource group"
  type        = string
  default     = "canadacentral"
}

variable "tags" {
  description = "Tags applied to the LAW created by this harness"
  type        = map(string)
  default = {
    purpose = "module-live-test"
  }
}

variable "pr_number" {
  description = <<-EOT
    Suffix applied to test_dependencies.tf resource names so concurrent PRs
    against this module never collide on the same sandbox subscription. CI
    sources this from `TF_VAR_pr_number` (`github.event.number`); manual runs
    can leave the default or pass their own value.
  EOT
  type        = string
  default     = "manual"
}

variable "logs_analytics_workspace" {
  description = "LAW configuration object, passed straight through to the module under test"
  type        = any
}
