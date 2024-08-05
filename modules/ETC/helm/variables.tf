# isntall name 
variable "name" {
  type    = string
  default = "unknown"
}

variable "prefix_name" {
  type    = string
  default = "unknown"
}

# 레포 주소
variable "repository" {
  type = string
}

# 차트 이름
variable "chart" {
  type = string
}

# 네임스페이스 이름 
variable "namespace" {
  type    = string
  default = "kube-system"
}

# 차트 버전
variable "chart_version" {
  type = string
}

# values.yaml을 사용하여 설치시
variable "values_file" {
  type    = map(any)
  default = {}
}

# values 차트 경로
variable "chart_Path" {
  type    = string
  default = ""
}

# yaml을 사용하지 않고 --set 사용시 
variable "values_set" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "repository_username" {
  type    = string
  default = ""
}
variable "repository_password" {
  type    = string
  default = ""
}

variable "create_namespace" {
  type    = bool
  default = false
}
