variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}
variable "priority" {
  type    = number
  default = 1001
}
variable "direction" {
  type    = string
  default = "Inbound"
}
variable "access" {
  type    = string
  default = "Allow"
}
variable "protocol" {
  type    = string
  default = "Tcp"
}
variable "source_port_range" {
  type    = string
  default = "*"
}
variable "destination_port_range" {
  type    = string
  default = "30000-32767"
}
variable "source_address_prefix" {
  type    = string
  default = "*"
}
variable "destination_address_prefix" {
  type    = string
  default = "*"
}