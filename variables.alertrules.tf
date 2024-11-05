# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################################
# Alert Rules Configuration    ##
####################################

variable "enable_activity_monitoring" {
  description = "(Optional) Enable resource alert activity monitoring, default is false. If true, monitor action group and log alerts will be created."
  type        = bool
  default     = false
}


variable "monitor_action_group_soc_full_name" {
  description = "Full name to be used on action group"
  type        = string
  default     = "Security Operations Center"
}

variable "monitor_action_group_soc_short_name" {
  description = "Short name to be used on action group"
  type        = string
  default     = "SOC"
}

variable "monitor_action_group_soc_email" {
  description = "Email address to be used on action group"
  type        = string
  default     = "security@contoso.com"
}

variable "alert_rules_security_operations" {
  description = "(Optional) List of security operations to alert on in subscription, https://learn.microsoft.com/en-us/azure/role-based-access-control/permissions/security#microsoftsecurity"
  type        = list(string)
  default = [
    "Microsoft.Network/networkSecurityGroups/write",
    "Microsoft.Network/networkSecurityGroups/delete",
    "Microsoft.Network/networkSecurityGroups/securityRules/write",
    "Microsoft.Network/networkSecurityGroups/securityRules/delete",
    "Microsoft.Security/securitySolutions/write",
    "Microsoft.Security/securitySolutions/delete",
    "Microsoft.Sql/servers/firewallRules/write",
    "Microsoft.Sql/servers/firewallRules/delete",
  ]
  # CIS 2.0.0 Base
}


