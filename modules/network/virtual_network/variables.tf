variable "location" {
  type    = string
  default = "unknown"
}
variable "resource_group_name" {
  type = string
}

# variable "tags" { 
#   type = map(string)
# }
variable "name" {
  type    = string
  default = "unknown"
}
variable "address_space" {
  description = "The list of actions for the scope map."
  type        = list(string)
}