locals {
  aims_core_properties = {
    properties_name = "aims-core-properties"
    config_map_ns   = "core"
    filepath        = "../../common/manifests/config_map/aims.properties"
  }
  aims_lbs_properties = {
    properties_name = "aims-lbs-properties"
    config_map_ns   = "aims-lbs-manager"
    filepath        = "../../common/manifests/config_map/aims.properties"
  }
  aims_ota_properties = {
    properties_name = "aims-ota-properties"
    config_map_ns   = "aims-ota-manager"
    filepath        = "../../common/manifests/config_map/aims.properties"
  }
  dashboard_properties = {
    properties_name = "dashboard-properties"
    config_map_ns   = "dashboard"
    filepath        = "../../common/manifests/config_map/aims.properties"
  }
  dashboard_service_properties = {
    properties_name = "dashboard-service-properties"
    config_map_ns   = "dashboard-service"
    filepath        = "../../common/manifests/config_map/aims.properties"
  }
  portal_properties = {
    properties_name = "portal-properties"
    config_map_ns   = "portal"
    filepath        = "../../common/manifests/config_map/aims.properties"
  }

}

# module "aims_core_properties" {
#   source = "../../../../modules/kubernetes/core/configmap/"
#   name = local.aims_core_properties.properties_name
#   namespace = local.aims_core_properties.config_map_ns
#   config_Path = local.aims_core_properties.filepath
#   depends_on = [ 
#     module.core
#    ]
# }

# module "aims_lbs_properties" {
#   source = "../../../../modules/kubernetes/core/configmap/"
#   name = local.aims_lbs_properties.properties_name
#   namespace = local.aims_lbs_properties.config_map_ns
#   config_Path = local.aims_lbs_properties.filepath
#   depends_on = [ 
#     module.aims_lbs_manager
#    ]
# }

# module "aims_ota_properties" {
#   source = "../../../../modules/kubernetes/core/configmap/"
#   name = local.aims_ota_properties.properties_name
#   namespace = local.aims_ota_properties.config_map_ns
#   config_Path = local.aims_ota_properties.filepath
#   depends_on = [ 
#     module.aims_ota_manager
#    ]
# }

# module "dashboard_properties" {
#   source = "../../../../modules/kubernetes/core/configmap/"
#   name = local.dashboard_properties.properties_name
#   namespace = local.dashboard_properties.config_map_ns
#   config_Path = local.dashboard_properties.filepath
#   depends_on = [ 
#     module.dashboard
#    ]
# }

# module "dashboard_service_properties" {
#   source = "../../../../modules/kubernetes/core/configmap/"
#   name = local.dashboard_service_properties.properties_name
#   namespace = local.dashboard_service_properties.config_map_ns
#   config_Path = local.dashboard_service_properties.filepath
#   depends_on = [ 
#     module.dashboard_service
#    ]
# }

# module "portal_properties" {
#   source = "../../../../modules/kubernetes/core/configmap/"
#   name = local.portal_properties.properties_name
#   namespace = local.portal_properties.config_map_ns
#   config_Path = local.portal_properties.filepath
#   depends_on = [ 
#     module.portal
#    ]
# }