# yaml 파일 경로 
variable "manifests_Path" {
  type = string
}

# 템플릿 yaml 파일의 map 타입 변수( key = value )
variable "yaml_var" {
  type    = map(any)
  default = {}
}