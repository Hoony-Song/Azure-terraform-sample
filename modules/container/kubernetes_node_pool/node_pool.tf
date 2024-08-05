resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  enable_auto_scaling   = var.enable_auto_scaling
  kubernetes_cluster_id = var.cluster_id
  max_count             = var.max_count
  min_count             = var.min_count
  mode                  = var.mode
  name                  = var.name
  os_disk_type          = var.os_disk_type
  vm_size               = var.vm_size
  upgrade_settings {
    max_surge = var.upgrade_max_surge
  }
}