
### data_exists 의 값이 Found 인지 Not Found 인지 출력하기 위해 작성 

output "response_body" {
  value = data.http.post_tpl.response_body
}

### status_code 출력을 위해 작성 
# output "status_code" {
#   value = module.check_data.status_code
# }