variable "name" {
  type    = string
  default = ""
}
variable "wait_for_default_service_account" {
  type    = bool
  default = false
}
variable "namespaces" {
  description = "List of namespaces to create"
  type = list(object({
    name                             = string
    wait_for_default_service_account = bool
  }))
  default = []
}