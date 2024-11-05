# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "netwatch" {
  depends_on = [azurerm_virtual_network.spoke_vnet]
  name       = "NetworkWatcherRG"
}

data "azurerm_virtual_network" "hub_vnet" {
  count               = var.vwan_enabled == false ? 1 : 0
  provider            = azurerm.hub_network
  name                = var.hub_virtual_network_name
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_virtual_hub" "hub" {
  count               = var.vwan_enabled == true ? 1 : 0
  provider            = azurerm.hub_network
  name                = var.hub_virtual_network_name
  resource_group_name = var.hub_resource_group_name

}
