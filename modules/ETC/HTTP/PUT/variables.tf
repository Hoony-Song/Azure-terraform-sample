variable "url" {
  type = string
}

variable "jsonPath" {
  type = string
}
variable "content_type" {
  type    = string
  default = "application/json"
}
variable "authorization" {
  type    = string
  default = ""
}
variable "values" {
  type    = map(any)
  default = {}
}
variable "header" {
  type    = string
  default = ""
}
variable "check_url" {
  type    = string
  default = "name"
}

variable "name" {
  type    = string
  default = ""
}
variable "password" {
  type    = string
  default = ""
}