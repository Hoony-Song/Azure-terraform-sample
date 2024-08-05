variable "name" {
  type    = string
  default = "unknown"
}
variable "location" {
  type    = string
  default = "unknown"
}

variable "tags" {
  type = map(string)
}
