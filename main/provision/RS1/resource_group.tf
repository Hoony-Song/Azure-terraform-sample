// 리소스 그룹을 생성합니다 
module "resource_group" {
  source   = "../../../modules/base/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.resource_tag
}