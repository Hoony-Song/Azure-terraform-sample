variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
# variable "vnet_name" {
#   type = string
# }

# variable "tags" { 
#   type = map(string)
# }
variable "name" {
  type = string
}
variable "allocation_method" {
  description = "The list of actions for the scope map."
  type        = string
}