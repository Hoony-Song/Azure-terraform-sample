variable "url" {
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
  default = ""
}