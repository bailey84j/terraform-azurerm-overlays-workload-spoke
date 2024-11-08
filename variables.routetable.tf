# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Route Table Configuration    ##
#################################

variable "route_table_routes" {
  description = "A map of route table routes to add to the route table"
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = {}
}

variable "bgp_route_propagation_enabled" {
  description = "Whether to disable the default BGP route propagation on the subnet"
  default     = false
}

variable "enable_forced_tunneling_on_route_table" {
  description = "Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet"
  default     = false
}