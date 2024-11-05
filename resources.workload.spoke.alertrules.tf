# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# This is the core module telemetry deployment that is only created if telemetry is enabled.
# It is deployed to the default subscription

resource "azurerm_resource_group" "mag-rg" {
  count    = var.enable_activity_monitoring ? 1 : 0
  name     = data.azurenoopsutils_resource_name.mag_rg.result
  location = module.mod_azregions.location_cli

}

resource "azurerm_monitor_action_group" "monitor_action_group" {
  count               = var.enable_activity_monitoring ? 1 : 0
  name                = data.azurenoopsutils_resource_name.mag.result
  resource_group_name = azurerm_resource_group.mag-rg[0].name
  short_name          = var.monitor_action_group_soc_short_name
  tags                = merge({ "ResourceName" = format("%s", data.azurenoopsutils_resource_name.mag.name) }, local.default_tags, var.add_tags, )

  email_receiver {
    name          = var.monitor_action_group_soc_full_name
    email_address = var.monitor_action_group_soc_email
  }
}

resource "azurerm_monitor_activity_log_alert" "activity_log_alert_security" {
  for_each            = var.enable_activity_monitoring ? toset(var.alert_rules_security_operations) : []
  name                = "Activitiy Log Alert for ${split("/", each.value)[2]} on ${split("/", each.value)[1]}"
  scopes              = [data.azurerm_subscription.current.id]
  resource_group_name = azurerm_resource_group.mag-rg[0].name
  location            = "global"
  #tags                = merge({ "ResourceName" = format("%s", data.azurenoopsutils_resource_name.mag.name) }, local.default_tags, var.add_tags, )

  criteria {
    category       = "Security"
    operation_name = each.value
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitor_action_group[0].id
  }

  depends_on = [azurerm_monitor_action_group.monitor_action_group]
}

