

locals {
  namespaces = [
    {
      name                             = "ingress-nginx"
      wait_for_default_service_account = false
    },
    {
      name                             = "cattle-system"
      wait_for_default_service_account = false
    },
    {
      name                             = "cert-manager"
      wait_for_default_service_account = false
    },
  ]
}

// 네임스페이스를 한번에 생성 하는 방법 
// locals에 네임스페이스 목록을 만들어 한번에 생성 
// 클러스터 생성시 미리 생성 해야 할 네임스페이스를 모아 두는곳 
# module "namespace" {
#   source     = "../../../../modules/kubernetes/core/namespace"
#   namespaces = local.namespaces
# }

// 네임스페이스를 단일로 생성 
// 만약 쿠버네티스 자체를 terraform 으로 관리할 때 사용 
# module "namespace_core" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name   = "core"
# }







##########################################################################################################################

# Solum 측의 helm 배포시 미리 namespace를 만들려면 아래의 주석을 풀어도 되고 리스트에 등록하셔도 됩니다 
# helm 배포시 namespace 자동생성 옵션을 true로 주시면 따로 추가는 하지 않으셔도 되지만 만약 해당 namespace 를 사용하는 yaml 파일을 배포시 
# namespace를 미리 생성 해야 합니다 

##########################################################################################################################


# module "namespace_kong" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "kong"
# }
# module "namespace_rabbitmq" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "rabbitmq-system"
# }
# module "namespace_postgresql" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "postgresql"
# }
# module "namespace_nginx-ingress" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "ingress-nginx"
# }

# module "namespace_core" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "core"
# }

# module "namespace_aims-lbs-manager" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "aims-lbs-manager"
# }

# module "namespace_aims-ota-manager" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "aims-ota-manager"
# }

# module "namespace_dashboard" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "dashboard"
# }

# module "namespace_dashboard-service" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "dashboard-service"
# }

# module "namespaceportal" {
#   source = "../../../../modules/kubernetes/core/namespace"
#   name = "portal"
# }
