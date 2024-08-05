locals {
  public_IP_name = "nginx-ingress-pip"
  vnet_name      = "aims-k8s-3-vnet"
  subnet_name    = "default2"
  SG_name        = "AKS_SG32"
}

///vnet 
# module "vnet" {
#   source              = "../../../modules/network/virtual_network"
#   name                = local.vnet_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   address_space       = ["10.0.0.0/16"]
#   depends_on          = [module.resource_group]
# }

# /// 퍼블릭 ip 
# module "public_ip" {
#   source              = "../../../modules/network/publicIP"
#   name                = local.public_IP_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   depends_on          = [module.resource_group]
# }



# /// 서브넷 
# module "subnet" {
#   source              = "../../../modules/network/subnets"
#   name                = local.subnet_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   address_prefixes    = ["10.0.0.0/24"]
#   vnet_name           = module.vnet.name
#   depends_on          = [module.resource_group]
# }




