module "budgets" {
  source                      = "../../modules/"
  for_each                    = { for project in var.projects : project.project_id => project }
  project_id                  = each.value.project_id
  billing_account_id          = each.value.billing_account_id
  budget_display_name         = each.value.budget_display_name
  credit_types_treatment      = each.value.credit_types_treatment
  budget_amount               = each.value.budget_amount
  threshold_percentages       = each.value.threshold_percentages
  notification_channel_emails = each.value.notification_channel_emails
}