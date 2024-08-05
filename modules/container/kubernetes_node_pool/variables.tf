variable "cluster_id" {
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
variable "name" {
  type = string
}

variable "mode" {
  type    = string
  default = "System"
}

variable "os_disk_type" {
  type    = string
  default = "Ephemeral"
}

variable "vm_size" {
  type    = string
  default = "Standard_D16as_v4"
}

variable "upgrade_max_surge" {
  type    = string
  default = "10%"
}