resource "helm_release" "values_set" {
  count               = length(var.values_set) > 0 ? 1 : 0
  name                = var.name
  repository          = var.repository
  chart               = var.chart
  namespace           = var.namespace
  version             = var.chart_version
  create_namespace    = var.create_namespace
  dependency_update   = true
  repository_username = var.repository_username
  repository_password = var.repository_password
  dynamic "set" {
    for_each = var.values_set

    content {
      name  = set.value["name"]
      value = set.value["value"]
    }
  }
}

resource "helm_release" "values_file" {
  count               = length(var.values_file) > 0 ? 1 : 0
  name                = var.name
  repository          = var.repository
  chart               = var.chart
  namespace           = var.namespace
  version             = var.chart_version
  create_namespace    = var.create_namespace
  dependency_update   = true
  repository_username = var.repository_username
  repository_password = var.repository_password
  values = [
    templatefile(var.chart_Path, var.values_file)
  ]
}
resource "helm_release" "values_empty" {
  count               = (length(var.values_file) == 0 && length(var.values_set) == 0) ? 1 : 0
  name                = var.name
  repository          = var.repository
  chart               = var.chart
  namespace           = var.namespace
  version             = var.chart_version
  create_namespace    = var.create_namespace
  dependency_update   = true
  repository_username = var.repository_username
  repository_password = var.repository_password
}
