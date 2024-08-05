resource "azurerm_container_registry" "container_registry" {
  admin_enabled       = var.admin_enabled
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
}