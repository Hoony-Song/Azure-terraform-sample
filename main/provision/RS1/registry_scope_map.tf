# locals {
# }


# module "scope_repo_admin" {
#   source                  = "../../../modules/container/registry_scope_map"
#   container_registry_name = module.test_registry.name
#   name                    = "repositories-admin"
#   resource_group_name     = var.resource_group_name
#   actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write", "repositories/*/content/delete"]
#   tags                    = var.resource_tag
# }
# module "scope_repo_pull" {
#   source                  = "../../../modules/container/registry_scope_map"
#   container_registry_name = module.test_registry.name
#   name                    = "repositories-pull"
#   resource_group_name     = var.resource_group_name
#   actions                 = ["repositories/*/content/read"]
#   tags                    = var.resource_tag
# }
# module "scope_repo_pull_metadata_read" {
#   source                  = "../../../modules/container/registry_scope_map"
#   container_registry_name = module.test_registry.name
#   name                    = "repositories-pull-metadata-read"
#   resource_group_name     = var.resource_group_name
#   actions                 = ["repositories/*/content/read", "repositories/*/metadata/read"]
#   tags                    = var.resource_tag
# }
# module "scope_repo_push" {
#   source                  = "../../../modules/container/registry_scope_map"
#   container_registry_name = module.test_registry.name
#   name                    = "repositories-push"
#   resource_group_name     = var.resource_group_name
#   actions                 = ["repositories/*/content/read", "repositories/*/content/write"]
#   tags                    = var.resource_tag
# }
# module "scope_repo_push_metadata_write" {
#   source                  = "../../../modules/container/registry_scope_map"
#   container_registry_name = module.test_registry.name
#   name                    = "repositories-push-metadata-write"
#   resource_group_name     = var.resource_group_name
#   actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write"]
#   tags                    = var.resource_tag
# }