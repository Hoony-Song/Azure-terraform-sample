resource "azurerm_virtual_network" "vnet" {
  address_space       = var.address_space
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
}