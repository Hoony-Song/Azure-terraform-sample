terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

locals {
  manifest_files = fileset(var.manifests_Path, "*.yaml")
}


resource "kubectl_manifest" "yaml_list" {
  for_each = { for file in local.manifest_files : file => "${var.manifests_Path}/${file}" }

  yaml_body = file(each.value)
}

resource "kubectl_manifest" "yaml" {
  count     = length(var.manifest_file) > 0 ? 1 : 0
  yaml_body = file(var.manifest_file)
}