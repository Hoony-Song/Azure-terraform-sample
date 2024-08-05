variable "values" {
  type    = map(any)
  default = {}
}
variable "value" {
  type    = string
  default = ""
}

variable "out_path" {
  type = string
}

variable "tpl_path" {
  type    = string
  default = ""
}

