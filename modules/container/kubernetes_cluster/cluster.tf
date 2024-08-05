resource "azurerm_kubernetes_cluster" "cluster" {
  # automatic_channel_upgrade = "patch"
  dns_prefix          = var.dns_prefix
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name


  default_node_pool {
    enable_auto_scaling   = true
    node_count            = var.node_count
    max_count             = var.max_count
    min_count             = var.min_count
    name                  = var.default_nodepool_name
    os_disk_type          = var.os_disk_type
    vm_size               = var.vm_size
    vnet_subnet_id        = azurerm_subnet.aks_subnet.id
    enable_node_public_ip = true

    upgrade_settings {
      max_surge = var.upgrade_max_surge
    }
  }
  identity {
    type = "SystemAssigned"
  }
  # linux_profile {
  #   admin_username = "azureuser"
  #   ssh_key {
  #     key_data =file("~/.ssh/id_rsa.pub")
  #   }
  # }
  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.100.0.0/16"
    dns_service_ip     = "10.100.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }
}
resource "azurerm_user_assigned_identity" "uai" {
  name                = "myUserAssignedIdentity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "network_contributor" {
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
  role_definition_name = "Network Contributor"
  scope                = data.azurerm_resource_group.node_resource_group.id
  depends_on           = [data.azurerm_resource_group.node_resource_group]
}


resource "azurerm_virtual_network" "aks_vnet" {
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  name                = "${var.name}-vnet"
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "aks_subnet" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "${var.name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "${var.name}-vnet"

  depends_on = [
    azurerm_virtual_network.aks_vnet,
  ]
}
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "${var.name}-AKS-NSG"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "aks_nsg_nodeport_rule" {
  name                        = "${var.name}-AKS-NSG-nodeport-rule"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.destination_port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
  depends_on = [
    azurerm_network_security_group.aks_nsg,
  ]
}
resource "azurerm_network_security_rule" "aks_nsg_ssh_rule" {
  name                        = "${var.name}-AKS-NSG-ssh-rule"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "80", "8080", "443", "444", "8001", "8002", "8003"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
  depends_on = [
    azurerm_network_security_group.aks_nsg,
  ]
}


# resource "azurerm_network_security_rule" "aks_nsg_rule2" {
#   name                        = "${var.name}-AKS-NSG-rule"
#   priority                    = 1003
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = var.destination_port_range
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_kubernetes_cluster.cluster.node_resource_group
#   network_security_group_name = "aks-agentpool-10809726-nsg"
#   depends_on = [
#     azurerm_network_security_group.aks_nsg,
#   ]
# }
# resource "azurerm_network_security_rule" "aks_nsg_rule3" {
#   name                        = "${var.name}-AKS-NSG-rule2"
#   priority                    = 1004
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = 8080
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_kubernetes_cluster.cluster.node_resource_group
#   network_security_group_name = "aks-agentpool-10809726-nsg"
#   depends_on = [
#     azurerm_network_security_group.aks_nsg,
#   ]
# }

resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
  depends_on = [
    azurerm_network_security_group.aks_nsg,
    azurerm_subnet.aks_subnet
  ]
}
resource "azurerm_public_ip" "aks_pub_ip" {
  name                = "${var.name}-AKS-pub_ip"
  location            = var.location
  resource_group_name = azurerm_kubernetes_cluster.cluster.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.domain_labels_name
}
data "azurerm_resource_group" "node_resource_group" {
  name = azurerm_kubernetes_cluster.cluster.node_resource_group
}
