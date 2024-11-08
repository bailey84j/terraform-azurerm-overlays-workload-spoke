# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a subnet in the Workload Spoke Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Workload Spoke Subnets      
AUTHOR/S: jrspinella
*/

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/service network policies, service endpoints and Delegation.
#--------------------------------------------------------------------------------------------------------

resource "azurerm_subnet" "default_snet" {
  for_each             = var.spoke_subnets
  name                 = var.custom_spoke_subnet_name != null ? "${var.custom_spoke_subnet_name}_${each.key}" : "${data.azurenoopsutils_resource_name.snet[each.key].result}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  # Applicable to the subnets which used for Private link endpoints or services 
  private_endpoint_network_policies     = lookup(each.value, "private_endpoint_network_policies_enabled", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)

  dynamic "delegation" {
    for_each = each.value["delegation"] == null ? [] : [1]
    content {
      name = each.value.delegation.name == null ? null : each.value.delegation.name
      service_delegation {
        name    = each.value.delegation.service_delegation.name == null ? null : each.value.delegation.service_delegation.name
        actions = each.value.delegation.service_delegation.actions == null ? null : each.value.delegation.service_delegation.actions
      }
    }
  }
}


