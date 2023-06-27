# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

############################
# Subnet Configuration    ##
############################

variable "subnet_address_prefix" {
  description = "The address prefixes to use for the default subnet"
  type        = list(string)
  default     = []
}

variable "subnet_service_endpoints" {
  description = "Service endpoints to add to the default subnet"
  type        = list(string)
  default     = [
    "Microsoft.Storage",
  ]
}

variable "private_endpoint_network_policies_enabled" {
  description = "Whether or not to enable network policies on the private endpoint subnet"
  default     = null
}

variable "private_link_service_network_policies_enabled" {
  description = "Whether or not to enable service endpoints on the private endpoint subnet"
  default     = null
}

variable "spoke_subnets" {
  description = "A list of subnets to add to the spoke vnet"
  type = map(object({
    #Basic info for the subnet
    name                                       = string
    address_prefixes                           = list(string)
    service_endpoints                          = list(string)
    private_endpoint_network_policies_enabled  = bool
    private_endpoint_service_endpoints_enabled = bool

    # Delegation block - see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))

    #Subnet NSG rules - see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group#security_rule
    nsg_subnet_rules = optional(list(object({
      name                                       = string
      description                                = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
    })))
  }))
}
