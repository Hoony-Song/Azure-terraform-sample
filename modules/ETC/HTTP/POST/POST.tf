
### http 모듈은 state 파일에 작성되는것이 아니기 때문에 apply 할 때마다 post가 실행 됨 
### 생성 전 해당 url에 이미 생성 된 data가 있는지 확인 후 없다면 생성 하도록 작성됨 
# module "check_data" {
#   source        = "../GET"
#   url           = var.url
#   content_type  = var.content_type
#   authorization = var.authorization
#   header        = var.header
#   ### 정규 표현식을 사용한다면 url 뒤에 입력될 check용 url을 추가로 넣어야 한다 
#   # check_url = var.check_url   
# }

locals {
  ### check_data GET 결과를 가져와서 리스폰스바디가 message key 의 Not Fount 인지 확인 하는 절차이며 
  ### data가 없다면 message: Not Found 라는 json 이 출력 된다 데이터가 있다면 message 라는 key는 없다 
  ### 따라서 data_exists에 message 의 값을 얻어 오지만 만약 message라는 key가 없다면 해당 데이터가 있다고 판단 found 라는 값이 저장된다 
  # data_exists = lookup(jsondecode(module.check_data.body), "message", "found")

  ### 만약 정규표현식을 사용해서 GET 조회를 해야 한다면 위의 방식보다 아래의 방식을 사용해야 한다 
  # data_exists = lookup(jsondecode(module.check_data.body), "data", "")

  ### parsed_test_values 템플릿 사용시 json 형태를 보기위해 작성됨 
  # parsed_test_values = templatefile(var.jsonPath,var.values)
}


### 정규화된 json 파일을 사용하여 post로 생성 
### 위의 locals 에서 data_exists 의 값이 Not found 이면 data 를 생성하고 found 이면 생성하지 않는다 
data "http" "post" {
  # count  = lookup(jsondecode(module.check_data.body), "message", "found") == "Not found" ? 1 : 0
  url    = var.url
  method = "POST"
  request_headers = {
    "Content-Type"  = var.content_type
    "Authorization" = var.authorization
  }
  request_body = file(var.jsonPath)
  # depends_on   = [module.check_data]
}

### 정규화된 json 파일을 사용하여 post로 생성 
### status_code가 200번이면 데이터가 있다고 판단 200이 아닌  code에 대해 생성 
### 하지만 이 부분은 충분한 검증이 필요함 정규표현식 사용시 빈데이터 출력에도 200번이 출력될 수 있음 
# data "http" "post" {
#   count = module.check_data.status_code != 200 ? 1 : 0
#   url = var.url
#   method = "POST"
#   request_headers = {
#     "Content-Type" = var.content_type
#     "Authorization" = var.authorization
#   }
#   request_body = file(var.jsonPath)
#   depends_on = [ module.check_data]  
# }





### 정규 표현식으로 GET 조회를 하면 빈 data를 얻어 오기 때문에 data_exists의 값이 비어 있다면 생성 하도록 한다 
# data "http" "post" {  
#   count = length(local.data_exists) == 0 ? 1 : 0
#   url = var.url
#   method = "POST"
#   request_headers = {
#     "Content-Type" = var.content_type
#     "Authorization" = var.authorization
#   }
#   request_body = file(var.jsonPath)
#   depends_on = [ module.check_data]  
# }


### 템플릿 형태로 post를 사용하기 위해 작성 
### 템플릿 형태가 필요한거 같으면 이 코드를 사용 
# data "http" "post_tpl" {
#   #count = local.data_exists ? 0 : 1  
#   count = local.data_exists == "Not found" ? 1 : 0
#   url = var.url
#   method = "POST"
#   request_headers = {
#     "Content-Type" = var.content_type
#     #"Authorization" = var.authorization
#   }
#   request_body = templatefile(var.jsonPath,var.values)
#   depends_on = [ module.check_data ]
# }

### 템플릿 사용시 parsed_test_values 의 json 형태를 출력하기 위해 작성 
# output "data2" {
#   value = local.parsed_test_values
# }

