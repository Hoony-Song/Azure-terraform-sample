resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  #public_ip_address_allocation = "static"
  allocation_method = var.allocation_method
  #domain_name_label            = var.name_prefix
}