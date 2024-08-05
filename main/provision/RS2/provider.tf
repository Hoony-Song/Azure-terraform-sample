provider "azurerm" {
  features {
  }
}

terraform {
  backend "local" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.99.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}
