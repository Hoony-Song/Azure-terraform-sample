locals {
  dns_prefix             = "test-aims-k8s-32-dns"
  node_pool_name         = "agentpool2"
  cluster_name           = "test-aims-k8s-32"
  default_node_pool_name = "agentpool"
  # network_interfaces = { for idx, ni in data.azurerm_network_interface.example : ni.id => ni }
}

module "aks_kubernetes_cluster" {
  source                = "../../../modules/container/kubernetes_cluster"
  dns_prefix            = local.dns_prefix
  name                  = local.cluster_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  default_nodepool_name = local.default_node_pool_name
  domain_labels_name    = var.domain_labels_name
  enable_auto_scaling   = true
  vm_size               = "Standard_DS2_v2"
  max_count             = 4
  node_count            = 2
  min_count             = 2
  depends_on = [
    module.resource_group
  ]
}


# 클러스터를 생성하고 클러스터에 배포할 yaml이나 네임스페이스 헬름을 호출 합니다 
# 구성중에 변수가 필요하면 aks_configure 디렉토리의 variables.tf에서 구성하시면 됩니다 
module "cluster_configure" {
  source                   = "./aks_configure"
  helm_repository_password = var.helm_repository_password
  helm_repository_username = var.helm_repository_username
  public_ip                = module.aks_kubernetes_cluster.public_ip
  node_group_name          = module.aks_kubernetes_cluster.node_resource_group
  pip_name                 = module.aks_kubernetes_cluster.pip_name
  depends_on               = [module.aks_kubernetes_cluster]
}

output "external_IP" {
  value = module.aks_kubernetes_cluster.public_ip
}
output "pip_name" {
  value = module.aks_kubernetes_cluster.pip_name
}
output "node_group_name" {
  value = module.aks_kubernetes_cluster.node_resource_group
}

# 추가적인 노드풀 생성 할 때 사용합니다 
# 테스트단계라 비용때문에 주석 처리 했습니다  
# module "node_pool" {
#   source = "../../../modules/container/kubernetes_node_pool"
#   name = local.node_pool_name
#   cluster_id = module.aks_kubernetes_cluster.id
#   max_count = 2
#   min_count = 1
#   vm_size = "Standard_DS2_v2"
#   enable_auto_scaling = true
# }



# 클러스터 생성 후 kubeconfig 세팅하는 명령어가 aks_readme.md 라는 파일로 생성 합니다 
# 현재 디렉토리에서 aks_readme.md 파일을 확인후 터미널에서 명령어를 치시면 됩니다
# module "security_group" {
#   source = "../../../modules/network/security_group"
#   name = local.SG_name
#   location = var.location
#   resource_group_name = var.resource_group_name
# }

module "kubectl_output" {
  source   = "../../../modules/ETC/output_file"
  value    = templatefile("../../common/user_templates/aks_readme.tpl", { rg_name = var.resource_group_name, aks_name = local.cluster_name, pip = module.aks_kubernetes_cluster.public_ip })
  out_path = "${path.module}/aks_readme.md"
}


# data "azurerm_network_interface" "example" {
#   count               = 4
#   name                = format("%s-nic-%d", local.default_node_pool_name, count.index + 1)
#   resource_group_name = module.aks_kubernetes_cluster.node_resource_group   
#   depends_on = [ module.aks_kubernetes_cluster ]
# }

# module "interface_SG_assocition" {
#   source = "../../../modules/network/nwtwork_ISGA"
#   node_count = 4
#   network_security_group_id = module.security_group.id
#   node_resource_group = module.aks_kubernetes_cluster.node_resource_group
#   network_interface = local.network_interfaces
#   depends_on = [ data.azurerm_network_interface.example ]
# }