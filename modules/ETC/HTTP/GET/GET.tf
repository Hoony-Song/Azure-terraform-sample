
### GET 요청에 header가 있다면 url/header 를 조회 한다 
### 이 header check는 post 생성시 중복 생성을 막으려고 check를 통해 data를 조회한다. 
data "http" "check_header_data" {
  count = length(var.header) > 0 ? 1 : 0
  url   = "${var.url}/${var.header}"
  request_headers = {
    "Content-Type"  = var.content_type
    "Authorization" = var.authorization
  }
}

### default로 GET 요청을통해 data 조회시 사용한다 
### header 가 있고 없고를 통해 분기를 나눴다 
data "http" "check_data" {
  count = length(var.header) == 0 ? 1 : 0
  url   = var.url
  request_headers = {
    "Content-Type"  = var.content_type
    "Authorization" = var.authorization
  }
}

### 해당 코드는 data 조회시 정규표현식으로 조회를 할 때 사용한다 
### 정규표현식이 아니더라도 조회가 되는것 같아서 일단 주석처리 했지만 정규표현식을 사용해야 한다면 위의 코드보다 이 코드를 사용해야 한다. 
# data "http" "check_name_data" {
#   count = (length(var.check_url) > 0 && length(var.header) > 0) ? 1 : 0
#   url = "${var.url}?${var.check_url}=${var.header}"
#   request_headers = {
#     "Content-Type" = var.content_type
#     "Authorization" = var.authorization
#   }
# }
