resource "kubernetes_config_map" "configmap" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = {
    "aims.properties" = file(var.config_Path)
  }
}