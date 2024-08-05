resource "azurerm_resource_group" "resource_group" {
  location = var.location
  name     = var.name
  #   tags = {
  #     usage = "helm, terraform test"
  #     user  = "rkkim"
  #   }
  tags = var.tags
}