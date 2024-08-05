resource "azurerm_subnet" "res-12" {
  address_prefixes     = var.address_prefixes
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
}