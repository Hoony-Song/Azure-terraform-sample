variable "name" {
  type    = string
  default = "unknown"
}
variable "location" {
  type    = string
  default = "unknown"
}
variable "resource_group_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "admin_enabled" {
  type    = bool
  default = false
}