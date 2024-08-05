provider "azurerm" {
  features {}
}


# backend 를 구성하시려면 여기서 하시면 됩니다 
terraform {
  backend "local" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.99.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# 생성 한 aks 의 api과 관련된 인증서를 가져오기 위한 리소스 입니다 
data "azurerm_kubernetes_cluster" "aks" {
  name                = module.aks_kubernetes_cluster.name
  resource_group_name = module.resource_group.resource_group_name
  depends_on = [
    module.resource_group,
    module.aks_kubernetes_cluster
  ]
}

# kubeernetes 용 프로바이더 입니다 
# namespace 와 helm 에서 사용합니다 
provider "kubernetes" {
  config_path            = "~/.kube/config"
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

# helm 용 프로바이더 입니다 
# helm 에서 사용합니다 
provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml"
  repository_cache       = "${path.module}/.helm"
  kubernetes {
    config_path            = "~/.kube/config"
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
}

# kubectl 프로바이더 입니다 
# yaml 배포시 사용합니다 
# kubernetes 프로바이더와 다른 프로바이더 입니다 
# kubernetes 프로바이더에서 kubernetes_manifest를 사용하여 yaml 배포시 클러스터를 생성후에 배포 해야 한다는 단점이 있습니다 
# 관련 이슈 링크 https://github.com/hashicorp/terraform-provider-kubernetes-alpha/issues/199#issuecomment-832614387
# 클러스터 생성과 동시에 yaml 배포를 위한 프로바이더 입니다
provider "kubectl" {
  config_path            = "~/.kube/config"
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  # load_config_file       = false
}

provider "http" {}