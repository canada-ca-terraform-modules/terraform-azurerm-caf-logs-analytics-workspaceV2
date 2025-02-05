locals {
  unique                                  = substr(sha1(local.resource_group_id), 0, 8)
  env_4                                   = substr(var.env, 0, 4)
  log_analytics_workspace-no_underscore   = replace("${local.env_4}CLD-${var.userDefinedString}", "_", "-")
  log_analytics_workspace-regex           = "/[^0-9A-Za-z-]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  log_analytics_workspace-regex_compliant = replace(local.log_analytics_workspace-no_underscore, local.log_analytics_workspace-regex, "")
  log_analytics_workspace-54              = substr(local.log_analytics_workspace-regex_compliant, 0, 54)
  log_analytics_workspace-59              = substr("${local.log_analytics_workspace-54}-${local.unique}", 0, 59)
  log_analytics_workspace-name          = "${local.log_analytics_workspace-59}-law"
}