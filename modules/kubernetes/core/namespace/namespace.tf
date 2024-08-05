resource "kubernetes_namespace_v1" "Singular_namespace" {
  count = length(var.name) > 0 ? 1 : 0
  metadata {
    name = var.name
  }
  wait_for_default_service_account = var.wait_for_default_service_account
}

resource "kubernetes_namespace_v1" "plural_namespace" {
  for_each = { for namespace in var.namespaces : namespace.name => namespace }

  metadata {
    name = each.value.name
  }

  wait_for_default_service_account = each.value.wait_for_default_service_account
}
