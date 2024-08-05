### 추출할 Body data가 check header로 조회 했는지 default로 조회 했는지에 따라 해당 값을 내보낸다 
### header의 값이 0보다 크다면 check_header가 동작 했을 테니 data.http.check_header_data[0].body 가 추출 되고 아니라면 data.http.check_data[0].body가 추출 된다 
output "body" {
  value = length(var.header) > 0 ? data.http.check_header_data[0].body : data.http.check_data[0].body
}
# output "status_code" {
#   value = length(var.header) > 0 ? data.http.check_header_data[0].status_code : data.http.check_data[0].status_code
# }
