variable "dns_prefix" {
  type = string
}
variable "location" {
  type = string
}
variable "name" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "default_nodepool_name" {
  type = string
}

variable "enable_auto_scaling" {
  type = bool
}
variable "max_count" {
  type = number
}
variable "min_count" {
  type = number
}

variable "os_disk_type" {
  type    = string
  default = "Managed"
}

variable "vm_size" {
  type    = string
  default = "Standard_D16as_v4"
}

variable "upgrade_max_surge" {
  type    = string
  default = "10%"
}
variable "node_count" {
  type    = number
  default = 2
}

variable "destination_port_range" {
  type    = string
  default = "30000-32767"
}

variable "domain_labels_name" {
  type = string
}