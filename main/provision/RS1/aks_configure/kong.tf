locals {
  kong = {
    name          = "kong"
    repository    = "https://charts.konghq.com"
    chart         = "kong"
    namespace     = "kong"
    chart_version = "2.15.2"
    chart_Path    = "../../common/manifests/helm/kong.yaml.tpl"
    values = {
      pip = var.public_ip
    }
  }

}




// kong 설치 전에 kong namespace 생성 합니다 
module "namespace_kong" {
  source = "../../../../modules/kubernetes/core/namespace"
  name   = "kong"
}


// kong 설치 
// kong 설치 전 namepsace 가 먼저 생성되어야 합니다  
module "kong" {
  source        = "../../../../modules/ETC/helm"
  name          = local.kong.name
  repository    = local.kong.repository
  chart         = local.kong.chart
  namespace     = local.kong.namespace
  chart_version = local.kong.chart_version
  chart_Path    = local.kong.chart_Path
  values_file   = local.kong.values
  depends_on    = [module.namespace_kong]
}

//kong 에서 service 만드는 작업 샘플 
// output_path 는 생성한 service의 json 파일을 뽑아 저장하는 경로 ( route 생성시 service 의 id를 추출 하기 위해 필요) 
module "create_service_test1" {
  source     = "../../../../modules/ETC/HTTP/POST"
  url        = "http://kongadmin.${var.public_ip}.nip.io/default/services"
  jsonPath   = "../../common/json/http_api/kong/create_service.json"
  depends_on = [module.kong]
}


# // 이것도 service 만드는 샘플 입니다 
module "create_service_test2" {
  source     = "../../../../modules/ETC/HTTP/POST"
  url        = "http://kongadmin.${var.public_ip}.nip.io/default/services"
  jsonPath   = "../../common/json/http_api/kong/create_service2.json"
  depends_on = [module.kong]
}

# // route 만드는 작업 입니다 
# // dependency 가 service 보다 나중에 생성되어야 합니다 
# // values 는 create_route.json.tpl 에서 service_id 를 넣어 주기 위함 위의 create_service_test1 모듈의 response_body를 jsoncode 형태로 변환하고 id값을 추출함 
module "create_route_test1" {
  source      = "../../../../modules/ETC/HTTP_TPL/POST"
  url         = "http://kongadmin.${var.public_ip}.nip.io/default/routes"
  jsonPath    = "../../common/json/http_api/kong/create_route.json.tpl"
  output_path = "../../common/json/http_output/kong/test-route.json"
  values      = { service_id = jsondecode(module.create_service_test1.response_body).id }
  depends_on = [
    module.kong,
    module.create_service_test1
  ]
}
