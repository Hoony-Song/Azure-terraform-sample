data "template_file" "k8s_manifest" {
  template = file("${var.manifests_Path}")
  vars     = var.yaml_var
}

resource "kubectl_manifest" "test" {
  yaml_body = data.template_file.k8s_manifest.rendered
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}