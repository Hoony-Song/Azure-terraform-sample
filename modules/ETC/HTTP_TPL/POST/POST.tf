
### http 모듈은 state 파일에 작성되는것이 아니기 때문에 apply 할 때마다 post가 실행 됨 
### 생성 전 해당 url에 이미 생성 된 data가 있는지 확인 후 없다면 생성 하도록 작성됨 

locals {
  # parsed_test_values = templatefile(var.jsonPath,var.values)
}

data "http" "post_tpl" {
  url    = var.url
  method = "POST"
  request_headers = {
    "Content-Type"  = var.content_type
    "Authorization" = var.authorization
  }
  request_body = templatefile(var.jsonPath, var.values)
}