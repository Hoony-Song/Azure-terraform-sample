variable "node_count" {
  type    = number
  default = 0
}

variable "network_security_group_id" {
  type = string
}

variable "node_resource_group" {
  type = string
}
# variable "node_pool" {
#   type = list(object({
#     name = string
#     count = number
#   }))
# }

variable "network_interface" {
  type = map(any)
}