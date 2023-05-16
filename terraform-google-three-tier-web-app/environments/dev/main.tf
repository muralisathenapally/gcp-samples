module "three-tier-app" {
    source = "../../"
    for_each = var.project_config
    project_id = each.value.project_id
    region = each.value.region
    zone = each.value.zone
    deployment_name = each.value.deployment_name

}
