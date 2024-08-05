
# locals {
#   test_registry_name = "teeeestregistry"
#   #harbor_registry_name = "harbor_registry"
#   #image_registry_name = "image_registry"
# }


# // registry 모듈의 이름을 용도에 맞게 변경 하시면 좋습니다 
# // 모듈의 이름을 바꾸시면 리소스가 삭제 후 재생성 되기 때문에 한번 정하실 때 잘 정하시고 바꾸시면 안됩니다 
# module "test_registry" {
#   source = "../../../modules/container/registry"
#   // 생성된 레지스트리의 이름입니다 모듈의 이름과는 다릅니다 
#   name                = local.test_registry_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = var.resource_tag
#   admin_enabled       = true
# }

# # module "harbor_registry" {
# #   source              = "../../../moduels/container/registry"
# #   name                = local.harbor_registry_name
# #   location            = var.location
# #   resource_group_name = module.resource_group.resource_group_name
# #   tags                = var.resource_tag
# #   admin_enabled       = true
# # }

# # module "XXimage_registry" {
# #   source              = "../../../moduels/container/registry"
# #   name                = local.image_registry_name
# #   location            = var.location
# #   resource_group_name = module.resource_group.resource_group_name
# #   tags                = var.resource_tag
# #   admin_enabled       = true
# # }
