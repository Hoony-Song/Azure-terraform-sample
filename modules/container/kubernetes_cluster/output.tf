output "name" {
  value = azurerm_kubernetes_cluster.cluster.name
}

output "id" {
  value = azurerm_kubernetes_cluster.cluster.id
}

output "network_interface" {
  value = azurerm_kubernetes_cluster.cluster.default_node_pool[0].node_count
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.cluster.node_resource_group
}

output "default_node_pool" {
  value = azurerm_kubernetes_cluster.cluster.default_node_pool
}
# output "node_count" {
#   value = azurerm_kubernetes_cluster.cluster.node_count
# }

output "public_ip" {
  value = azurerm_public_ip.aks_pub_ip.ip_address
}
output "pip_name" {
  value = azurerm_public_ip.aks_pub_ip.name
}