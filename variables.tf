variable "tags" {
  description = "Tags to be applied to the LAW"
  type        = map(string)
  default     = {}
}

variable "userDefinedString" {
  description = "(Required) UserDefinedString portion of the name of the LAW"
  type = string
}

variable "group" {
  description = "(Required) Group portion of the name of the LAW"
  type = string
}

variable "project" {
  description = "(Required) Project portion of the name of the LAW"
  type = string
}

variable "env" {
  description = "(Required) Env value"
  type = string
}

variable "resource_groups" {
  description = "(Required) Resource group object containing all the resource group for the target project"
  type = any
}

variable "location" {
  description = "Azure location for the LAW"
  type = string
  default = "canadacentral"
}

variable "logs_analytics_workspace" {
  description = "Object containing all configuration for the LAW and associated resources"
  type = any
  default = {}
}