locals {
  ingress_nginx = {
    name             = "ingress-nginx"
    repository       = "https://kubernetes.github.io/ingress-nginx"
    chart            = "ingress-nginx"
    namespace        = "ingress-nginx"
    chart_version    = "4.10.1"
    create_namespace = true
    chart_Path       = "../../common/manifests/helm/ingress-nginx.yaml.tpl"
    values = {
      dns_labels_name = "oschoony",
      nodegroup_name  = var.node_group_name,
      pip_name        = var.pip_name,
      pip             = var.public_ip,
    }
  }

  
  rabbitmq_cluster_operator = {
    name          = "rabbitmq-cluster-operator"
    repository    = "https://charts.bitnami.com/bitnami"
    chart         = "rabbitmq-cluster-operator"
    namespace     = "rabbitmq-system"
    chart_version = "4.3.6"
  }

  // yaml chart 수정해야 함 
  postgrespl = {
    name          = "postgresql-ha"
    repository    = "https://charts.bitnami.com/bitnami"
    chart         = "postgresql-ha"
    namespace     = "postgresql"
    chart_version = "14.2.5"
    chart_Path    = "../../../common/manifests/helm/postgresql.yaml"
  }

  aims_lbs_manager = {
    name                = "aims-lbs-manager"
    repository          = "https://raw.githubusercontent.com/rkkim04/aims-k8s-helm/main/"
    repository_username = var.helm_repository_username
    repository_password = var.helm_repository_password
    chart               = "aims-lbs-manager"
    namespace           = "aims-lbs-manager"
    chart_version       = "1.2.3"
  }
  aims_ota_manager = {
    name                = "aims-ota-manager"
    repository          = "https://raw.githubusercontent.com/rkkim04/aims-k8s-helm/main/"
    repository_username = var.helm_repository_username
    repository_password = var.helm_repository_password
    chart               = "aims-ota-manager"
    namespace           = "aims-ota-manager"
    chart_version       = "1.2.3"
  }
  core = {
    name                = "core"
    repository          = "https://raw.githubusercontent.com/rkkim04/aims-k8s-helm/main/"
    repository_username = var.helm_repository_username
    repository_password = var.helm_repository_password
    chart               = "core"
    namespace           = "core"
    chart_version       = "1.2.3"
  }
  dashboard = {
    name                = "dashboard"
    repository          = "https://raw.githubusercontent.com/rkkim04/aims-k8s-helm/main/"
    repository_username = var.helm_repository_username
    repository_password = var.helm_repository_password
    chart               = "dashboard"
    namespace           = "dashboard"
    chart_version       = "1.2.3"
  }
  dashboard_service = {
    name                = "dashboard-service"
    repository          = "https://raw.githubusercontent.com/rkkim04/aims-k8s-helm/main/"
    repository_username = var.helm_repository_username
    repository_password = var.helm_repository_password
    chart               = "dashboard-service"
    namespace           = "dashboard-service"
    chart_version       = "1.2.3"
  }
  portal = {
    name                = "portal"
    repository          = "https://raw.githubusercontent.com/rkkim04/aims-k8s-helm/main/"
    repository_username = var.helm_repository_username
    repository_password = var.helm_repository_password
    chart               = "portal"
    namespace           = "portal"
    chart_version       = "1.2.3"
  }
}



// ingress-nginx 설치 
// public-ip 를 사용하여 ingress-nginx를 사용하기 때문에 terraform destroy시 ingress-nginx 의 loadbalancer 서비스를 먼저 삭제 해야 합니다 
// 
module "ingress-nginx" {
  source           = "../../../../modules/ETC/helm"
  name             = local.ingress_nginx.name
  repository       = local.ingress_nginx.repository
  chart            = local.ingress_nginx.chart
  namespace        = local.ingress_nginx.namespace
  chart_version    = local.ingress_nginx.chart_version
  chart_Path       = local.ingress_nginx.chart_Path
  create_namespace = local.ingress_nginx.create_namespace
  values_file      = local.ingress_nginx.values
}


# 간단한 차트 옵션으로 value_set 이용해서 생성하려면 이렇게 하면 됩니다  
# 아래는 locals에 map 형식으로 변수를 구성하는 방법입니다 
# create_namespace 옵션을 true로 생성하시면 namespace를 자동으로 생성 합니다 
# 옵션을 빼시면 자동으로 false 입니다 
# ingress_nginx = {
#     name       = "ingress-nginx"
#     repository = "https://kubernetes.github.io/ingress-nginx"
#     chart      = "ingress-nginx"
#     namespace = "ingress-nginx"
#     chart_version = "4.10.1"
#     create_namespace = true
#     values_set = [
#       { 
#         name = "controller.replicaCount",
#         value = 2,
#         type  = "auto"
#       },
#       { 
#         name = "controller.service.externalTrafficPolicy",
#         value = "Local",
#         type  = "string"
#       }
#     ]
#   }
# module "ingress_nginx" {
#   source        = "../../../../modules/ETC/helm"
#   name          = local.ingress_nginx.name
#   repository    = local.ingress_nginx.repository
#   chart         = local.ingress_nginx.chart
#   namespace     = local.ingress_nginx.namespace
#   chart_version = local.ingress_nginx.chart_version
#   values_set    = local.ingress_nginx.values_set
#   depends_on    = [module.namespace]
# }


# 복잡한 차트 옵션으로 values.yaml을 이용해서 생성하려면 이렇게 하면 됩니다 
# chart_Path에 yaml 파일 경로를 넣어주면 됩니다 
# 아래는 locals에 map 형식으로 변수를 구성하는 방법입니다 
# create_namespace 옵션을 true로 생성하시면 namespace를 자동으로 생성 합니다 
# 옵션을 빼시면 자동으로 false 입니다 
#  postgrespl = {
#     name       = "postgresql-ha"
#     repository = "https://charts.bitnami.com/bitnami"
#     chart      = "postgresql-ha"
#     namespace = "postgresql"
#     chart_version = "14.2.5"
#     create_namespace = true
#     chart_Path = "../../../common/manifests/helm/postgresql.yaml"    
#   }
# module "postgrespl" {
#   source        = "../../../../modules/ETC/helm"
#   name          = local.postgrespl.name
#   repository    = local.postgrespl.repository
#   chart         = local.postgrespl.chart
#   namespace     = local.postgrespl.namespace
#   chart_version = local.postgrespl.chart_version
#   chart_Path    = local.postgrespl.chart_Path
#   depends_on    = [module.namespace]
# }


# templates yaml을 이용해서 생성하려면 이렇게 하면 됩니다 
# chart_Path에 yaml.tpl 파일 경로를 넣어주면 됩니다 
# 아래는 locals에 map 형식으로 변수를 구성하는 방법입니다 
# create_namespace 옵션을 true로 생성하시면 namespace를 자동으로 생성 합니다 
# 옵션을 빼시면 자동으로 false 입니다 
# ingress_nginx = {
#     name       = "ingress-nginx"
#     repository = "https://kubernetes.github.io/ingress-nginx/"
#     chart      = "ingress-nginx"
#     namespace = "kube-system"
#     chart_version = "4.7.1"
#     chart_Path = "../../common/manifests/helm/nginx_sample.yaml.tpl"
#     values = {
#      replicas = 2,
#      service_type = LoadBalancer,
#    }
#   }
# module "sample-nginx" {
#   source = "../../../../modules/ETC/helm"
#   name = local.ingress_nginx.name
#   repository = local.ingress_nginx.repository
#   chart = local.ingress_nginx.chart
#   namespace = local.ingress_nginx.namespace
#   chart_version = local.ingress_nginx.chart_version
#   chart_Path = local.ingress_nginx.chart_Path
#   values_file = local.ingress_nginx.values
# }


# 차트에 옵션을 아무것도 지정하지 않고 생성하려면 이렇게 하면 됩니다 
# 아래는 locals에 map 형식으로 변수를 구성하는 방법입니다 
# create_namespace 옵션을 true로 생성하시면 namespace를 자동으로 생성 합니다 
# 옵션을 빼시면 자동으로 false 입니다 
# rabbitmq_cluster_operator = {
#     name       = "rabbitmq-cluster-operator"
#     repository = "https://charts.bitnami.com/bitnami"
#     chart      = "rabbitmq-cluster-operator"
#     namespace = "rabbitmq-system"
#     create_namespace = true
#     chart_version = "4.3.6"
#   }
# module "rabbitmq_cluster_operator" {
#   source        = "../../../../modules/ETC/helm"
#   name          = local.rabbitmq_cluster_operator.name
#   repository    = local.rabbitmq_cluster_operator.repository
#   chart         = local.rabbitmq_cluster_operator.chart
#   namespace     = local.rabbitmq_cluster_operator.namespace
#   chart_version = local.rabbitmq_cluster_operator.chart_version
#   depends_on    = [module.namespace]
# }
















##########################################################################################################################

# Solum 측의 helm 차트와 repository가 준비되면 작업

##########################################################################################################################

# module "cert_manager" {
#   source = "../../../../modules/ETC/helm"
#   name = local.cert_manager.name
#   repository = local.cert_manager.repository
#   chart = local.cert_manager.chart
#   namespace = local.cert_manager.namespace
#   chart_version = local.cert_manager.chart_version

#   values_set = local.cert_manager.values_set
# }

# module "rancher" {
#   source = "../../../../modules/ETC/helm"
#   name = local.rancher.name
#   repository = local.rancher.repository
#   chart = local.rancher.chart
#   namespace = local.rancher.namespace
#   chart_version = local.rancher.chart_version

#   values_set = local.rancher.values_set
# }

# module "aims_lbs_manager" {
#   source = "../../../../modules/ETC/helm"
#   name = local.aims_lbs_manager.name
#   repository = local.aims_lbs_manager.repository
#   chart = local.aims_lbs_manager.chart
#   namespace = local.aims_lbs_manager.namespace
#   chart_version = local.aims_lbs_manager.chart_version
#   repository_username = local.aims_lbs_manager.repository_username
#   repository_password = local.aims_lbs_manager.repository_password
# }
# module "aims_ota_manager" {
#   source = "../../../../modules/ETC/helm"
#   name = local.aims_ota_manager.name
#   repository = local.aims_ota_manager.repository
#   chart = local.aims_ota_manager.chart
#   namespace = local.aims_ota_manager.namespace
#   chart_version = local.aims_ota_manager.chart_version
#   repository_username = local.aims_ota_manager.repository_username
#   repository_password = local.aims_ota_manager.repository_password
# }
# module "core" {
#   source = "../../../../modules/ETC/helm"
#   name = local.core.name
#   repository = local.core.repository
#   chart = local.core.chart
#   namespace = local.core.namespace
#   chart_version = local.core.chart_version
#   repository_username = local.core.repository_username
#   repository_password = local.core.repository_password
# }
# module "dashboard" {
#   source = "../../../../modules/ETC/helm"
#   name = local.dashboard.name
#   repository = local.dashboard.repository
#   chart = local.dashboard.chart
#   namespace = local.dashboard.namespace
#   chart_version = local.dashboard.chart_version
#   repository_username = local.dashboard.repository_username
#   repository_password = local.dashboard.repository_password
# }
# module "dashboard_service" {
#   source = "../../../../modules/ETC/helm"
#   name = local.dashboard_service.name
#   repository = local.dashboard_service.repository
#   chart = local.dashboard_service.chart
#   namespace = local.dashboard_service.namespace
#   chart_version = local.dashboard_service.chart_version
#   repository_username = local.dashboard_service.repository_username
#   repository_password = local.dashboard_service.repository_password
# }
# module "portal" {
#   source = "../../../../modules/ETC/helm"
#   name = local.portal.name
#   repository = local.portal.repository
#   chart = local.portal.chart
#   namespace = local.portal.namespace
#   chart_version = local.portal.chart_version
#   repository_username = local.portal.repository_username
#   repository_password = local.portal.repository_password
# }