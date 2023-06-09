# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.spoke_subnets
  name                = var.custom_spoke_network_security_group_name != null ? "${var.custom_spoke_network_security_group_name}_${each.key}" : "${data.azurenoopsutils_resource_name.nsg[each.key].result}"
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "ResourceName" = lower("nsg_${each.key}") }, local.default_tags, var.add_tags, )
  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "nsg_subnet_inbound_rules", []), lookup(each.value, "nsg_subnet_outbound_rules", []))
    content {
      name                         = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      description                  = security_rule.value[1] == "" ? "Default_Rule" : security_rule.value[1]
      priority                     = security_rule.value[2]
      direction                    = security_rule.value[3] == "" ? "Inbound" : security_rule.value[3]
      access                       = security_rule.value[4] == "" ? "Allow" : security_rule.value[4]
      protocol                     = security_rule.value[5] == "" ? "Tcp" : security_rule.value[5]
      source_port_range            = "*"
      source_port_ranges           = security_rule.value[6] == [""] ? each.value.address_prefixes : security_rule.value[6]
      destination_port_ranges      = security_rule.value[7] == [""] ? ["*"] : security_rule.value[7]
      source_address_prefix        = security_rule.value[8] == [""] ? "" : security_rule.value[8]
      source_address_prefixes      = security_rule.value[9] == [""] ? each.value.address_prefixes : security_rule.value[9]
      destination_address_prefix   = security_rule.value[10] == [""] ? "" : security_rule.value[10]
      destination_address_prefixes = security_rule.value[11] == [""] ? each.value.address_prefixes : security_rule.value[11]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgassoc" {
  for_each                  = var.spoke_subnets
  subnet_id                 = azurerm_subnet.default_snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
