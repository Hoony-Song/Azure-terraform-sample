# data "azurerm_network_interface" "example" {
#   count               = var.node_count
#   name                = format("%s-nic-%d", var.node_resource_group, count.index + 1)
#   resource_group_name = var.node_resource_group  

# }
# data "azurerm_network_interface" "example" {
#   for_each = var.node_pool
#   name                = format("%s-vmss-nic-%d", each.value.name, count.index + 1)
#   resource_group_name = var.node_resource_group
# }
# data "azurerm_network_interface" "example" {
#   for_each            = { for idx, np in var.node_pool : idx => np }
#   name                = format("%s-vmss-nic-%d", var.node_resource_group, each.key + 1)
#   resource_group_name = var.node_resource_group
# }

locals {
  # network_interfaces = { for idx, ni in data.azurerm_network_interface.example : ni.id => ni }

}

resource "azurerm_network_interface_security_group_association" "aks" {
  for_each                  = var.network_interface
  network_interface_id      = each.key
  network_security_group_id = var.network_security_group_id
  # depends_on = [ data.azurerm_network_interface.example ]
}