
locals {
  rancher = {
    name          = "rancher"
    repository    = "https://releases.rancher.com/server-charts/stable"
    chart         = "rancher"
    namespace     = "cattle-system"
    chart_version = "2.8.4"
    values_set = [
      {
        name  = "hostname",
        value = "rancher.${var.public_ip}.nip.io"
      },
      {
        name  = "replicas",
        value = 2
      },
      {
        name  = "ingress.ingressClassName",
        value = "nginx"
      },
      {
        name  = "bootstrapPassword",
        value = "test1234"
      }
    ]
  }

  cert_manager = {
    name          = "cert-manager"
    repository    = "https://charts.jetstack.io"
    chart         = "cert-manager"
    namespace     = "cert-manager"
    chart_version = "1.15.0"
    values_set = [
      {
        name  = "replicaCount",
        value = 2
      }
    ]
  }

  rancher_ns = [
    {
      name                             = "cattle-system"
      wait_for_default_service_account = false
    },
    {
      name                             = "cert-manager"
      wait_for_default_service_account = false
    },
    {
      name                             = "cattle-monitoring-system"
      wait_for_default_service_account = false
    }
  ]

  monitoring = {
    name          = "rancher-monitoring"
    repository    = "https://charts.rancher.io"
    chart         = "rancher-monitoring"
    namespace     = "cattle-monitoring-system"
    chart_version = "103.1.1"

    values_set = [
      {
        name  = "global.cattle.psp.enabled",
        value = "false",
        type  = "auto"
      },
      {
        name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage",
        value = "50Gi",
        type  = "auto"
      },
      {
        name  = "grafana.persistence.enabled",
        value = "true",
        type  = "auto"
      },
      {
        name  = "grafana.persistence.size",
        value = "10Gi",
        type  = "string"
      }
    ]
  }
  monitoring_crd = {
    name          = "rancher-monitoring-crd"
    repository    = "https://charts.rancher.io"
    chart         = "rancher-monitoring-crd"
    namespace     = "cattle-monitoring-system"
    chart_version = "103.1.1"
    values_set = [
      {
        name  = "global.cattle.psp.enabled",
        value = "false",
        type  = "auto"
      }
    ]
  }
}

// rancher 생성시 미리 생성되어야 하는 namespace 목록입니다 
// 
module "rancher_ns" {
  source     = "../../../../modules/kubernetes/core/namespace"
  namespaces = local.rancher_ns
}


// rancher 생성시 cert-manager가 필요한데 cert-manager 는 CRDS가 먼저 배포 되어 있어야 합니다 
// namespace가 먼저 생성되어 있어야 합니다 
module "cert-manager_list" {
  source         = "../../../../modules/ETC/kube"
  manifests_Path = "../../common/manifests/kube_list/cert-manager_list"
  depends_on = [
    module.rancher_ns
  ]
}

// cert-manager crds 가 생성된 후 cert-manager 를 설치 합니다 
// namespace가 먼저 생성 되어 있어야 합니다 
module "cert_manager" {
  source        = "../../../../modules/ETC/helm"
  name          = local.cert_manager.name
  repository    = local.cert_manager.repository
  chart         = local.cert_manager.chart
  namespace     = local.cert_manager.namespace
  chart_version = local.cert_manager.chart_version

  values_set = local.cert_manager.values_set
}

// rancher 설치 
// cert-manager가 먼저 설치되어 있어야 정상적인 설치가 가능합니다 
// ingress-nginx 도 rancher 보다 먼저 설치 되어 있어야 합니다 
// ingress-nginx를 먼저 설치하고 ingress-nginx-controller-admission service가 먼저 배포 되어 있어야 합니다 
module "rancher" {
  source        = "../../../../modules/ETC/helm"
  name          = local.rancher.name
  repository    = local.rancher.repository
  chart         = local.rancher.chart
  namespace     = local.rancher.namespace
  chart_version = local.rancher.chart_version
  values_set    = local.rancher.values_set
  depends_on = [
    module.rancher_ns,
    module.cert_manager,
    module.ingress-nginx
  ]
}

// rancher 모니터링 설치 하시 전에 모니터링용 crds가 먼저 배포 되어 있어야 합니다 
// namespace가 먼저 생성 되어 있어야 합니다 
module "monitoring_crd" {
  source        = "../../../../modules/ETC/helm"
  name          = local.monitoring_crd.name
  repository    = local.monitoring_crd.repository
  chart         = local.monitoring_crd.chart
  namespace     = local.monitoring_crd.namespace
  chart_version = local.monitoring_crd.chart_version
  values_set    = local.monitoring_crd.values_set
  depends_on = [
    module.rancher_ns,
  module.rancher]
}

// rancher 모니터링 설치 
// namespace와 모니터링crds가 먼저 배포 되어 있어야 합니다 
module "monitoring" {
  source        = "../../../../modules/ETC/helm"
  name          = local.monitoring.name
  repository    = local.monitoring.repository
  chart         = local.monitoring.chart
  namespace     = local.monitoring.namespace
  chart_version = local.monitoring.chart_version
  values_set    = local.monitoring.values_set
  depends_on    = [module.monitoring_crd]
}




// rancher UI api token 을 가져오기 위해 로그인 하는 부분 입니다 
// 하지만 rancher 의 CA 인증서 이슈 때문에 실행은 되지 않고 있습니다 
// terraform http provider 에선 curl -k 와 같은 인증서 무시하는 속성이 없어서 사용이 불가능 합니다만 
// AWS test시 aws acm 인증서로 테스트시 정상동작 하는것으로 확인 되었습니다
// 인증서 세팅된 후 사용 가능 합니다 

# module "rancher_get_token" {
#   source = "../../../../modules/ETC/HTTP/POST"
#   url = "http://rancher.${var.public_ip}.nip.io/v3-public/localProviders/local?action=login"
#   jsonPath = "../../common/json/http_api/rancher/admin_auth.json"
#   depends_on = [ module.rancher ]
# }



// 아래로는 rancher UI 설정 하는 부분 테스트 코드 입니다 
// AWS 에서 사용하였고 인증서 세팅 후 테스트 가능합니다 

# ==================================================================================================================================================================================


# data "http" "admin_login" {
#   url = "http://rancher.${var.public_ip}.nip.io/v3-public/localProviders/local?action=login"
#   method = "POST"
#   request_headers = {
#     "Content-Type" = "application/json"
#   }
#   request_body = jsonencode({
#     username = "admin",
#     password = "test1234"
#   })
# }


# resource "null_resource" "admin_login" {
#   provisioner "local-exec" {
#     command = <<EOT
#       curl -k -X POST https://rancher.${var.public_ip}.nip.io/v3-public/localProviders/local?action=login \
#       -H "Content-Type: application/json" \
#       -d '{"username": "admin", "password": "test1234"}' > /tmp/admin_login_response.json
#     EOT
#   }
# }
# data "local_file" "admin_login_response" {
#   depends_on = [null_resource.admin_login]
#   filename = "/tmp/admin_login_response.json"
# }



# module "rancher_create_project" {
#   source = "../../../../modules/ETC/HTTP/POST"
#   url = "http://rancher.${var.public_ip}.nip.io/v3/clusters/local/projects"
#   jsonPath = "../../common/json/http_api/rancher/create_project.json"
#   header = "monitoring-system"
#   authorization = "Bearer ${jsondecode(data.local_file.admin_login_response)["token"]}"
#   depends_on = [ module.rancher ]
# }

# curl -i -X POST http://rancher.20.39.207.243.nip.io/v3-public/localProviders/local?action=login/ \




# data "http" "create_project" {
#   url = "http://rancher.${var.public_ip}.nip.io/v3/clusters/local/projects"
#   method = "POST"
#   request_headers = {
#     "Authorization" = "Bearer ${jsondecode(data.local_file.admin_login_response.content)["token"]}"
#     "Content-Type"  = "application/json"
#   }
#   request_body = jsonencode({
#     type        = "project",
#     name        = "monitoring-system",
#     description = "Project created by Terraform"
#   })
#   depends_on = [data.local_file.admin_login_response]
# }

# resource "local_file" "admin_login_response" {
#   content  = data.http.admin_login.response_body
#   filename = "${path.module}/admin_login_response.json"
#   depends_on = [data.http.admin_login]
# }

# # data "local_file" "admin_login_response" {
# #   filename = "${path.module}/admin_login_response.json"
# # }

# # data "http" "generate_api_token" {
# #   url = "https://rancher.hoony.shop/v3/token"
# #   method = "POST"
# #   request_headers = {
# #     "Authorization" = "Bearer ${jsondecode(data.local_file.admin_login_response.content)["token"]}"
# #     "Content-Type"  = "application/json"
# #   }
# #   request_body = jsonencode({
# #     type        = "token",
# #     description = "Terraform Token"
# #   })
# #   depends_on = [ data.local_file.admin_login_response ]
# # }

# # resource "local_file" "api_token_response" {
# #   content  = data.http.generate_api_token.response_body
# #   filename = "${path.module}/api_token_response.json"
# #   depends_on = [data.http.generate_api_token]
# # }

# # data "local_file" "api_token_response_data" {
# #   filename = "${local_file.api_token_response.filename}"
# # }


# # data "http" "create_project" {
# #   url = "https://rancher.hoony.shop/v3/clusters/local/projects"
# #   method = "POST"
# #   request_headers = {
# #     "Authorization" = "Bearer ${jsondecode(data.local_file.api_token_response_data.content)["token"]}"
# #     "Content-Type"  = "application/json"
# #   }
# #   request_body = jsonencode({
# #     type        = "project",
# #     name        = "monitoring-system",
# #     description = "Project created by Terraform"
# #   })
# #   depends_on = [data.local_file.api_token_response_data]
# # }

# # data "http" "create_project2" {
# #   url = "https://rancher.hoony.shop/v3/clusters/local/projects"
# #   method = "POST"
# #   request_headers = {
# #     "Authorization" = "Bearer ${jsondecode(data.local_file.admin_login_response.content)["token"]}"
# #     "Content-Type"  = "application/json"
# #   }
# #   request_body = jsonencode({
# #     type        = "project",
# #     name        = "monitoring-system2",
# #     description = "Project created by Terraform"
# #   })
# #   depends_on = [data.local_file.api_token_response_data]
# # }

# # data "http" "enable_monitoring" {
# #   url = "https://rancher.hoony.shop/v3/project/monitoring-system/actions/enableMonitoring"
# #   method = "POST"
# #   request_headers = {
# #     "Authorization" = "Bearer ${jsondecode(data.local_file.api_token_response_data.content)["token"]}"
# #     "Content-Type"  = "application/json"
# #   }
# #   request_body = jsonencode({
# #     answers = {
# #       "exporter-node.enabled"         = "true",
# #       "exporter-kubelets.https"       = "true",
# #       "grafana.persistence.enabled"   = "true",
# #       "prometheus.persistence.enabled" = "true"
# #     },
# #     version = "1.14.0"
# #   })
# # }



# # # data "http" "install_monitoring" {
# # #   url = "https://rancher.hoony.shop/v3/project/monitoring-system/apps"
# # #   method = "POST"
# # #   request_headers = {
# # #     "Authorization" = "Bearer ${jsondecode(data.local_file.api_token_response_data.content)["token"]}"
# # #     "Content-Type"  = "application/json"
# # #   }
# # #   request_body = jsonencode({
# # #     type        = "app",
# # #     name        = "rancher-monitoring",
# # #     targetNamespace = "cattle-monitoring-system",
# # #     externalId = "catalog://?catalog=system-library&template=rancher-monitoring&version=14.5.100",
# # #     answers = {
# # #       "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage" = "50Gi",
# # #       "grafana.persistence.enabled" = "true",
# # #       "grafana.persistence.size" = "10Gi"
# # #     }
# # #   })
# # # }