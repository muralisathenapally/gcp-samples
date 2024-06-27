module "alert_policies" {
  source                = "../../modules/"
  for_each              = var.alert_policies
  project_id            = each.value.project_id
  policy_name           = each.value.policy_name
  condition_name        = each.value.condition_name
  filter                = each.value.filter
  notification_channels = each.value.notification_channels
  notification_period   = each.value.notification_period
}