
# ../../common/manifests/kube_yaml 경로에 있는 모든 yaml 파일을 한번에 읽습니다 
# 추가로 배포 할 yaml은 설정 필요 없이 위의 경로에 yaml파일을 넣어주면 됩니다 
# namepsace가 미리 생성 되어 있어야 정상적으로 배포 됩니다 
# 배포할 yaml의 네임스페이스를 미리 namespace.tf 에서 구성 하세요 
# module "yaml_list" {
#   source         = "../../../../modules/ETC/kube"
#   manifests_Path = "../../common/manifests/kube_list"
#   depends_on = [
#     module.namespace
#   ]
# }


# 단일 yaml 배포시 이렇게 하시면 됩니다 
# 단일 yaml을 사용하는 이유는 특정 deploy에 종속적일 때 사용할 수 있습니다 
# rabbitmqcluster 는 operater가 설치 되어 있어야 해서 단일 yaml로 뺐습니다 
# module "yaml" {
#   source        = "../../../../modules/ETC/kube"
#   manifest_file = "../../common/manifests/kube_yaml/rabbitmqcluster.yaml"
#   depends_on    = [module.rabbitmq_cluster_operator]
# }




# templates yaml 파일 배포하려면 이렇게 하면 됩니다 
# namespace가 미리 생성되어 있어야 정상적으로 배포 됩니다 
locals {
  lb = {
    values = {
      node_group_name = var.node_group_name
      pip_name        = var.pip_name
    }
  }
}
# module "az_LB_manifest" {
#     source = "../../../../modules/ETC/kube_tpl"
#     manifests_Path = "../../common/manifests/kube_yaml/lb.yaml.tpl"  
#     yaml_var = local.lb.values  
# }


